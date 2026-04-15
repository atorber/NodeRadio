import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/channel.dart';
import 'webview_player_screen.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => ChannelsScreenState();
}

class ChannelsScreenState extends State<ChannelsScreen> {
  List<Channel> _channels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    final channels = await ChannelStore.load();
    if (mounted) {
      setState(() {
        _channels = channels;
        _isLoading = false;
      });
    }
  }

  void _openChannel(Channel channel) {
    if (channel.isWebPlayable) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WebViewPlayerScreen(channel: channel),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('暂不支持 ${channel.typeLabel} 类型的播放'),
          backgroundColor: AppTheme.surfaceContainerHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _deleteChannel(Channel channel) async {
    await ChannelStore.remove(channel.id);
    _loadChannels();
  }

  /// Reload channels from outside (called after adding a new channel)
  void reload() => _loadChannels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppTheme.background.withValues(alpha: 0.9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Icon(Icons.sensors, color: AppTheme.surfaceTint),
            const SizedBox(width: 12),
            Text(
              'NEON NOCTURNE',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.surfaceTint,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.onSurfaceVariant),
            onPressed: _loadChannels,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: kToolbarHeight + 40, left: 24, right: 24, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ),
              )
            else if (_channels.isEmpty)
              _buildEmptyState(context)
            else
              _buildChannelList(),
            const SizedBox(height: 48),
            _buildSystemStatusBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我的频道',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppTheme.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_channels.length} 个频道',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.sensors_off, color: AppTheme.onSurfaceVariant, size: 36),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有频道',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击底部「添加」标签来创建你的第一个频道\n支持飞书直播、HLS、Web 等类型',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelList() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: _channels.map((ch) => _buildChannelCard(ch)).toList(),
    );
  }

  Widget _buildChannelCard(Channel channel) {
    final IconData icon;
    final Color iconColor;
    switch (channel.type) {
      case ChannelType.feishu:
        icon = Icons.video_chat;
        iconColor = AppTheme.primary;
      case ChannelType.hls:
        icon = Icons.live_tv;
        iconColor = AppTheme.secondary;
      case ChannelType.rtmp:
        icon = Icons.videocam;
        iconColor = AppTheme.tertiary;
      case ChannelType.web:
        icon = Icons.language;
        iconColor = AppTheme.secondaryDim;
      case ChannelType.unknown:
        icon = Icons.help_outline;
        iconColor = AppTheme.outline;
    }

    return GestureDetector(
      onTap: () => _openChannel(channel),
      onLongPress: () => _showDeleteDialog(channel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: channel.type == ChannelType.feishu
              ? Border(left: BorderSide(color: AppTheme.primary, width: 4))
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, color: iconColor)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: channel.isWebPlayable
                        ? AppTheme.tertiary.withValues(alpha: 0.1)
                        : AppTheme.outlineVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (channel.isWebPlayable) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        channel.isWebPlayable ? '可播放' : '待配置',
                        style: TextStyle(
                          color: channel.isWebPlayable
                              ? AppTheme.tertiary
                              : AppTheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              channel.name,
              style: const TextStyle(
                color: AppTheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              channel.typeLabel,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.play_circle_fill, size: 14, color: iconColor),
                const SizedBox(width: 4),
                const Text(
                  '点击播放',
                  style: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Channel channel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('删除频道', style: TextStyle(color: AppTheme.onSurface)),
        content: Text(
          '确定要删除「${channel.name}」吗？',
          style: const TextStyle(color: AppTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AppTheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteChannel(channel);
            },
            child: const Text('删除', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.secondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '使用提示',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('支持飞书直播链接，通过内置浏览器播放'),
          const SizedBox(height: 8),
          _buildTipItem('支持 HLS (m3u8) 和通用 Web 直播地址'),
          const SizedBox(height: 8),
          _buildTipItem('长按频道卡片可以删除频道'),
          const SizedBox(height: 8),
          _buildTipItem('播放时可全屏横屏观看'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 5, color: AppTheme.onSurfaceVariant),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
