import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';
import './Learning.css';

function LearningDashboard() {
  const [topics, setTopics] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    fetchTopics();
  }, []);

  const fetchTopics = async () => {
    try {
      const response = await api.get('/learning/topics');
      setTopics(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching topics:', error);
      setLoading(false);
    }
  };

  if (loading) return <div>Loading topics...</div>;

  return (
    <div className="learning-dashboard">
      <h1>Learning Topics</h1>
      <div className="topics-grid">
        {topics.map(topic => (
          <div key={topic.id} className="topic-card" onClick={() => navigate(`/learning/topic/${topic.id}`)}>
            <h3>{topic.title}</h3>
            <p>{topic.description}</p>
            <span className={`badge badge-${topic.difficultyLevel.toLowerCase()}`}>
              {topic.difficultyLevel}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

export default LearningDashboard;
