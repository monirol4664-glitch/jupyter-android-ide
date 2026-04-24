"""
Python Interpreter for offline code execution
"""

import sys
from io import StringIO
import traceback


class PythonInterpreter:
    """Safe Python code executor with output capture"""
    
    def __init__(self):
        self.globals = {
            '__name__': '__main__',
            '__builtins__': __builtins__,
        }
        self.output_buffer = StringIO()
        self.error_buffer = StringIO()
    
    def execute_code(self, code_string):
        """Execute Python code and return (output, error)"""
        # Reset buffers
        self.output_buffer.truncate(0)
        self.output_buffer.seek(0)
        self.error_buffer.truncate(0)
        self.error_buffer.seek(0)
        
        # Save original stdout/stderr
        old_stdout = sys.stdout
        old_stderr = sys.stderr
        
        try:
            # Redirect stdout/stderr
            sys.stdout = self.output_buffer
            sys.stderr = self.error_buffer
            
            # Execute code
            exec(code_string, self.globals)
            
            # Get output
            output = self.output_buffer.getvalue()
            error = self.error_buffer.getvalue()
            
            return output, error
            
        except Exception as e:
            # Capture exception with traceback
            tb = traceback.format_exc()
            return "", tb
            
        finally:
            # Restore stdout/stderr
            sys.stdout = old_stdout
            sys.stderr = old_stderr
    
    def reset_environment(self):
        """Reset global environment (clear variables)"""
        self.globals = {
            '__name__': '__main__',
            '__builtins__': __builtins__,
        }