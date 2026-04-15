import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:audio_session/audio_session.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import '../theme.dart';
import '../models/channel.dart';

class WebViewPlayerScreen extends StatefulWidget {
  final Channel channel;

  const WebViewPlayerScreen({super.key, required this.channel});

  @override
  State<WebViewPlayerScreen> createState() => _WebViewPlayerScreenState();
}

class _WebViewPlayerScreenState extends State<WebViewPlayerScreen> {
  final GlobalKey _webViewKey = GlobalKey();
  InAppWebViewController? _controller;
  
  late final InAppWebViewSettings _settings;
  
  bool _isLoading = true;
  int _loadingProgress = 0;
  bool _isFullscreen = false;
  final SimplePip _pip = SimplePip();

  @override
  void initState() {
    super.initState();
    
    _settings = InAppWebViewSettings(
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      allowBackgroundAudioPlaying: true,
      userAgent: 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    );
    
    _initAudioSession();
    _setupPip();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> _setupPip() async {
    try {
      final isAvailable = await SimplePip.isPipAvailable;
      if (isAvailable) {
        await _pip.setAutoPipMode();
      }
    } catch (e) {
      debugPrint('PiP setup error: \$e');
    }
  }

  void _injectImmersiveMode({bool showToast = false}) {
    if (showToast && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已尝试进入网页沉浸模式。')),
      );
    }
    // Run a heuristic script that attempts to maximize the video wrapper
    _controller?.evaluateJavascript(source: '''
      (function() {
        var attempts = 0;
        var maxAttempts = 10; // Try for 10 seconds
        
        function applyImmersive() {
          var applied = false;
          // Attempt 1: Find any <video> tag and force it to be fullscreen
          var vids = document.getElementsByTagName('video');
          if (vids.length > 0) {
             var vid = vids[0];
             var container = vid.closest('.xgplayer') || vid.closest('.video-container') || vid.parentNode;
             if(container) {
                container.style.position = 'fixed';
                container.style.top = '0';
                container.style.left = '0';
                container.style.width = '100vw';
                container.style.height = '100vh';
                container.style.zIndex = '999999';
                container.style.backgroundColor = 'black';
                applied = true;
             }
          }
          
          // Hide common Feishu / meeting web headers and sidebars
          var elementsToHide = document.querySelectorAll(
            '.header, [class*="header"], [class*="Header"], ' + 
            '.sidebar, [class*="sidebar"], [class*="Sidebar"], ' + 
            '.chat, [class*="chat"], .toolbar, [class*="bottom-bar"]'
          );
          elementsToHide.forEach(function(el) {
             if (!el.querySelector('video') && !el.closest('video')) {
                el.style.display = 'none';
             }
          });
          
          document.body.style.margin = '0';
          document.body.style.padding = '0';
          document.body.style.overflow = 'hidden';
          
          return applied;
        }

        // Try immediately
        applyImmersive();

        // Check iteratively in case the SPA loads the video framework lazily
        var intervalHandler = setInterval(function() {
           attempts++;
           if(applyImmersive() || attempts >= maxAttempts) {
              clearInterval(intervalHandler);
           }
        }, 1000);
      })();
    ''');
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _enterPipManually() async {
    try {
      final isAvailable = await SimplePip.isPipAvailable;
      if (isAvailable) {
        _pip.enterPipMode();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('当前设备不支持画中画模式'),
              backgroundColor: AppTheme.surfaceContainerHigh,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Enter PiP manually error: \$e');
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
  
  Widget _buildWebView() {
    // KeepAlive is configured by GlobalKey _webViewKey to avoid rebuilding
    return InAppWebView(
      key: _webViewKey,
      initialUrlRequest: URLRequest(url: WebUri(widget.channel.url)),
      initialSettings: _settings,
      onWebViewCreated: (controller) {
        _controller = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          _isLoading = true;
        });
      },
      onLoadStop: (controller, url) async {
        setState(() {
          _isLoading = false;
        });
        _injectImmersiveMode();
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          _loadingProgress = progress;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PipWidget(
      pipChild: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _buildWebView(),
        ),
      ),
      child: _buildMainView(),
    );
  }

  Widget _buildMainView() {
    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildWebView(),
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: _buildIconButton(
                  icon: Icons.fullscreen_exit,
                  onTap: _toggleFullscreen,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppTheme.background.withValues(alpha: 0.95),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.onSurface, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.channel.name,
              style: const TextStyle(
                color: AppTheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.channel.typeLabel,
                  style: const TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _buildIconButton(
            icon: Icons.center_focus_strong,
            onTap: () => _injectImmersiveMode(showToast: true),
          ),
          const SizedBox(width: 4),
          _buildIconButton(
            icon: Icons.picture_in_picture_alt,
            onTap: _enterPipManually,
          ),
          const SizedBox(width: 4),
          _buildIconButton(
            icon: Icons.fullscreen,
            onTap: _toggleFullscreen,
          ),
          const SizedBox(width: 4),
          _buildIconButton(
            icon: Icons.refresh,
            onTap: () => _controller?.reload(),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          // Loading progress bar
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadingProgress / 100.0,
              backgroundColor: AppTheme.surfaceContainerLow,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              minHeight: 2,
            ),
          // WebView
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _buildWebView(),
            ),
          ),
          // Bottom info bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.onSurfaceVariant, size: 20),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: AppTheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
               color: AppTheme.tertiaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '直播中',
                  style: TextStyle(
                    color: AppTheme.tertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.channel.url,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.channel.url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('链接已复制'),
                  backgroundColor: AppTheme.surfaceContainerHigh,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Icon(Icons.copy, color: AppTheme.onSurfaceVariant, size: 16),
          ),
        ],
      ),
    );
  }
}
