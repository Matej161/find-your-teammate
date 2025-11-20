namespace Database;

public static class Status
{
    public static void Clear()
    {
        Console.BackgroundColor = ConsoleColor.White;
        Console.Clear();
        for (int i = 0; i < 25; i++)
        {
            Console.WriteLine();
        }
    }
    
    public static void PrintError(string text)
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine("[ERROR] " + text);
    }

    public static void PrintWarning(string text)
    {
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.WriteLine("[WARNING] " + text);
    }

    public static void PrintSuccess(string text)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("[SUCCESS] " + text);
    }
    
    public static void PrintInfo(string text)
    {
        Console.ForegroundColor = ConsoleColor.White;
        Console.WriteLine(text);
    }

    public static void PrintException(string text)
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine("[EXCEPTION] " + text);
    }
}