import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Editor from '@monaco-editor/react';
import api from '../services/api';
import './ExerciseView.css';

function ExerciseView() {
  const { exerciseId } = useParams();
  const [exercise, setExercise] = useState(null);
  const [code, setCode] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchExercise();
  }, [exerciseId]);

  const fetchExercise = async () => {
    try {
      const response = await api.get(`/learning/exercises/${exerciseId}`);
      setExercise(response.data);
      setCode(response.data.starterCode || '');
      setLoading(false);
    } catch (error) {
      console.error('Error fetching exercise:', error);
      setLoading(false);
    }
  };

  const handleSubmit = async () => {
    try {
      const response = await api.post(`/learning/exercises/${exerciseId}/submit`, { code });
      setResult(response.data);
      if (response.data.isCorrect) {
        alert('Congratulations! Your solution is correct!');
      }
    } catch (error) {
      console.error('Error submitting exercise:', error);
    }
  };

  if (loading) return <div>Loading exercise...</div>;
  if (!exercise) return <div>Exercise not found</div>;

  return (
    <div className="exercise-view">
      <div className="exercise-content">
        <div className="exercise-info">
          <h2>{exercise.title}</h2>
          <p>{exercise.description}</p>
        </div>
        <div className="exercise-editor">
          <Editor
            height="400px"
            language="java"
            value={code}
            onChange={(value) => setCode(value || '')}
            theme="vs-dark"
          />
          <button onClick={handleSubmit} className="btn btn-primary">Submit Solution</button>
          {result && (
            <div className={`result ${result.isCorrect ? 'success' : 'error'}`}>
              {result.feedback}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default ExerciseView;
