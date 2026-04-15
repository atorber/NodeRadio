import 'package:flutter/material.dart';
import '../theme.dart';
import 'dart:ui';
import 'channels_screen.dart';
import 'add_channel_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final GlobalKey<_ChannelsScreenWrapperState> _channelsKey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onChannelAdded() {
    // Switch to channels tab and reload
    setState(() {
      _selectedIndex = 0;
    });
    _channelsKey.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _ChannelsScreenWrapper(key: _channelsKey),
          AddChannelScreen(onChannelAdded: _onChannelAdded),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow.withValues(alpha: 0.8),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.surfaceTint.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.grid_view_rounded, '频道'),
                    _buildNavItem(1, Icons.add_circle_outline, '添加'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceContainerHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper to expose reload method via GlobalKey
class _ChannelsScreenWrapper extends StatefulWidget {
  const _ChannelsScreenWrapper({super.key});

  @override
  State<_ChannelsScreenWrapper> createState() => _ChannelsScreenWrapperState();
}

class _ChannelsScreenWrapperState extends State<_ChannelsScreenWrapper> {
  final GlobalKey<ChannelsScreenState> _innerKey = GlobalKey();

  void reload() {
    _innerKey.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return ChannelsScreen(key: _innerKey);
  }
}
