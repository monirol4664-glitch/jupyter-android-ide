using Microsoft.Maui.Controls;

namespace MathematicaConsole;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
        MainPage = new MainPage();
    }
}