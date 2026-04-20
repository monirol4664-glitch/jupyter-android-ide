import React, { useState } from 'react';
import { solveLinearEquation, solveSystem, toFraction, toMixedNumber } from '../utils/equationSolver';
import Fraction from 'fraction.js';

const Solver = () => {
  const [equation, setEquation] = useState('2x + 3 = 7');
  const [variable, setVariable] = useState('x');
  const [solution, setSolution] = useState(null);
  const [error, setError] = useState(null);
  const [eq1, setEq1] = useState('2x + 3y = 7');
  const [eq2, setEq2] = useState('x - y = 1');
  const [systemSolution, setSystemSolution] = useState(null);

  const handleSolve = () => {
    setError(null);
    try {
      const result = solveLinearEquation(equation, variable);
      const fraction = toFraction(result);
      const mixed = toMixedNumber(result);
      
      setSolution({
        value: result,
        fraction: fraction,
        mixed: mixed,
        equation: equation
      });
    } catch (err) {
      setError(err.message);
      setSolution(null);
    }
  };

  const handleSolveSystem = () => {
    try {
      const result = solveSystem(eq1, eq2);
      setSystemSolution(result);
    } catch (err) {
      setSystemSolution({ error: err.message });
    }
  };

  const setExample = (type) => {
    if (type === 'basic') setEquation('2x + 3 = 7');
    if (type === 'fraction') setEquation('x/2 + 1/3 = 3x/4');
    if (type === 'complex') setEquation('2(x+1)/3 = 5');
    if (type === 'decimal') setEquation('1.5x + 2.25 = 7.5');
    handleSolve();
  };

  return (
    <div className="solver-container">
      <div className="card">
        <div className="card-header">
          <h2><span className="icon">🔢</span> Linear Equation Solver</h2>
        </div>
        <div className="card-body">
          <div className="quick-actions">
            <button className="quick-btn" onClick={() => setExample('basic')}>2x + 3 = 7</button>
            <button className="quick-btn" onClick={() => setExample('fraction')}>With Fractions</button>
            <button className="quick-btn" onClick={() => setExample('complex')}>With Parentheses</button>
            <button className="quick-btn" onClick={() => setExample('decimal')}>With Decimals</button>
          </div>
          
          <div className="input-group">
            <label>Equation:</label>
            <input 
              type="text" 
              value={equation} 
              onChange={(e) => setEquation(e.target.value)}
              placeholder="e.g., 2x + 3 = 7"
              className="equation-input"
            />
          </div>
          
          <div className="input-group">
            <label>Variable:</label>
            <input 
              type="text" 
              value={variable} 
              onChange={(e) => setVariable(e.target.value)}
              placeholder="x"
              className="variable-input"
              style={{ width: '80px' }}
            />
          </div>
          
          <button className="btn-primary" onClick={handleSolve}>
            <span className="icon">🔍</span> Solve Equation
          </button>
          
          {error && (
            <div className="error-message">
              <span className="icon">⚠️</span> {error}
            </div>
          )}
          
          {solution && (
            <div className="solution-box">
              <div className="solution-header">
                <span className="icon">✅</span> Solution Found
              </div>
              <div className="solution-value">
                {variable} = {solution.value.toFixed(6)}
              </div>
              <div className="solution-details">
                <div>As fraction: {solution.fraction}</div>
                <div>As mixed number: {solution.mixed}</div>
              </div>
              <div className="step-by-step">
                <strong>Step-by-step:</strong>
                <div>• Original equation: {solution.equation}</div>
                <div>• Isolate {variable}: {variable} = {solution.value.toFixed(6)}</div>
                <div>• Simplified: {variable} = {solution.fraction}</div>
              </div>
            </div>
          )}
        </div>
      </div>

      <div className="card">
        <div className="card-header">
          <h2><span className="icon">📊</span> System of Equations</h2>
        </div>
        <div className="card-body">
          <div className="input-group">
            <label>Equation 1:</label>
            <input 
              type="text" 
              value={eq1} 
              onChange={(e) => setEq1(e.target.value)}
              placeholder="2x + 3y = 7"
            />
          </div>
          
          <div className="input-group">
            <label>Equation 2:</label>
            <input 
              type="text" 
              value={eq2} 
              onChange={(e) => setEq2(e.target.value)}
              placeholder="x - y = 1"
            />
          </div>
          
          <button className="btn-primary" onClick={handleSolveSystem}>
            <span className="icon">🔄</span> Solve System
          </button>
          
          {systemSolution && !systemSolution.error && (
            <div className="solution-box">
              <div className="solution-header">System Solved</div>
              <div className="solution-value">x = {systemSolution.x.toFixed(4)}</div>
              <div className="solution-value">y = {systemSolution.y.toFixed(4)}</div>
              <div className="solution-details">
                <div>x = {toFraction(systemSolution.x)}</div>
                <div>y = {toFraction(systemSolution.y)}</div>
              </div>
            </div>
          )}
          
          {systemSolution && systemSolution.error && (
            <div className="error-message">{systemSolution.error}</div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Solver;