using Microsoft.Maui.Controls;

namespace aperture4;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
        
        // Fix for obsolete MainPage
        if (Windows.Count > 0)
        {
            Windows[0].Page = new MainPage();
        }
        else
        {
            MainPage = new MainPage();
        }
    }
    
    protected override Window CreateWindow(IActivationState? activationState)
    {
        return new Window(new MainPage());
    }
}
