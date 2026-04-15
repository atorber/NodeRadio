import 'package:flutter/material.dart';
import '../theme.dart';

class AddChannelScreen extends StatelessWidget {
  const AddChannelScreen({super.key});

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
            icon: const Icon(Icons.close, color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: kToolbarHeight + 40, left: 24, right: 24, bottom: 100),
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
          label: '频道名称',
          hint: '例如: 赛博朋克 24/7',
          icon: Icons.title,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: '直播地址',
          hint: 'rtmp://... 或 https://...',
          icon: Icons.link,
          isUrl: true,
        ),
        const SizedBox(height: 32),
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
                child: const Icon(Icons.info_outline, color: AppTheme.secondary, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '支持常用的直播协议如 RTMP, HLS (m3u8) 和 DASH。请确保流地址是公开可访问的。',
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
        ElevatedButton(
          onPressed: () {},
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
              if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
                return 8;
              }
              return 0;
            }),
          ),
          child: const Row(
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

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isUrl = false,
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
          keyboardType: isUrl ? TextInputType.url : TextInputType.text,
          style: const TextStyle(color: AppTheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.outline.withValues(alpha: 0.5)),
            filled: true,
            fillColor: AppTheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primary.withValues(alpha: 0.4), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.15), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
