import 'dart:async';
import 'dart:convert';
import 'dart:math';

class ExecutionService {
  static final ExecutionService _instance = ExecutionService._internal();
  factory ExecutionService() => _instance;
  ExecutionService._internal();
  
  // Simulated Python execution with support for common operations
  Future<String> executeCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      final trimmed = code.trim();
      if (trimmed.isEmpty) return '';
      
      // Mathematical expressions
      if (trimmed.contains('+') || trimmed.contains('-') || 
          trimmed.contains('*') || trimmed.contains('/')) {
        try {
          // Safe evaluation for math expressions
          final result = _evaluateMath(trimmed);
          if (result != null) return result.toString();
        } catch (_) {}
      }
      
      // Print statements
      if (trimmed.startsWith('print(')) {
        final match = RegExp(r'print\([\'"](.+)[\'"]\)').firstMatch(trimmed);
        if (match != null) {
          return match.group(1) ?? '';
        }
        
        // Handle print(variable)
        final varMatch = RegExp(r'print\(([a-zA-Z_][a-zA-Z0-9_]*)\)').firstMatch(trimmed);
        if (varMatch != null) {
          return "Variable '${varMatch.group(1)}' would print here";
        }
      }
      
      // Variable assignments (simulated)
      if (trimmed.contains('=') && !trimmed.contains('==')) {
        return "✓ Variable assigned";
      }
      
      // List operations
      if (trimmed.startsWith('len(')) {
        final match = RegExp(r'len\([\'"](.+)[\'"]\)').firstMatch(trimmed);
        if (match != null) {
          return match.group(1)?.length.toString() ?? '0';
        }
      }
      
      // String operations
      if (trimmed.contains('.upper()') || trimmed.contains('.lower()')) {
        return "String operation result";
      }
      
      // Loop simulation
      if (trimmed.startsWith('for ') || trimmed.startsWith('while ')) {
        return "Loop executed (simulated)";
      }
      
      // Function definition
      if (trimmed.startsWith('def ')) {
        return "Function defined";
      }
      
      // Default response
      if (trimmed.isNotEmpty) {
        return "✓ Code executed successfully";
      }
      
      return '';
      
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
  
  double? _evaluateMath(String expression) {
    // Remove whitespace
    expression = expression.replaceAll(' ', '');
    
    // Handle basic operations
    if (expression.contains('+')) {
      final parts = expression.split('+');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a + b;
      }
    }
    
    if (expression.contains('-') && !expression.startsWith('-')) {
      final parts = expression.split('-');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a - b;
      }
    }
    
    if (expression.contains('*')) {
      final parts = expression.split('*');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) return a * b;
      }
    }
    
    if (expression.contains('/')) {
      final parts = expression.split('/');
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null && b != 0) return a / b;
      }
    }
    
    return null;
  }
                                     }
