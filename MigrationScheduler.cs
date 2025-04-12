using System;
using System.IO;
using System.Timers;

public class MigrationScheduler
{
    // Lock object to prevent parallel execution
    private static bool isMigrationRunning = false;
    private static System.Timers.Timer migrationTimer;
    private static SendToCenterMigrator migrator;
    private static string logDirectoryPath = "logs";  // Directory for logs

    public static void Main(string[] args)
    {
        // Initialize the MigratorAndBelgeCariIntegrator instance
        migrator = new SendToCenterMigrator();

        // Initialize the timer to call the Migrate method every 5 minutes (300000 milliseconds)
        migrationTimer = new System.Timers.Timer(300000); // Every 5 minutes
        migrationTimer.Elapsed += MigrationTimerElapsed;
        migrationTimer.Start();

        // Create log directory if it doesn't exist
        if (!Directory.Exists(logDirectoryPath))
        {
            Directory.CreateDirectory(logDirectoryPath);
        }

        // Write an initial log entry indicating the service has started
        Log("Migration service started.");

        // Wait for user input to exit the program
        Console.ReadLine();
    }

    // Timer callback that attempts to run the migration
    private static void MigrationTimerElapsed(object sender, ElapsedEventArgs e)
    {
        // Check if migration is already running
        if (isMigrationRunning)
        {
            Log("Migration is already running. Skipping this cycle...");
            return;  // Exit if migration is already in progress
        }

        try
        {
            isMigrationRunning = true;
            Log("Migration started...");

            // Call the migration method (replace "someKasaSicilNo" with the actual value)
            migrator.Migrate(txtSicilNo,txtKasaNo);  // Pass the correct KasaSicilNo

            Log("Migration completed.");
        }
        catch (Exception ex)
        {
            // Log the error if the migration fails
            Log($"Error during migration: {ex.Message}");

            // Optionally log the stack trace for more detailed debugging
            Log($"Stack Trace: {ex.StackTrace}");
        }
        finally
        {
            isMigrationRunning = false;  // Mark migration as complete
        }
    }

    // Method to log messages to a file
    private static void Log(string message)
    {
        string logFileName = GetLogFileName(); // Get the file name based on the current date and hour
        string logEntry = $"{DateTime.Now}: {message}\n";
        File.AppendAllText(logFileName, logEntry);  // Append the log entry to the log file
    }

    // Method to get the log file name based on the current date and hour
    private static string GetLogFileName()
    {
        // Format: logs/yyyyMMdd_HH.txt (e.g., logs/20230412_15.txt)
        string currentTime = DateTime.Now.ToString("yyyyMMdd_HH");
        return Path.Combine(logDirectoryPath, $"{currentTime}.txt");
    }
}
