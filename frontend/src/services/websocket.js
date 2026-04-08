import { io } from 'socket.io-client';
import { getToken } from '../utils/auth';

/**
 * WebSocket Service
 * 
 * Manages WebSocket connection for real-time collaboration.
 * Handles code changes, cursor positions, and user presence.
 */
class WebSocketService {
  constructor() {
    this.socket = null;
    this.listeners = new Map();
  }

  /**
   * Connect to WebSocket server for a project
   * 
   * @param {string} projectId - Project ID to connect to
   * @param {object} callbacks - Callback functions for events
   */
  connect(projectId, callbacks = {}) {
    if (this.socket?.connected) {
      this.disconnect();
    }

    const token = getToken();
    // Extract base URL from API URL or use default
    const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';
    const wsUrl = process.env.REACT_APP_WS_URL || apiUrl.replace('/api', '');

    // Connect with authentication token
    this.socket = io(wsUrl, {
      auth: {
        token: token
      },
      transports: ['websocket', 'polling']
    });

    // Store callbacks
    this.callbacks = callbacks;

    // Connection events
    this.socket.on('connect', () => {
      console.log('WebSocket connected');
      // Join project room
      this.socket.emit('join-project', projectId);
      if (callbacks.onConnect) callbacks.onConnect();
    });

    this.socket.on('disconnect', () => {
      console.log('WebSocket disconnected');
      if (callbacks.onDisconnect) callbacks.onDisconnect();
    });

    this.socket.on('connect_error', (error) => {
      console.error('WebSocket connection error:', error);
      if (callbacks.onError) callbacks.onError(error);
    });

    // Code change events
    this.socket.on('code-change', (data) => {
      if (callbacks.onCodeChange) {
        callbacks.onCodeChange(data);
      }
    });

    // Cursor position events
    this.socket.on('cursor-position', (data) => {
      if (callbacks.onCursorChange) {
        callbacks.onCursorChange(data);
      }
    });

    // User presence events
    this.socket.on('user-joined', (data) => {
      if (callbacks.onUserJoined) {
        callbacks.onUserJoined(data);
      }
    });

    this.socket.on('user-left', (data) => {
      if (callbacks.onUserLeft) {
        callbacks.onUserLeft(data);
      }
    });

    this.socket.on('active-users', (data) => {
      if (callbacks.onActiveUsers) {
        callbacks.onActiveUsers(data);
      }
    });

    // File events
    this.socket.on('file-created', (data) => {
      if (callbacks.onFileCreated) {
        callbacks.onFileCreated(data);
      }
    });

    this.socket.on('file-deleted', (data) => {
      if (callbacks.onFileDeleted) {
        callbacks.onFileDeleted(data);
      }
    });

    this.socket.on('file-renamed', (data) => {
      if (callbacks.onFileRenamed) {
        callbacks.onFileRenamed(data);
      }
    });
  }

  /**
   * Disconnect from WebSocket server
   */
  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
    }
  }

  /**
   * Send code change to server
   * 
   * @param {string} fileId - File ID
   * @param {string} content - New file content
   */
  sendCodeChange(fileId, content) {
    if (this.socket?.connected) {
      this.socket.emit('code-change', {
        fileId,
        content
      });
    }
  }

  /**
   * Send cursor position to server
   * 
   * @param {string} fileId - File ID
   * @param {object} position - Cursor position {line, column}
   */
  sendCursorPosition(fileId, position) {
    if (this.socket?.connected) {
      this.socket.emit('cursor-position', {
        fileId,
        position
      });
    }
  }

  /**
   * Check if connected
   */
  isConnected() {
    return this.socket?.connected || false;
  }
}

// Export singleton instance
export default new WebSocketService();
