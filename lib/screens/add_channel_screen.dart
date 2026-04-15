import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/channel.dart';

class AddChannelScreen extends StatefulWidget {
  final VoidCallback? onChannelAdded;

  const AddChannelScreen({super.key, this.onChannelAdded});

  @override
  State<AddChannelScreen> createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  ChannelType? _detectedType;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged(String url) {
    setState(() {
      _detectedType = url.isNotEmpty ? Channel.detectType(url) : null;
    });
  }

  Future<void> _saveChannel() async {
    final name = _nameController.text.trim();
    final url = _urlController.text.trim();

    if (name.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请填写频道名称和直播地址'),
          backgroundColor: AppTheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final channel = Channel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      url: url,
      type: Channel.detectType(url),
    );

    await ChannelStore.add(channel);

    if (mounted) {
      setState(() => _isSaving = false);
      _nameController.clear();
      _urlController.clear();
      setState(() => _detectedType = null);

      widget.onChannelAdded?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.secondary, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('「$name」添加成功！')),
            ],
          ),
          backgroundColor: AppTheme.surfaceContainerHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _pasteFeishuExample() {
    _nameController.text = '飞书直播';
    _urlController.text =
        'https://meetings.feishu.cn/s/1lyifyvwi01xw?src_type=3&disable_cross_redirect=true';
    _onUrlChanged(_urlController.text);
  }

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: kToolbarHeight + 40,
          left: 24,
          right: 24,
          bottom: 100,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                const SizedBox(height: 48),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          '添加频道',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
                letterSpacing: -1.0,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '输入直播流信息以扩展您的媒体库。',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          controller: _nameController,
          label: '频道名称',
          hint: '例如: 飞书直播、技术分享会',
          icon: Icons.title,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          controller: _urlController,
          label: '直播地址',
          hint: 'https://meetings.feishu.cn/s/...',
          icon: Icons.link,
          isUrl: true,
          onChanged: _onUrlChanged,
        ),

        // Auto-detected type badge
        if (_detectedType != null) ...[
          const SizedBox(height: 16),
          _buildDetectedTypeBadge(),
        ],

        const SizedBox(height: 24),

        // Quick paste Feishu example
        GestureDetector(
          onTap: _pasteFeishuExample,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDim.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.video_chat, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '快速填入飞书直播示例',
                        style: TextStyle(
                          color: AppTheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '点击自动填入飞书直播链接模板',
                        style: TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppTheme.onSurfaceVariant, size: 14),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Info box
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info_outline,
                    color: AppTheme.secondary, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '支持飞书直播链接（meetings.feishu.cn）、HLS (m3u8)、及其他 Web 直播地址。飞书直播链接将通过内置浏览器播放。',
                  style: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Save button
        ElevatedButton(
          onPressed: _isSaving ? null : _saveChannel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryDim,
            foregroundColor: AppTheme.onSurface,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            shadowColor: AppTheme.primary,
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return 8;
              }
              return 0;
            }),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: AppTheme.onSurface, strokeWidth: 2),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(width: 12),
                    Text(
                      '保存并添加',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildDetectedTypeBadge() {
    final isFeishu = _detectedType == ChannelType.feishu;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isFeishu
            ? AppTheme.primary.withValues(alpha: 0.08)
            : AppTheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFeishu
              ? AppTheme.primary.withValues(alpha: 0.2)
              : AppTheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFeishu ? Icons.video_chat : Icons.live_tv,
            color: isFeishu ? AppTheme.primary : AppTheme.secondary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '识别为: ${_getTypeName(_detectedType!)}',
            style: TextStyle(
              color: isFeishu ? AppTheme.primary : AppTheme.secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.check_circle,
            color: isFeishu ? AppTheme.primary : AppTheme.secondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  String _getTypeName(ChannelType type) {
    switch (type) {
      case ChannelType.feishu:
        return '飞书直播';
      case ChannelType.hls:
        return 'HLS 流';
      case ChannelType.rtmp:
        return 'RTMP 流';
      case ChannelType.web:
        return 'Web 页面';
      case ChannelType.unknown:
        return '未知类型';
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isUrl = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: isUrl ? TextInputType.url : TextInputType.text,
          style: const TextStyle(color: AppTheme.onSurface),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: AppTheme.outline.withValues(alpha: 0.5)),
            filled: true,
            fillColor: AppTheme.surfaceContainerLowest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppTheme.primary.withValues(alpha: 0.4), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppTheme.outlineVariant.withValues(alpha: 0.15),
                  width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
