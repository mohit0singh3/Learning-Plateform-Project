import React, { useState, useEffect, useRef } from 'react';
import { useParams } from 'react-router-dom';
import Editor from '@monaco-editor/react';
import api from '../services/api';
import websocketService from '../services/websocket';
import { useAuth } from '../context/AuthContext';
import FileTree from '../components/FileTree';
import UserPresence from '../components/UserPresence';
import './ProjectView.css';

/**
 * ProjectView Component
 * 
 * Main collaborative code editor page.
 * Features:
 * - Monaco Editor for code editing
 * - Real-time collaboration via WebSocket
 * - File management (create, delete, rename)
 * - User presence indicators
 * - Auto-save functionality
 */
function ProjectView() {
  const { projectId } = useParams();
  const { user } = useAuth();
  
  const [project, setProject] = useState(null);
  const [files, setFiles] = useState([]);
  const [selectedFile, setSelectedFile] = useState(null);
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [activeUsers, setActiveUsers] = useState([]);
  const [isConnected, setIsConnected] = useState(false);
  
  const editorRef = useRef(null);
  const saveTimeoutRef = useRef(null);
  const lastSavedContentRef = useRef('');

  // Initialize project and files
  useEffect(() => {
    fetchProject();
    fetchFiles();
    
    return () => {
      websocketService.disconnect();
      if (saveTimeoutRef.current) {
        clearTimeout(saveTimeoutRef.current);
      }
    };
  }, [projectId]);

  // Setup WebSocket connection
  useEffect(() => {
    if (projectId && user) {
      setupWebSocket();
    }
    
    return () => {
      websocketService.disconnect();
    };
  }, [projectId, user]);

  const fetchProject = async () => {
    try {
      const response = await api.get(`/projects/${projectId}`);
      setProject(response.data);
    } catch (error) {
      console.error('Error fetching project:', error);
      setLoading(false);
    }
  };

  const fetchFiles = async () => {
    try {
      const response = await api.get(`/projects/${projectId}/files`);
      const fileList = response.data || [];
      setFiles(fileList);
      if (fileList.length > 0) {
        const firstFile = fileList[0];
        setSelectedFile(firstFile);
        setCode(firstFile.content);
        lastSavedContentRef.current = firstFile.content;
      }
      setLoading(false);
    } catch (error) {
      console.error('Error fetching files:', error);
      setLoading(false);
    }
  };

  const loadFile = async (fileId) => {
    try {
      const response = await api.get(`/projects/${projectId}/files/${fileId}`);
      const fileData = response.data;
      setSelectedFile(fileData);
      setCode(fileData.content);
      lastSavedContentRef.current = fileData.content;
    } catch (error) {
      console.error('Error loading file:', error);
    }
  };

  const setupWebSocket = () => {
    websocketService.connect(`/ws/project/${projectId}`, {
      onConnect: () => setIsConnected(true),
      onDisconnect: () => setIsConnected(false),
      onCodeChange: (data) => {
        if (data.fileId === selectedFile?.id) {
          setCode(data.content);
        }
      }
    });
  };

  const handleEditorChange = (value) => {
    const newContent = value || '';
    setCode(newContent);

    if (selectedFile && websocketService.isConnected()) {
      websocketService.sendCodeChange(selectedFile.id, newContent);
    }

    if (saveTimeoutRef.current) {
      clearTimeout(saveTimeoutRef.current);
    }

    saveTimeoutRef.current = setTimeout(() => {
      saveFile(newContent);
    }, 2000);
  };

  const saveFile = async (contentToSave = null) => {
    if (!selectedFile) return;

    const content = contentToSave || code;
    
    if (content === lastSavedContentRef.current) {
      return;
    }

    setSaving(true);
    try {
      await api.put(`/projects/${projectId}/files/${selectedFile.id}`, { content });
      lastSavedContentRef.current = content;
    } catch (error) {
      console.error('Error saving file:', error);
    } finally {
      setSaving(false);
    }
  };

  const handleFileSelect = (file) => {
    if (file.id !== selectedFile?.id) {
      if (selectedFile && code !== lastSavedContentRef.current) {
        saveFile();
      }
      loadFile(file.id);
    }
  };

  const handleFileCreate = async (filename) => {
    try {
      const response = await api.post(`/projects/${projectId}/files`, {
        filename,
        content: '',
        language: getLanguageFromFilename(filename)
      });
      setFiles(prev => [...prev, response.data]);
      loadFile(response.data.id);
    } catch (error) {
      console.error('Error creating file:', error);
    }
  };

  const handleFileDelete = async (fileId) => {
    try {
      await api.delete(`/projects/${projectId}/files/${fileId}`);
      setFiles(prev => prev.filter(f => f.id !== fileId));
      if (selectedFile?.id === fileId) {
        const remainingFiles = files.filter(f => f.id !== fileId);
        if (remainingFiles.length > 0) {
          loadFile(remainingFiles[0].id);
        } else {
          setSelectedFile(null);
          setCode('');
        }
      }
    } catch (error) {
      console.error('Error deleting file:', error);
    }
  };

  const handleFileRename = async (fileId, newName) => {
    try {
      const file = files.find(f => f.id === fileId);
      if (!file) return;

      await api.put(`/projects/${projectId}/files/${fileId}`, {
        filename: newName,
        content: file.content,
        language: file.language
      });
      setFiles(prev => prev.map(f => f.id === fileId ? { ...f, filename: newName } : f));
      if (selectedFile?.id === fileId) {
        setSelectedFile(prev => ({ ...prev, filename: newName }));
      }
    } catch (error) {
      console.error('Error renaming file:', error);
    }
  };

  const handleEditorDidMount = (editor, monaco) => {
    editorRef.current = editor;
    editor.updateOptions({
      fontSize: 14,
      minimap: { enabled: true },
      wordWrap: 'on',
      automaticLayout: true
    });
  };

  const getLanguageFromFilename = (filename) => {
    const ext = filename.split('.').pop().toLowerCase();
    const languageMap = {
      'java': 'java',
      'js': 'javascript',
      'jsx': 'javascript',
      'ts': 'typescript',
      'tsx': 'typescript',
      'py': 'python',
      'cpp': 'cpp',
      'c': 'c',
      'cs': 'csharp',
      'go': 'go',
      'rs': 'rust',
      'php': 'php',
      'rb': 'ruby',
      'swift': 'swift',
      'kt': 'kotlin',
      'scala': 'scala',
      'html': 'html',
      'css': 'css',
      'json': 'json',
      'xml': 'xml',
      'yaml': 'yaml',
      'yml': 'yaml',
      'md': 'markdown',
      'sql': 'sql'
    };
    return languageMap[ext] || 'plaintext';
  };

  if (loading) {
    return (
      <div className="project-view-loading">
        <div className="loading-spinner"></div>
        <p>Loading project...</p>
      </div>
    );
  }

  return (
    <div className="project-view">
      <div className="editor-container">
        <FileTree
          files={files}
          selectedFile={selectedFile}
          onFileSelect={handleFileSelect}
          onFileCreate={handleFileCreate}
          onFileDelete={handleFileDelete}
          onFileRename={handleFileRename}
        />
        
        <div className="editor-area">
          <div className="editor-header">
            <div className="editor-header-left">
              <span className="file-name">{selectedFile?.filename || 'No file selected'}</span>
              {saving && <span className="saving-indicator">Saving...</span>}
              {!saving && code !== lastSavedContentRef.current && (
                <span className="unsaved-indicator">Unsaved changes</span>
              )}
            </div>
            <div className="editor-header-right">
              <div className={`connection-status ${isConnected ? 'connected' : 'disconnected'}`}>
                <span className="status-dot"></span>
                {isConnected ? 'Connected' : 'Disconnected'}
              </div>
              <button 
                onClick={() => saveFile()} 
                className="btn btn-primary save-btn"
                disabled={saving || code === lastSavedContentRef.current}
              >
                {saving ? 'Saving...' : 'Save'}
              </button>
            </div>
          </div>
          
          <div className="editor-wrapper">
            {selectedFile ? (
              <Editor
                height="100%"
                language={selectedFile.language || getLanguageFromFilename(selectedFile.filename)}
                value={code}
                onChange={handleEditorChange}
                theme="vs-dark"
                onMount={handleEditorDidMount}
                options={{
                  fontSize: 14,
                  minimap: { enabled: true },
                  wordWrap: 'on',
                  automaticLayout: true,
                  scrollBeyondLastLine: false,
                  formatOnPaste: true,
                  formatOnType: true
                }}
              />
            ) : (
              <div className="no-file-selected">
                <p>Select a file from the sidebar to start editing</p>
                <p className="hint">Or create a new file using the + button</p>
              </div>
            )}
          </div>
        </div>
        
        <UserPresence 
          activeUsers={activeUsers} 
          currentUserId={user?.id}
        />
      </div>
    </div>
  );
}

export default ProjectView;
