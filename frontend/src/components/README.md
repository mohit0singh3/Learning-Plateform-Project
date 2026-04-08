# Collaborative Code Editor Components

## Overview

The collaborative code editor is built with React and Monaco Editor, featuring real-time collaboration via WebSocket.

## Components

### ProjectView (`pages/ProjectView.js`)
Main component that orchestrates the entire editor experience.

**Features:**
- Monaco Editor integration
- Real-time code synchronization
- File management (create, delete, rename)
- Auto-save functionality
- User presence indicators
- Connection status

**Props:** None (uses URL params for projectId)

### FileTree (`components/FileTree.js`)
Displays project files in a tree structure.

**Features:**
- Folder/file organization
- File selection
- Create new files
- Delete files
- Rename files (double-click)
- Visual file tree

**Props:**
- `files` - Array of file objects
- `selectedFile` - Currently selected file
- `onFileSelect` - Callback when file is selected
- `onFileCreate` - Callback to create new file
- `onFileDelete` - Callback to delete file
- `onFileRename` - Callback to rename file

### UserPresence (`components/UserPresence.js`)
Shows active users in the project.

**Features:**
- User avatars with colors
- User count
- Current user indicator

**Props:**
- `activeUsers` - Array of active user objects
- `currentUserId` - ID of current user

### CodeEditor (`components/CodeEditor.js`)
Wrapper around Monaco Editor.

**Features:**
- Syntax highlighting
- Code completion
- Cursor tracking
- Read-only mode support

**Props:**
- `value` - Code content
- `language` - Programming language
- `onChange` - Change handler
- `onCursorChange` - Cursor position handler
- `theme` - Editor theme (default: 'vs-dark')
- `readOnly` - Read-only mode

## Services

### WebSocket Service (`services/websocket.js`)
Manages WebSocket connection for real-time collaboration.

**Methods:**
- `connect(projectId, callbacks)` - Connect to project
- `disconnect()` - Disconnect from server
- `sendCodeChange(fileId, content)` - Send code changes
- `sendCursorPosition(fileId, position)` - Send cursor position
- `isConnected()` - Check connection status

**Events:**
- `code-change` - Code was changed by another user
- `cursor-position` - Cursor position changed
- `user-joined` - User joined the project
- `user-left` - User left the project
- `active-users` - List of active users
- `file-created` - New file created
- `file-deleted` - File deleted
- `file-renamed` - File renamed

## Usage Example

```javascript
import ProjectView from './pages/ProjectView';

// In your router
<Route path="/project/:projectId" element={<ProjectView />} />
```

## Styling

All components use CSS modules for styling. The editor uses a dark theme matching VS Code's dark theme.

## Real-Time Collaboration

The editor supports real-time collaboration:

1. **Code Changes**: Changes are broadcast to all connected users
2. **Cursor Positions**: Cursor positions are shared (can be enhanced)
3. **User Presence**: Shows who's currently editing
4. **File Operations**: File create/delete/rename are synchronized

## Auto-Save

Files are automatically saved 2 seconds after the last change. Manual save is also available via the Save button.

## Browser Support

- Chrome/Edge (recommended)
- Firefox
- Safari

## Performance

- Debounced auto-save (2 seconds)
- Efficient WebSocket message handling
- Optimized re-renders with React hooks
