namespace MathToolsApp.Services;

public class StatisticsEngine
{
    public double Mean(double[] data) => data.Average();
    
    public double Median(double[] data)
    {
        var sorted = data.OrderBy(x => x).ToArray();
        int n = sorted.Length;
        if (n % 2 == 0)
            return (sorted[n / 2 - 1] + sorted[n / 2]) / 2;
        return sorted[n / 2];
    }
    
    public double StandardDeviation(double[] data)
    {
        double mean = Mean(data);
        double sumSquaredDiff = data.Sum(x => Math.Pow(x - mean, 2));
        return Math.Sqrt(sumSquaredDiff / data.Length);
    }
}