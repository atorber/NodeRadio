import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:ui';

class PlaybackScreen extends StatelessWidget {
  const PlaybackScreen({super.key});

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
            const SizedBox(width: 8),
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
          Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppTheme.onSurfaceVariant),
                child: const Text('频道', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppTheme.onSurface),
                child: const Text('播放', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppTheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: kToolbarHeight + 40, left: 16, right: 16, bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildVideoArea(context),
              const SizedBox(height: 48),
              _buildActionButtons(context),
              const SizedBox(height: 48),
              const Text(
                '高保真安全流',
                style: TextStyle(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoArea(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
          // Simulated Video Background
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCCtjCdx-oOj-x-xrs0G_g8geHW-WXTl1OwZhFpe2LerTlkHAmrn7wBRktyT4K34ujiBzxLFUbiHaA-ibJ14ZZDHARrw835bfilPxl72T4xGXJiVppHcJAJGOcJj0xDcLescox8eKKSjMLXzM7C9fSZbqqieUCCcYvatT_HhF6ry0LJ8Yo5x7BxyXS3K4osRV0zZhvEYreK9CnYD1QrV194siJqekGShKgbLIxng__UUkOysJ6syeDDLsIzERbuAWW2RLYMfKlTakiN',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  opacity: const AlwaysStoppedAnimation(0.6),
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.black54),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.transparent, AppTheme.background.withValues(alpha: 0.8)],
                      radius: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Overlay Elements
          Positioned(
            top: 24,
            left: 24,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppTheme.tertiary.withValues(alpha: 0.4), blurRadius: 12),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: AppTheme.onTertiaryContainer, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '直播中',
                        style: TextStyle(
                          color: AppTheme.onTertiaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '正在播放',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),
          // Central Focus
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
                  ),
                  child: const Center(
                    child: Icon(Icons.graphic_eq, color: AppTheme.secondaryDim, size: 48),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Shadow
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 96,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [AppTheme.background.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryDim,
              foregroundColor: AppTheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
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
                Icon(Icons.play_arrow, size: 32),
                SizedBox(width: 12),
                Text('开始播放', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Manrope')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceContainerHigh,
              foregroundColor: AppTheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.15)),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stop_circle, color: AppTheme.secondary, size: 32),
                SizedBox(width: 12),
                Text('停止播放', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Manrope')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
