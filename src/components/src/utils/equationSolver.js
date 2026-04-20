import Fraction from 'fraction.js';

export function solveLinearEquation(equation, variable = 'x') {
  // Remove all spaces
  let eq = equation.replace(/\s/g, '');
  
  // Split into left and right sides
  const sides = eq.split('=');
  if (sides.length !== 2) {
    throw new Error('Invalid equation format. Use format: expression = expression');
  }
  
  const left = sides[0];
  const right = sides[1];
  
  // Parse expression to get coefficient and constant
  function parseExpression(expr, varName) {
    // Handle negative numbers at start
    let expression = expr;
    if (expression.startsWith('-')) {
      expression = '0' + expression;
    }
    
    // Split into terms
    const terms = expression.split(/(?=[+-])/);
    let coefficient = 0;
    let constant = 0;
    
    for (const term of terms) {
      if (term.includes(varName)) {
        // Variable term
        let coeff = term.replace(varName, '');
        if (coeff === '+' || coeff === '') coeff = '1';
        if (coeff === '-') coeff = '-1';
        coefficient += evaluateExpression(coeff);
      } else {
        // Constant term
        constant += evaluateExpression(term);
      }
    }
    
    return { coefficient, constant };
  }
  
  function evaluateExpression(expr) {
    if (expr === '') return 0;
    
    // Handle fractions
    if (expr.includes('/')) {
      const parts = expr.split('/');
      const numerator = parseFloat(parts[0]);
      const denominator = parseFloat(parts[1]);
      return numerator / denominator;
    }
    
    // Handle parentheses
    if (expr.includes('(') && expr.includes(')')) {
      const match = expr.match(/(\d*)(?:\*)?\(([^)]+)\)/);
      if (match) {
        const multiplier = match[1] ? parseFloat(match[1]) : 1;
        const inner = evaluateExpression(match[2]);
        return multiplier * inner;
      }
    }
    
    return parseFloat(expr) || 0;
  }
  
  const leftExpr = parseExpression(left, variable);
  const rightExpr = parseExpression(right, variable);
  
  // Move all terms to left side: left - right = 0
  const a = leftExpr.coefficient - rightExpr.coefficient;
  const b = leftExpr.constant - rightExpr.constant;
  
  // Solve ax + b = 0 => x = -b/a
  if (Math.abs(a) < 1e-10) {
    if (Math.abs(b) < 1e-10) {
      throw new Error('Infinite solutions (identity equation)');
    } else {
      throw new Error('No solution (contradiction)');
    }
  }
  
  const solution = -b / a;
  return solution;
}

export function solveSystem(eq1, eq2) {
  // Parse equations to form: a1*x + b1*y = c1
  function parseLinearEquation(eq) {
    const [left, right] = eq.split('=');
    const rightVal = evaluateExpression(right);
    
    // Parse left side
    let leftExpr = left.replace(/\s/g, '');
    let xCoeff = 0;
    let yCoeff = 0;
    let constant = 0;
    
    // Extract x coefficient
    const xMatch = leftExpr.match(/([+-]?\d*\.?\d*)x/);
    if (xMatch) {
      xCoeff = xMatch[1] === '' || xMatch[1] === '+' ? 1 : xMatch[1] === '-' ? -1 : parseFloat(xMatch[1]);
      leftExpr = leftExpr.replace(xMatch[0], '');
    }
    
    // Extract y coefficient
    const yMatch = leftExpr.match(/([+-]?\d*\.?\d*)y/);
    if (yMatch) {
      yCoeff = yMatch[1] === '' || yMatch[1] === '+' ? 1 : yMatch[1] === '-' ? -1 : parseFloat(yMatch[1]);
      leftExpr = leftExpr.replace(yMatch[0], '');
    }
    
    // Remaining is constant
    if (leftExpr) {
      constant = evaluateExpression(leftExpr);
    }
    
    return { a: xCoeff, b: yCoeff, c: rightVal - constant };
  }
  
  function evaluateExpression(expr) {
    if (!expr) return 0;
    expr = expr.replace(/\s/g, '');
    
    // Handle fractions
    if (expr.includes('/')) {
      const parts = expr.split('/');
      return parseFloat(parts[0]) / parseFloat(parts[1]);
    }
    
    return parseFloat(expr) || 0;
  }
  
  const eq1Parsed = parseLinearEquation(eq1);
  const eq2Parsed = parseLinearEquation(eq2);
  
  // Solve using Cramer's rule
  const determinant = eq1Parsed.a * eq2Parsed.b - eq2Parsed.a * eq1Parsed.b;
  
  if (Math.abs(determinant) < 1e-10) {
    throw new Error('No unique solution (parallel or coincident lines)');
  }
  
  const x = (eq1Parsed.c * eq2Parsed.b - eq2Parsed.c * eq1Parsed.b) / determinant;
  const y = (eq1Parsed.a * eq2Parsed.c - eq2Parsed.a * eq1Parsed.c) / determinant;
  
  return { x, y };
}

export function toFraction(decimal, tolerance = 1e-8) {
  const frac = new Fraction(decimal);
  if (frac.d === 1) return frac.n.toString();
  return `${frac.n}/${frac.d}`;
}

export function toMixedNumber(decimal) {
  const frac = new Fraction(decimal);
  const whole = Math.floor(frac.valueOf());
  const remainder = frac.sub(whole);
  
  if (whole === 0) return frac.toFraction();
  if (remainder.valueOf() === 0) return whole.toString();
  
  return `${whole} ${remainder.toFraction()}`;
}