import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PythonService extends ChangeNotifier {
  WebViewController? _controller;
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final platform = defaultTargetPlatform;
    late final PlatformWebViewControllerCreationParams params;
    
    if (platform == TargetPlatform.android) {
      params = const AndroidWebViewControllerCreationParams();
    } else if (platform == TargetPlatform.iOS) {
      params = const WebKitWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'JupyterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle messages from JavaScript
          debugPrint('Message from JS: ${message.message}');
        },
      );
    
    await _controller?.setBackgroundColor(const Color(0xFF1e1e1e));
    await _controller?.loadFlutterAsset('assets/jupyter_web/index.html');
    
    _isInitialized = true;
    notifyListeners();
  }
  
  Future<String> executeCode(String code) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      final escapedCode = code
          .replaceAll('\\', '\\\\')
          .replaceAll("'", "\\'")
          .replaceAll('\n', '\\n');
      
      final result = await _controller?.runJavaScriptReturningResult('''
        executeCode('$escapedCode')
      ''');
      
      return result?.toString() ?? 'No output';
    } catch (e) {
      return 'Error: $e';
    }
  }
  
  void disposeController() {
    _controller = null;
    _isInitialized = false;
  }
}
