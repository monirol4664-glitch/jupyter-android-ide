import 'dart:async';
import 'dart:math';

class ExecutionService {
  static final ExecutionService _instance = ExecutionService._internal();
  factory ExecutionService() => _instance;
  ExecutionService._internal();
  
  final Map<String, dynamic> _variables = {};
  
  Future<String> executeCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      final trimmed = code.trim();
      if (trimmed.isEmpty) return '';
      
      // Handle comments
      if (trimmed.startsWith('#')) return '';
      
      // Variable assignment
      if (trimmed.contains('=') && !trimmed.contains('==')) {
        return _handleAssignment(trimmed);
      }
      
      // Print statements
      if (trimmed.startsWith('print(') && trimmed.endsWith(')')) {
        return _handlePrint(trimmed);
      }
      
      // Math expressions
      final mathResult = _evaluateMath(trimmed);
      if (mathResult != null) return mathResult;
      
      // String operations
      if (trimmed.contains('.upper()')) {
        final varName = trimmed.split('.')[0];
        if (_variables.containsKey(varName)) {
          return _variables[varName].toString().toUpperCase();
        }
      }
      
      if (trimmed.contains('.lower()')) {
        final varName = trimmed.split('.')[0];
        if (_variables.containsKey(varName)) {
          return _variables[varName].toString().toLowerCase();
        }
      }
      
      // len() function
      if (trimmed.startsWith('len(')) {
        return _handleLen(trimmed);
      }
      
      // Variable reference
      if (_variables.containsKey(trimmed)) {
        return _variables[trimmed].toString();
      }
      
      // Default response
      if (trimmed.isNotEmpty) {
        return "Executed: $trimmed";
      }
      
      return '';
      
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
  
  String _handleAssignment(String code) {
    final parts = code.split('=');
    if (parts.length == 2) {
      final varName = parts[0].trim();
      var varValue = parts[1].trim();
      
      // Parse value
      if (varValue == 'True') {
        _variables[varName] = true;
      } else if (varValue == 'False') {
        _variables[varName] = false;
      } else if (varValue == 'None') {
        _variables[varName] = null;
      } else if (int.tryParse(varValue) != null) {
        _variables[varName] = int.parse(varValue);
      } else if (double.tryParse(varValue) != null) {
        _variables[varName] = double.parse(varValue);
      } else if (varValue.startsWith('"') && varValue.endsWith('"')) {
        _variables[varName] = varValue.substring(1, varValue.length - 1);
      } else if (varValue.startsWith("'") && varValue.endsWith("'")) {
        _variables[varName] = varValue.substring(1, varValue.length - 1);
      } else if (_variables.containsKey(varValue)) {
        _variables[varName] = _variables[varValue];
      } else {
        _variables[varName] = varValue;
      }
      
      return "✓ $varName = ${_variables[varName]}";
    }
    return "✓ Assignment done";
  }
  
  String _handlePrint(String code) {
    String content = code.substring(6, code.length - 1);
    
    // Check if it's a variable
    if (_variables.containsKey(content)) {
      return _variables[content].toString();
    }
    
    // Remove quotes
    if (content.startsWith('"') && content.endsWith('"')) {
      content = content.substring(1, content.length - 1);
    }
    if (content.startsWith("'") && content.endsWith("'")) {
      content = content.substring(1, content.length - 1);
    }
    
    return content;
  }
  
  String _handleLen(String code) {
    String content = code.substring(4, code.length - 1);
    
    // Check variable
    if (_variables.containsKey(content)) {
      final value = _variables[content];
      if (value is String) return value.length.toString();
      if (value is List) return value.length.toString();
      if (value is Map) return value.length.toString();
    }
    
    // Remove quotes for string literal
    if (content.startsWith('"') && content.endsWith('"')) {
      content = content.substring(1, content.length - 1);
    }
    if (content.startsWith("'") && content.endsWith("'")) {
      content = content.substring(1, content.length - 1);
    }
    
    return content.length.toString();
  }
  
  String? _evaluateMath(String expression) {
    expression = expression.replaceAll(' ', '');
    
    // Handle variable math
    String resolvedExpr = expression;
    for (var entry in _variables.entries) {
      resolvedExpr = resolvedExpr.replaceAll(entry.key, entry.value.toString());
    }
    
    // Multiplication
    if (resolvedExpr.contains('*')) {
      final parts = resolvedExpr.split('*');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) {
          final result = a * b;
          return result.toString().endsWith('.0') 
              ? result.toInt().toString() 
              : result.toString();
        }
      }
    }
    
    // Division
    if (resolvedExpr.contains('/')) {
      final parts = resolvedExpr.split('/');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null && b != 0) {
          final result = a / b;
          return result.toString();
        }
      }
    }
    
    // Addition
    if (resolvedExpr.contains('+')) {
      final parts = resolvedExpr.split('+');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) {
          final result = a + b;
          return result.toString().endsWith('.0') 
              ? result.toInt().toString() 
              : result.toString();
        }
      }
    }
    
    // Subtraction
    if (resolvedExpr.contains('-') && !resolvedExpr.startsWith('-')) {
      final parts = resolvedExpr.split('-');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) {
          final result = a - b;
          return result.toString().endsWith('.0') 
              ? result.toInt().toString() 
              : result.toString();
        }
      }
    }
    
    return null;
  }
}
