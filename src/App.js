import React, { useState } from 'react';

function App() {
  const [equation, setEquation] = useState('2x + 3 = 7');
  const [solution, setSolution] = useState(null);
  const [error, setError] = useState(null);

  const solveEquation = () => {
    setError(null);
    setSolution(null);
    
    try {
      let eq = equation.replace(/\s/g, '');
      let sides = eq.split('=');
      
      if (sides.length !== 2) {
        setError('Use format: expression = expression');
        return;
      }
      
      function parse(expr) {
        let xCoeff = 0;
        let constant = 0;
        let terms = expr.split(/(?=[+-])/);
        
        for (let term of terms) {
          if (term === '') continue;
          
          if (term.includes('x')) {
            let coeff = term.replace('x', '');
            if (coeff === '+' || coeff === '') coeff = '1';
            if (coeff === '-') coeff = '-1';
            if (coeff.includes('/')) {
              let f = coeff.split('/');
              coeff = eval(f[0]) / eval(f[1]);
            } else {
              coeff = eval(coeff);
            }
            xCoeff += coeff;
          } else {
            let val = term;
            if (val.includes('/')) {
              let f = val.split('/');
              val = eval(f[0]) / eval(f[1]);
            } else {
              val = eval(val);
            }
            constant += val;
          }
        }
        return { xCoeff, constant };
      }
      
      let left = parse(sides[0]);
      let right = parse(sides[1]);
      
      let a = left.xCoeff - right.xCoeff;
      let b = left.constant - right.constant;
      
      if (Math.abs(a) < 0.000001) {
        setError(Math.abs(b) < 0.000001 ? 'Infinite solutions' : 'No solution');
        return;
      }
      
      let x = -b / a;
      setSolution(x);
      
    } catch(e) {
      setError('Invalid equation');
    }
  };

  return (
    <div style={{minHeight: '100vh', background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', padding: 20}}>
      <div style={{maxWidth: 500, margin: '0 auto', background: 'white', borderRadius: 20, padding: 24, boxShadow: '0 10px 40px rgba(0,0,0,0.1)'}}>
        <h1 style={{textAlign: 'center', marginBottom: 8, color: '#1F2937'}}>📐 Math Solver</h1>
        <p style={{textAlign: 'center', marginBottom: 24, color: '#6B7280'}}>Linear Equation Solver</p>
        
        <div style={{display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 20}}>
          <button onClick={() => setEquation('2x + 3 = 7')} style={{padding: '8px 16px', background: '#F3F4F6', border: 'none', borderRadius: 20, cursor: 'pointer'}}>2x+3=7</button>
          <button onClick={() => setEquation('x/2 + 1/3 = 3x/4')} style={{padding: '8px 16px', background: '#F3F4F6', border: 'none', borderRadius: 20, cursor: 'pointer'}}>x/2+1/3=3x/4</button>
          <button onClick={() => setEquation('5x - 2 = 3x + 8')} style={{padding: '8px 16px', background: '#F3F4F6', border: 'none', borderRadius: 20, cursor: 'pointer'}}>5x-2=3x+8</button>
        </div>
        
        <input 
          value={equation} 
          onChange={(e) => setEquation(e.target.value)}
          style={{width: '100%', padding: 12, fontSize: 16, marginBottom: 16, border: '2px solid #E5E7EB', borderRadius: 12, fontFamily: 'monospace'}}
        />
        
        <button 
          onClick={solveEquation}
          style={{width: '100%', padding: 14, background: '#4F46E5', color: 'white', border: 'none', borderRadius: 12, fontSize: 16, fontWeight: 'bold', cursor: 'pointer'}}
        >
          🔍 Solve Equation
        </button>
        
        {error && (
          <div style={{marginTop: 20, padding: 16, background: '#FEE2E2', color: '#DC2626', borderRadius: 12}}>
            ⚠️ {error}
          </div>
        )}
        
        {solution !== null && (
          <div style={{marginTop: 20, padding: 20, background: '#D1FAE5', borderRadius: 12}}>
            <div style={{fontSize: 14, color: '#059669', marginBottom: 8}}>✓ Solution Found</div>
            <div style={{fontSize: 32, fontWeight: 'bold', color: '#1F2937', fontFamily: 'monospace'}}>
              x = {solution.toFixed(6)}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default App;