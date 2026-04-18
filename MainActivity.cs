using Android.App;
using Android.OS;
using Android.Widget;
using Android.Graphics;
using Android.Views;
using System;
using System.Data;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace MathematicaConsole;

[Activity(Label = "Mathematica Console", MainLauncher = true)]
public class MainActivity : Activity
{
    private EditText? inputField;
    private TextView? outputArea;
    private LinearLayout? layout;
    private int counter = 1;
    private List<string> history = new List<string>();
    private int historyIndex = 0;
    
    protected override void OnCreate(Bundle? savedInstanceState)
    {
        base.OnCreate(savedInstanceState);
        
        layout = new LinearLayout(this);
        layout.Orientation = Orientation.Vertical;
        layout.SetBackgroundColor(Color.ParseColor("#1e1e1e"));
        
        var title = new TextView(this);
        title.Text = "Mathematica Console";
        title.TextSize = 24;
        title.Gravity = GravityFlags.Center;
        title.SetBackgroundColor(Color.ParseColor("#2d2d2d"));
        title.SetTextColor(Color.ParseColor("#4ec9b0"));
        title.SetPadding(0, 30, 0, 30);
        
        outputArea = new TextView(this);
        outputArea.TextSize = 16;
        outputArea.SetTypeface(Typeface.Create("monospace", TypefaceStyle.Normal), TypefaceStyle.Normal);
        outputArea.SetTextColor(Color.White);
        outputArea.SetPadding(30, 30, 30, 30);
        
        outputArea.Text = "========================================\n";
        outputArea.Text += "    Mathematica Console v1.0\n";
        outputArea.Text += "========================================\n\n";
        outputArea.Text += "Examples:\n";
        outputArea.Text += "  2 + 2 = 4\n";
        outputArea.Text += "  10 / 3 = 3.333\n";
        outputArea.Text += "  (5+3)*2 = 16\n";
        outputArea.Text += "  2^3 = 8\n";
        outputArea.Text += "  Sin[30] = 0.5\n";
        outputArea.Text += "  Sqrt[16] = 4\n";
        outputArea.Text += "  Log[100] = 2\n\n";
        outputArea.Text += "Type any math expression below!\n";
        outputArea.Text += "========================================\n";
        
        var inputLayout = new LinearLayout(this);
        inputLayout.Orientation = Orientation.Horizontal;
        inputLayout.SetBackgroundColor(Color.ParseColor("#252526"));
        inputLayout.SetPadding(20, 20, 20, 20);
        
        var prompt = new TextView(this);
        prompt.Text = $"[{counter}]> ";
        prompt.TextSize = 16;
        prompt.SetTypeface(Typeface.Create("monospace", TypefaceStyle.Bold), TypefaceStyle.Bold);
        prompt.SetTextColor(Color.ParseColor("#4ec9b0"));
        
        inputField = new EditText(this);
        inputField.TextSize = 16;
        inputField.Hint = "Enter expression...";
        inputField.SetTypeface(Typeface.Create("monospace", TypefaceStyle.Normal), TypefaceStyle.Normal);
        inputField.LayoutParameters = new LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WrapContent, 1);
        inputField.SetTextColor(Color.ParseColor("#d4d4d4"));
        inputField.SetHintTextColor(Color.ParseColor("#6a6a6a"));
        inputField.SetBackgroundColor(Color.Transparent);
        
        inputField.EditorAction += (s, e) => {
            if (e.ActionId == Android.Views.InputMethods.ImeAction.Send)
            {
                Evaluate();
                e.Handled = true;
            }
        };
        
        inputField.KeyPress += (s, e) => {
            if (e.KeyCode == Keycode.DpadUp && history.Count > 0)
            {
                if (historyIndex > 0) historyIndex--;
                inputField.Text = history[historyIndex];
                inputField.SetSelection(inputField.Text.Length);
                e.Handled = true;
            }
            else if (e.KeyCode == Keycode.DpadDown && historyIndex < history.Count - 1)
            {
                historyIndex++;
                inputField.Text = history[historyIndex];
                inputField.SetSelection(inputField.Text.Length);
                e.Handled = true;
            }
        };
        
        var button = new Button(this);
        button.Text = "=";
        button.SetBackgroundColor(Color.ParseColor("#0e639c"));
        button.SetTextColor(Color.White);
        button.Click += (s, e) => Evaluate();
        
        inputLayout.AddView(prompt);
        inputLayout.AddView(inputField);
        inputLayout.AddView(button);
        
        layout.AddView(title);
        layout.AddView(outputArea, new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MatchParent, 0, 1));
        layout.AddView(inputLayout);
        
        SetContentView(layout);
        inputField.RequestFocus();
    }
    
    private void Evaluate()
    {
        if (inputField == null || outputArea == null) return;
        
        string input = inputField.Text?.Trim() ?? "";
        if (string.IsNullOrEmpty(input)) return;
        
        history.Add(input);
        historyIndex = history.Count;
        
        // Show input
        outputArea.Text = $"\n[{counter}]> {input}\n" + outputArea.Text;
        
        // Evaluate
        string result = MathematicaEvaluate(input);
        outputArea.Text = $"[{counter}] = {result}\n" + outputArea.Text;
        
        inputField.Text = "";
        counter++;
        
        // Update prompt
        var prompt = ((LinearLayout)inputField.Parent).GetChildAt(0) as TextView;
        if (prompt != null) prompt.Text = $"[{counter}]> ";
    }
    
    private string MathematicaEvaluate(string expr)
    {
        try
        {
            // Basic arithmetic
            if (Regex.IsMatch(expr, @"^[\d\s\+\-\*/\(\)\^\.]+$"))
            {
                return EvaluateArithmetic(expr);
            }
            
            // Constants
            if (expr == "Pi") return Math.PI.ToString();
            if (expr == "E") return Math.E.ToString();
            
            // Sin, Cos, Tan
            var trigMatch = Regex.Match(expr, @"(Sin|Cos|Tan)\[(\d+(?:\.\d+)?)\]", RegexOptions.IgnoreCase);
            if (trigMatch.Success)
            {
                double val = double.Parse(trigMatch.Groups[2].Value);
                double rad = val * Math.PI / 180;
                double trigResult = trigMatch.Groups[1].Value.ToLower() switch
                {
                    "sin" => Math.Sin(rad),
                    "cos" => Math.Cos(rad),
                    "tan" => Math.Tan(rad),
                    _ => 0
                };
                return $"{trigMatch.Groups[1].Value}({val}°) = {trigResult:F6}";
            }
            
            // Sqrt
            var sqrtMatch = Regex.Match(expr, @"Sqrt\[(\d+(?:\.\d+)?)\]", RegexOptions.IgnoreCase);
            if (sqrtMatch.Success)
            {
                double val = double.Parse(sqrtMatch.Groups[1].Value);
                return $"√{val} = {Math.Sqrt(val):F6}";
            }
            
            // Log
            var logMatch = Regex.Match(expr, @"Log\[(\d+(?:\.\d+)?)\]", RegexOptions.IgnoreCase);
            if (logMatch.Success)
            {
                double val = double.Parse(logMatch.Groups[1].Value);
                return $"log({val}) = {Math.Log10(val):F6}";
            }
            
            // Default
            return EvaluateArithmetic(expr);
        }
        catch (Exception ex)
        {
            return $"Error: {ex.Message}";
        }
    }
    
    private string EvaluateArithmetic(string expr)
    {
        try
        {
            // Replace ^ with Math.Pow
            var powMatches = Regex.Matches(expr, @"(\d+(?:\.\d+)?)\^(\d+(?:\.\d+)?)");
            foreach (Match match in powMatches)
            {
                double baseNum = double.Parse(match.Groups[1].Value);
                double exponent = double.Parse(match.Groups[2].Value);
                double powResult = Math.Pow(baseNum, exponent);
                expr = expr.Replace(match.Value, powResult.ToString());
            }
            
            var table = new DataTable();
            var evalResult = table.Compute(expr, "");
            return $"{expr} = {evalResult}";
        }
        catch
        {
            return $"Could not evaluate: {expr}";
        }
    }
}
