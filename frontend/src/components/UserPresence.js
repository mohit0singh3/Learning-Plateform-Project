import React from 'react';
import './UserPresence.css';

/**
 * UserPresence Component
 * 
 * Displays active users in the project with their cursors.
 * Shows user avatars and names.
 */
function UserPresence({ activeUsers, currentUserId }) {
  // Generate color for user based on username
  const getUserColor = (username) => {
    const colors = [
      '#007acc', '#ff6b6b', '#4ecdc4', '#45b7d1',
      '#f9ca24', '#6c5ce7', '#a29bfe', '#fd79a8'
    ];
    let hash = 0;
    for (let i = 0; i < username.length; i++) {
      hash = username.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
  };

  return (
    <div className="user-presence">
      <div className="user-presence-header">
        <span className="user-count">{activeUsers.length} {activeUsers.length === 1 ? 'user' : 'users'}</span>
      </div>
      <div className="user-list">
        {activeUsers.map((user) => (
          <div
            key={user.id}
            className={`user-item ${user.id === currentUserId ? 'current-user' : ''}`}
            title={user.username}
          >
            <div
              className="user-avatar"
              style={{ backgroundColor: getUserColor(user.username) }}
            >
              {user.username.charAt(0).toUpperCase()}
            </div>
            <span className="user-name">{user.username}</span>
            {user.id === currentUserId && (
              <span className="you-badge">You</span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

export default UserPresence;
