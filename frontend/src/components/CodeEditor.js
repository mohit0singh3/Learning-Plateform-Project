import React, { useRef, useEffect } from 'react';
import Editor from '@monaco-editor/react';

/**
 * CodeEditor Component
 * 
 * Wrapper around Monaco Editor with additional features.
 * Handles editor initialization and configuration.
 */
function CodeEditor({
  value,
  language,
  onChange,
  onCursorChange,
  theme = 'vs-dark',
  readOnly = false
}) {
  const editorRef = useRef(null);
  const monacoRef = useRef(null);

  const handleEditorDidMount = (editor, monaco) => {
    editorRef.current = editor;
    monacoRef.current = monaco;

    // Configure editor
    editor.updateOptions({
      fontSize: 14,
      minimap: { enabled: true },
      wordWrap: 'on',
      automaticLayout: true,
      scrollBeyondLastLine: false,
      formatOnPaste: true,
      formatOnType: true,
      readOnly: readOnly
    });

    // Track cursor position changes
    if (onCursorChange) {
      editor.onDidChangeCursorPosition((e) => {
        onCursorChange({
          line: e.position.lineNumber,
          column: e.position.column
        });
      });
    }
  };

  return (
    <Editor
      height="100%"
      language={language}
      value={value}
      onChange={onChange}
      theme={theme}
      onMount={handleEditorDidMount}
      options={{
        fontSize: 14,
        minimap: { enabled: true },
        wordWrap: 'on',
        automaticLayout: true,
        scrollBeyondLastLine: false,
        formatOnPaste: true,
        formatOnType: true,
        readOnly: readOnly
      }}
    />
  );
}

export default CodeEditor;
