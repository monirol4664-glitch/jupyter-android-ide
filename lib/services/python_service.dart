import 'package:chaquopy/chaquopy.dart';

class PythonService {
  static final PythonService _instance = PythonService._internal();
  factory PythonService() => _instance;
  PythonService._internal();
  
  Future<Map<String, dynamic>> executeCode(String code) async {
    try {
      final result = await Chaquopy.executeCode(code);
      return result;
    } catch (e) {
      return {
        'textOutputOrError': 'Error: ${e.toString()}',
        'success': false
      };
    }
  }
  
  Future<bool> isReady() async {
    try {
      await Chaquopy.isInitialized;
      return true;
    } catch (e) {
      return false;
    }
  }
}
