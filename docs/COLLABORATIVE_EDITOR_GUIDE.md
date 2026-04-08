# Collaborative Code Editor - Frontend Guide

## Overview

The collaborative code editor is a real-time, multi-user code editing interface built with React and Monaco Editor. It allows multiple users to edit code simultaneously with live synchronization.

## Features

### ✅ Implemented Features

1. **Monaco Editor Integration**
   - Full-featured code editor (same as VS Code)
   - Syntax highlighting for 20+ languages
   - Code completion and IntelliSense
   - Minimap for navigation
   - Multiple themes

2. **File Management**
   - Create new files
   - Delete files
   - Rename files (double-click)
   - File tree navigation
   - Folder structure support

3. **Real-Time Collaboration** (WebSocket Ready)
   - Code change synchronization
   - User presence indicators
   - Active user list
   - Connection status

4. **Auto-Save**
   - Automatic saving after 2 seconds of inactivity
   - Manual save button
   - Save status indicators

5. **User Interface**
   - Dark theme (VS Code style)
   - Responsive layout
   - File tree sidebar
   - User presence sidebar
   - Editor header with file info

## Component Structure

```
ProjectView (Main Page)
├── FileTree (Left Sidebar)
│   ├── File/Folder items
│   └── Create file button
├── Editor Area (Center)
│   ├── Editor Header
│   │   ├── File name
│   │   ├── Save status
│   │   ├── Connection status
│   │   └── Save button
│   └── Monaco Editor
└── UserPresence (Right Sidebar)
    ├── User count
    └── Active users list
```

## File Structure

```
frontend/src/
├── pages/
│   └── ProjectView.js          # Main editor page
├── components/
│   ├── FileTree.js              # File tree component
│   ├── FileTree.css
│   ├── UserPresence.js          # User presence component
│   ├── UserPresence.css
│   └── CodeEditor.js            # Editor wrapper
├── services/
│   ├── websocket.js             # WebSocket service
│   └── api.js                   # REST API service
└── utils/
    └── auth.js                  # Auth utilities
```

## Usage

### Basic Usage

```javascript
import ProjectView from './pages/ProjectView';

// In your router
<Route path="/project/:projectId" element={<ProjectView />} />
```

### WebSocket Connection

The WebSocket service automatically connects when ProjectView mounts:

```javascript
// Automatically connects on mount
useEffect(() => {
  websocketService.connect(projectId, {
    onConnect: () => console.log('Connected'),
    onCodeChange: (data) => {
      // Handle code changes from other users
    },
    onUserJoined: (data) => {
      // Handle user joining
    }
  });
  
  return () => websocketService.disconnect();
}, [projectId]);
```

## API Integration

### File Operations

```javascript
// Get all files
GET /api/projects/{projectId}/files

// Get file content
GET /api/projects/{projectId}/files/{fileId}

// Create/Update file
PUT /api/projects/{projectId}/files
Body: {
  filename: "Main.java",
  filePath: "/src/Main.java",
  content: "code here",
  language: "java"
}

// Delete file
DELETE /api/projects/{projectId}/files/{fileId}
```

## WebSocket Events

### Client → Server

- `join-project` - Join a project room
- `code-change` - Send code changes
- `cursor-position` - Send cursor position
- `file-created` - Notify file creation
- `file-deleted` - Notify file deletion
- `file-renamed` - Notify file rename

### Server → Client

- `code-change` - Receive code changes from others
- `cursor-position` - Receive cursor positions
- `user-joined` - User joined notification
- `user-left` - User left notification
- `active-users` - List of active users
- `file-created` - File created by another user
- `file-deleted` - File deleted by another user
- `file-renamed` - File renamed by another user

## Styling

The editor uses a dark theme matching VS Code:

- Background: `#1e1e1e`
- Sidebar: `#252526`
- Editor: `#1e1e1e`
- Text: `#cccccc`
- Accent: `#007acc`

## Keyboard Shortcuts

- `Ctrl/Cmd + S` - Save file (via browser default)
- `Double-click` file - Rename file
- `Click` file - Select file

## Auto-Save Behavior

1. User types code
2. Change detected
3. Wait 2 seconds of no changes
4. Auto-save triggered
5. Status indicator shows "Saving..."
6. Status clears when saved

## User Presence

- Shows all users currently viewing the project
- Each user gets a unique color
- Current user is highlighted
- Updates in real-time

## Connection Status

- **Connected** (green dot): WebSocket connected
- **Disconnected** (red dot): WebSocket disconnected

## Supported Languages

The editor supports syntax highlighting for:
- Java, JavaScript, TypeScript, Python
- C, C++, C#
- Go, Rust, Swift, Kotlin
- HTML, CSS, JSON, XML, YAML
- SQL, Markdown, and more

Language is auto-detected from file extension.

## Error Handling

- Network errors show alerts
- Failed saves are indicated
- Connection errors are logged
- 401 errors redirect to login

## Performance Optimizations

1. **Debounced Auto-Save**: Prevents excessive API calls
2. **Efficient Re-renders**: Uses React hooks properly
3. **WebSocket Throttling**: Can be added for cursor positions
4. **Lazy Loading**: Editor loads on demand

## Browser Compatibility

- ✅ Chrome/Edge (recommended)
- ✅ Firefox
- ✅ Safari

## Future Enhancements

1. **Operational Transform**: Better conflict resolution
2. **Cursor Tracking**: Show other users' cursors
3. **Selection Highlighting**: Highlight other users' selections
4. **Chat**: In-editor chat
5. **Comments**: Code comments/annotations
6. **Version History**: View file history
7. **Diff View**: Compare versions
8. **Search/Replace**: Global search
9. **Multi-cursor Editing**: VS Code style
10. **Code Formatting**: Auto-format on save

## Troubleshooting

### Editor Not Loading
- Check browser console for errors
- Verify Monaco Editor is installed: `npm install @monaco-editor/react`
- Check network tab for failed requests

### WebSocket Not Connecting
- Verify backend WebSocket is running
- Check WebSocket URL in websocket.js
- Verify authentication token is valid
- Check browser console for connection errors

### Files Not Saving
- Check network tab for API errors
- Verify user has write permissions
- Check backend logs

### Real-Time Updates Not Working
- Verify WebSocket connection status
- Check if other users are connected
- Verify backend WebSocket handlers are implemented

## Development Notes

- Editor uses Monaco Editor (same as VS Code)
- WebSocket uses Socket.io client
- State management uses React hooks
- API calls use Axios
- Authentication via JWT tokens

## Testing

### Manual Testing Checklist

- [ ] Create new file
- [ ] Edit file content
- [ ] Save file (auto and manual)
- [ ] Delete file
- [ ] Rename file
- [ ] Switch between files
- [ ] Check user presence updates
- [ ] Verify connection status
- [ ] Test with multiple users (real-time)

## Deployment

1. Build frontend: `npm run build`
2. Serve static files from `build/` directory
3. Configure environment variables
4. Ensure WebSocket URL is accessible
5. Set up CORS on backend

## Environment Variables

```bash
REACT_APP_API_URL=http://localhost:8080/api
REACT_APP_WS_URL=http://localhost:8080
```

## Support

For issues or questions:
1. Check browser console for errors
2. Check network tab for failed requests
3. Verify backend is running
4. Check WebSocket connection status
