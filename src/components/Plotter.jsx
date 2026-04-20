import React, { useState, useEffect, useRef } from 'react';
import { Line } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js';
import { evaluateFunction } from '../utils/mathParser';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
);

const Plotter = () => {
  const [functionStr, setFunctionStr] = useState('x^2');
  const [xMin, setXMin] = useState(-5);
  const [xMax, setXMax] = useState(5);
  const [chartData, setChartData] = useState(null);
  const [error, setError] = useState(null);

  const generatePlot = () => {
    setError(null);
    try {
      const points = [];
      const step = (xMax - xMin) / 400;
      
      for (let x = xMin; x <= xMax; x += step) {
        const y = evaluateFunction(functionStr, x);
        if (!isNaN(y) && isFinite(y) && Math.abs(y) < 1000) {
          points.push({ x, y });
        }
      }
      
      if (points.length === 0) {
        setError('No valid points to plot');
        return;
      }
      
      const data = {
        labels: points.map(p => p.x.toFixed(2)),
        datasets: [
          {
            label: `f(x) = ${functionStr}`,
            data: points.map(p => p.y),
            borderColor: 'rgb(79, 70, 229)',
            backgroundColor: 'rgba(79, 70, 229, 0.1)',
            borderWidth: 2,
            pointRadius: 0,
            pointHoverRadius: 4,
            fill: true,
            tension: 0.1
          }
        ]
      };
      
      const options = {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            position: 'top',
            labels: { font: { size: 12 } }
          },
          tooltip: {
            callbacks: {
              label: (context) => `f(x) = ${context.parsed.y.toFixed(4)}`
            }
          }
        },
        scales: {
          x: {
            title: { display: true, text: 'x', font: { weight: 'bold' } },
            grid: { color: 'rgba(0,0,0,0.05)' }
          },
          y: {
            title: { display: true, text: 'f(x)', font: { weight: 'bold' } },
            grid: { color: 'rgba(0,0,0,0.05)' }
          }
        }
      };
      
      setChartData({ data, options });
    } catch (err) {
      setError(err.message);
    }
  };

  const setExample = (func) => {
    setFunctionStr(func);
    setTimeout(generatePlot, 100);
  };

  useEffect(() => {
    generatePlot();
  }, []);

  return (
    <div className="plotter-container">
      <div className="card">
        <div className="card-header">
          <h2><span className="icon">📈</span> Function Visualizer</h2>
        </div>
        <div className="card-body">
          <div className="quick-actions">
            <button className="quick-btn" onClick={() => setExample('x^2')}>x²</button>
            <button className="quick-btn" onClick={() => setExample('sin(x)')}>sin(x)</button>
            <button className="quick-btn" onClick={() => setExample('2*x+1')}>2x+1</button>
            <button className="quick-btn" onClick={() => setExample('1/x')}>1/x</button>
            <button className="quick-btn" onClick={() => setExample('exp(x)')}>eˣ</button>
            <button className="quick-btn" onClick={() => setExample('log(x)')}>log(x)</button>
          </div>
          
          <div className="input-group">
            <label>f(x) =</label>
            <input 
              type="text" 
              value={functionStr} 
              onChange={(e) => setFunctionStr(e.target.value)}
              placeholder="e.g., x^2, sin(x), 2*x+1"
              className="function-input"
            />
          </div>
          
          <div className="input-row">
            <div className="input-group">
              <label>X min</label>
              <input 
                type="number" 
                value={xMin} 
                onChange={(e) => setXMin(parseFloat(e.target.value))}
                step="0.5"
              />
            </div>
            <div className="input-group">
              <label>X max</label>
              <input 
                type="number" 
                value={xMax} 
                onChange={(e) => setXMax(parseFloat(e.target.value))}
                step="0.5"
              />
            </div>
          </div>
          
          <button className="btn-primary" onClick={generatePlot}>
            <span className="icon">📊</span> Generate Plot
          </button>
          
          {error && (
            <div className="error-message">
              <span className="icon">⚠️</span> {error}
            </div>
          )}
          
          {chartData && (
            <div className="plot-container">
              <Line data={chartData.data} options={chartData.options} />
            </div>
          )}
        </div>
      </div>
      
      <div className="card">
        <div className="card-header">
          <h2><span className="icon">ℹ️</span> Supported Functions</h2>
        </div>
        <div className="card-body">
          <div className="function-list">
            <div><strong>Basic:</strong> +, -, *, /, ^, ( )</div>
            <div><strong>Trig:</strong> sin, cos, tan, asin, acos, atan</div>
            <div><strong>Log/Exp:</strong> log, ln, exp, sqrt</div>
            <div><strong>Constants:</strong> pi, e</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Plotter;