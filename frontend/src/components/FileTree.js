import React, { useState } from 'react';
import './FileTree.css';

/**
 * FileTree Component
 * 
 * Displays project files in a tree structure.
 * Supports file selection, creation, deletion, and renaming.
 */
function FileTree({ files, selectedFile, onFileSelect, onFileCreate, onFileDelete, onFileRename }) {
  const [expandedFolders, setExpandedFolders] = useState(new Set());
  const [editingFile, setEditingFile] = useState(null);
  const [newFileName, setNewFileName] = useState('');
  const [showNewFileInput, setShowNewFileInput] = useState(false);

  // Organize files into folder structure
  const organizeFiles = (files) => {
    const tree = {};
    
    files.forEach(file => {
      const path = file.filePath || `/${file.filename}`;
      const parts = path.split('/').filter(p => p);
      
      let current = tree;
      for (let i = 0; i < parts.length - 1; i++) {
        const part = parts[i];
        if (!current[part]) {
          current[part] = { type: 'folder', children: {} };
        }
        current = current[part].children;
      }
      
      const fileName = parts[parts.length - 1];
      current[fileName] = { type: 'file', data: file };
    });
    
    return tree;
  };

  const fileTree = organizeFiles(files);

  const toggleFolder = (path) => {
    const newExpanded = new Set(expandedFolders);
    if (newExpanded.has(path)) {
      newExpanded.delete(path);
    } else {
      newExpanded.add(path);
    }
    setExpandedFolders(newExpanded);
  };

  const handleFileClick = (file) => {
    if (onFileSelect) {
      onFileSelect(file);
    }
  };

  const handleRename = (file, newName) => {
    if (onFileRename && newName && newName !== file.filename) {
      onFileRename(file.id, newName);
    }
    setEditingFile(null);
    setNewFileName('');
  };

  const handleDelete = (file, e) => {
    e.stopPropagation();
    if (window.confirm(`Delete ${file.filename}?`)) {
      if (onFileDelete) {
        onFileDelete(file.id);
      }
    }
  };

  const handleCreateFile = () => {
    if (newFileName.trim()) {
      if (onFileCreate) {
        onFileCreate(newFileName.trim());
      }
      setNewFileName('');
      setShowNewFileInput(false);
    }
  };

  const renderTree = (tree, path = '', level = 0) => {
    return Object.entries(tree).map(([name, item]) => {
      const currentPath = path ? `${path}/${name}` : name;
      const isExpanded = expandedFolders.has(currentPath);
      const isSelected = item.type === 'file' && selectedFile?.id === item.data?.id;

      if (item.type === 'folder') {
        return (
          <div key={currentPath} className="file-tree-item">
            <div
              className="file-tree-folder"
              style={{ paddingLeft: `${level * 16}px` }}
              onClick={() => toggleFolder(currentPath)}
            >
              <span className="folder-icon">{isExpanded ? '📂' : '📁'}</span>
              <span className="folder-name">{name}</span>
            </div>
            {isExpanded && (
              <div className="file-tree-children">
                {renderTree(item.children, currentPath, level + 1)}
              </div>
            )}
          </div>
        );
      } else {
        const file = item.data;
        const isEditing = editingFile === file.id;

        return (
          <div
            key={file.id}
            className={`file-tree-item ${isSelected ? 'selected' : ''}`}
            style={{ paddingLeft: `${level * 16}px` }}
            onClick={() => !isEditing && handleFileClick(file)}
            onDoubleClick={() => setEditingFile(file.id)}
          >
            <span className="file-icon">📄</span>
            {isEditing ? (
              <input
                type="text"
                value={newFileName || file.filename}
                onChange={(e) => setNewFileName(e.target.value)}
                onBlur={() => handleRename(file, newFileName || file.filename)}
                onKeyPress={(e) => {
                  if (e.key === 'Enter') {
                    handleRename(file, newFileName || file.filename);
                  } else if (e.key === 'Escape') {
                    setEditingFile(null);
                    setNewFileName('');
                  }
                }}
                autoFocus
                className="file-rename-input"
                onClick={(e) => e.stopPropagation()}
              />
            ) : (
              <>
                <span className="file-name">{file.filename}</span>
                <button
                  className="file-delete-btn"
                  onClick={(e) => handleDelete(file, e)}
                  title="Delete file"
                >
                  ×
                </button>
              </>
            )}
          </div>
        );
      }
    });
  };

  return (
    <div className="file-tree">
      <div className="file-tree-header">
        <h3>Files</h3>
        <button
          className="add-file-btn"
          onClick={() => setShowNewFileInput(true)}
          title="Create new file"
        >
          +
        </button>
      </div>
      
      {showNewFileInput && (
        <div className="new-file-input">
          <input
            type="text"
            placeholder="filename.java"
            value={newFileName}
            onChange={(e) => setNewFileName(e.target.value)}
            onKeyPress={(e) => {
              if (e.key === 'Enter') {
                handleCreateFile();
              } else if (e.key === 'Escape') {
                setShowNewFileInput(false);
                setNewFileName('');
              }
            }}
            autoFocus
          />
          <div className="new-file-actions">
            <button onClick={handleCreateFile} className="btn-small">Create</button>
            <button onClick={() => {
              setShowNewFileInput(false);
              setNewFileName('');
            }} className="btn-small">Cancel</button>
          </div>
        </div>
      )}

      <div className="file-tree-content">
        {files.length === 0 ? (
          <div className="empty-files">No files yet. Create one to get started!</div>
        ) : (
          renderTree(fileTree)
        )}
      </div>
    </div>
  );
}

export default FileTree;
