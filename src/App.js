import React, { useState } from 'react';

function App() {
  const [equation, setEquation] = useState('2x + 3 = 7');
  const [solution, setSolution] = useState(null);

  const solveEquation = () => {
    try {
      let eq = equation.replace(/\s/g, '');
      let sides = eq.split('=');
      let left = sides[0];
      let right = sides[1];
      
      // Parse for x
      let leftX = 0, leftConst = 0;
      let terms = left.split(/(?=[+-])/);
      terms.forEach(term => {
        if (term.includes('x')) {
          let coeff = term.replace('x', '');
          if (coeff === '+' || coeff === '') coeff = '1';
          if (coeff === '-') coeff = '-1';
          leftX += eval(coeff);
        } else {
          leftConst += eval(term);
        }
      });
      
      let rightX = 0, rightConst = 0;
      terms = right.split(/(?=[+-])/);
      terms.forEach(term => {
        if (term.includes('x')) {
          let coeff = term.replace('x', '');
          if (coeff === '+' || coeff === '') coeff = '1';
          if (coeff === '-') coeff = '-1';
          rightX += eval(coeff);
        } else {
          rightConst += eval(term);
        }
      });
      
      let a = leftX - rightX;
      let b = leftConst - rightConst;
      let x = -b / a;
      setSolution(x);
    } catch(e) {
      setSolution(null);
    }
  };

  return (
    <div style={{padding: 20, maxWidth: 500, margin: '0 auto'}}>
      <h1>📐 Math Solver</h1>
      <input 
        value={equation} 
        onChange={(e) => setEquation(e.target.value)}
        style={{width: '100%', padding: 10, margin: '10px 0'}}
      />
      <button onClick={solveEquation} style={{padding: 10, width: '100%'}}>
        Solve
      </button>
      {solution !== null && (
        <div style={{marginTop: 20, padding: 20, background: '#f0f0f0'}}>
          Solution: x = {solution}
        </div>
      )}
    </div>
  );
}

export default App;