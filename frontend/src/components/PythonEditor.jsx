import React, { useRef } from 'react';
import Editor from '@monaco-editor/react';

const PythonEditor = () => {
  const editorRef = useRef(null);

  const handleEditorDidMount = (editor, monaco) => {
    editorRef.current = editor;
    
    // Enable Python-specific settings
    monaco.languages.typescript.javascriptDefaults.setEagerModelSync(true);
    
    // Configure Python language features
    monaco.languages.registerCompletionItemProvider('python', {
      provideCompletionItems: (model, position) => {
        // Python keywords suggestions
        const keywords = [
          'def', 'class', 'import', 'from', 'as', 'return', 
          'if', 'elif', 'else', 'for', 'while', 'break', 
          'continue', 'pass', 'try', 'except', 'finally',
          'with', 'as', 'lambda', 'yield', 'assert'
        ];
        
        const suggestions = keywords.map(keyword => ({
          label: keyword,
          kind: monaco.languages.CompletionItemKind.Keyword,
          insertText: keyword,
          detail: 'Python keyword'
        }));
        
        return { suggestions };
      }
    });
  };

  const handleChange = (value) => {
    console.log('Code changed:', value);
  };

  return (
    <Editor
      height="100vh"
      defaultLanguage="python"
      defaultValue="# Welcome to Python Notebook!\n# Write your code here\n\nprint('Hello, World!')"
      theme="vs-dark"
      onMount={handleEditorDidMount}
      onChange={handleChange}
      options={{
        fontSize: 14,
        minimap: { enabled: true },
        wordWrap: 'on',
        automaticLayout: true,
        suggestOnTriggerCharacters: true,
        quickSuggestions: true,
        acceptSuggestionOnEnter: 'on',
        tabCompletion: 'on',
        snippetSuggestions: 'top',
        parameterHints: { enabled: true },
        formatOnPaste: true,
        formatOnType: true,
        lineNumbers: 'on',
        renderWhitespace: 'selection',
        cursorBlinking: 'smooth',
        
        // Advanced autocomplete settings
        suggest: {
          showKeywords: true,
          showFunctions: true,
          showClasses: true,
          showSnippets: true,
          snippetsFirst: false
        }
      }}
    />
  );
};

export default PythonEditor;
