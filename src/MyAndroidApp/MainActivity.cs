using Android.App;
using Android.OS;
using Android.Widget;
using Android.Graphics;
using Android.Views;

namespace MyAndroidApp;

[Activity(Label = "My Android App", MainLauncher = true)]
public class MainActivity : Activity
{
    int clickCount = 0;
    TextView? counterText;
    TextView? statusText;
    Button? button;
    
    protected override void OnCreate(Bundle? savedInstanceState)
    {
        base.OnCreate(savedInstanceState);
        
        // Create main layout
        LinearLayout layout = new LinearLayout(this);
        layout.Orientation = Orientation.Vertical;
        layout.SetPadding(50, 100, 50, 100);
        
        // Title
        TextView title = new TextView(this);
        title.Text = "My Android App";
        title.TextSize = 32;
        title.Gravity = GravityFlags.CenterHorizontal;
        title.SetTextColor(Color.ParseColor("#6200EE"));
        title.SetTypeface(null, TypefaceStyle.Bold);
        title.SetPadding(0, 0, 0, 40);
        
        // Subtitle
        TextView subtitle = new TextView(this);
        subtitle.Text = "Built with GitHub Actions";
        subtitle.TextSize = 16;
        subtitle.Gravity = GravityFlags.CenterHorizontal;
        subtitle.SetTextColor(Color.ParseColor("#666666"));
        subtitle.SetPadding(0, 0, 0, 60);
        
        // Counter display
        counterText = new TextView(this);
        counterText.Text = "Ready to click!";
        counterText.TextSize = 28;
        counterText.Gravity = GravityFlags.CenterHorizontal;
        counterText.SetTextColor(Color.ParseColor("#333333"));
        counterText.SetPadding(0, 0, 0, 40);
        
        // Button
        button = new Button(this);
        button.Text = "Click Me!";
        button.TextSize = 20;
        button.SetBackgroundColor(Color.ParseColor("#6200EE"));
        button.SetTextColor(Color.White);
        button.SetPadding(40, 20, 40, 20);
        
        // Status message
        statusText = new TextView(this);
        statusText.Text = "Tap the button to start";
        statusText.TextSize = 14;
        statusText.Gravity = GravityFlags.CenterHorizontal;
        statusText.SetTextColor(Color.ParseColor("#999999"));
        statusText.SetPadding(0, 60, 0, 0);
        
        // Button click handler
        button.Click += (sender, e) =>
        {
            clickCount++;
            
            if (counterText != null && statusText != null && button != null)
            {
                if (clickCount == 1)
                {
                    counterText.Text = "🎉 1 click! 🎉";
                    statusText.Text = "Great start!";
                }
                else if (clickCount <= 5)
                {
                    counterText.Text = $"⚡ {clickCount} clicks! ⚡";
                    statusText.Text = "You're on fire!";
                }
                else if (clickCount <= 10)
                {
                    counterText.Text = $"🔥 {clickCount} clicks! 🔥";
                    statusText.Text = "Amazing! Keep going!";
                }
                else
                {
                    counterText.Text = $"🏆 {clickCount} clicks! 🏆";
                    statusText.Text = "You're a champion!";
                }
                
                if (clickCount == 10)
                    button.Text = "You're Awesome!";
                else if (clickCount == 20)
                    button.Text = "Unstoppable!";
            }
        };
        
        // Add all views to layout
        layout.AddView(title);
        layout.AddView(subtitle);
        layout.AddView(counterText);
        layout.AddView(button);
        layout.AddView(statusText);
        
        SetContentView(layout);
    }
}