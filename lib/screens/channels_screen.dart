import 'package:flutter/material.dart';
import '../theme.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

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
            icon: const Icon(Icons.search, color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.onSurfaceVariant),
            onPressed: () {},
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
            _buildBentoGrid(),
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
              '4 个活跃流媒体源',
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

  Widget _buildBentoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: [
        _buildChannelCard(
          icon: Icons.videocam,
          title: '主要直播出口 A',
          subtitle: 'RTMP 转发 • 1080p60',
          status: '直播中',
          isLive: true,
          stats1Icon: Icons.visibility,
          stats1Text: '1,240',
          stats2Icon: Icons.schedule,
          stats2Text: '02:45:12',
          iconColor: AppTheme.primary,
        ),
        _buildChannelCard(
          icon: Icons.star,
          title: '备用服务器 02',
          subtitle: 'SRT 安全传输模式',
          status: '待命',
          isLive: false,
          stats1Icon: Icons.dns,
          stats1Text: '北京节点',
          iconColor: AppTheme.secondary,
          iconText: '优秀',
        ),
        _buildChannelCard(
          icon: Icons.movie,
          title: '私人预览流',
          subtitle: 'WebRTC • 极低延迟模式',
          status: '直播中',
          isLive: true,
          stats1Icon: Icons.speed,
          stats1Text: '12ms 延迟',
          stats1Color: AppTheme.primary,
          iconColor: AppTheme.primary,
          borderLeftColor: AppTheme.primary,
        ),
        _buildChannelCard(
          icon: Icons.cloud_off,
          title: '归档测试频道',
          subtitle: '无活跃推流',
          status: '离线',
          isLive: false,
          iconColor: AppTheme.outline,
          isOffline: true,
        ),
      ],
    );
  }

  Widget _buildChannelCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required bool isLive,
    IconData? stats1Icon,
    String? stats1Text,
    Color? stats1Color,
    IconData? stats2Icon,
    String? stats2Text,
    required Color iconColor,
    String? iconText,
    Color? borderLeftColor,
    bool isOffline = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: borderLeftColor != null ? Border(left: BorderSide(color: borderLeftColor, width: 4)) : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: isOffline ? 0.6 : 1.0,
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
                  child: Center(
                    child: iconText != null
                        ? Text(iconText, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 12))
                        : Icon(icon, color: iconColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLive ? AppTheme.tertiary.withValues(alpha: 0.1) : (isOffline ? AppTheme.surfaceContainerHighest : AppTheme.outlineVariant.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLive) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: AppTheme.tertiary, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        status,
                        style: TextStyle(
                          color: isLive ? AppTheme.tertiary : (isOffline ? AppTheme.outline : AppTheme.onSurfaceVariant),
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
              title,
              style: const TextStyle(
                color: AppTheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            if (stats1Text != null || stats2Text != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (stats1Text != null) ...[
                    Icon(stats1Icon, size: 14, color: stats1Color ?? AppTheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      stats1Text,
                      style: TextStyle(
                        color: stats1Color ?? AppTheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (stats2Text != null) ...[
                    Icon(stats2Icon, size: 14, color: AppTheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      stats2Text,
                      style: const TextStyle(
                        color: AppTheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
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
          Text(
            '网络健康度',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 92,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(flex: 8, child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '上传: 85.2 Mbps',
                style: TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '优秀',
                style: TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '处理器',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '优秀',
                        style: TextStyle(
                          color: AppTheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '内存',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3.1G',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
