using System;
using System.Data;
using System.Data.SqlClient;

class FitnessApp
{
    // Connection string (Update with your database credentials)
    private static string connectionString = @"Server=localhost;Database=ExerciseSchedule;Integrated Security=True;";
    private static SqlConnection connection;

    static void Main(string[] args)
    {
        try
        {
            // Establish the database connection
            connection = new SqlConnection(connectionString);
            connection.Open();
            Console.WriteLine("Connected to the database.");

            // Example menu-driven interface
            while (true)
            {
                Console.WriteLine("\nMenu:");
                Console.WriteLine("1. Register User");
                Console.WriteLine("2. Log Workout");
                Console.WriteLine("3. View Diet Plans");
                Console.WriteLine("4. Exit");
                Console.Write("Choose an option: ");
                int choice = int.Parse(Console.ReadLine());

                switch (choice)
                {
                    case 1:
                        RegisterUser();
                        break;
                    case 2:
                        LogWorkout();
                        break;
                    case 3:
                        ViewDietPlans();
                        break;
                    case 4:
                        Console.WriteLine("Exiting...");
                        connection.Close();
                        return;
                    default:
                        Console.WriteLine("Invalid choice, please try again.");
                        break;
                }
            }
        }
        catch (SqlException e)
        {
            Console.WriteLine("An error occurred while communicating with the database:");
            Console.WriteLine(e.Message);
        }
    }

    // Method to register a user
    private static void RegisterUser()
    {
        Console.Write("Enter First Name: ");
        string firstName = Console.ReadLine();
        Console.Write("Enter Last Name: ");
        string lastName = Console.ReadLine();
        Console.Write("Enter Weight: ");
        double weight = double.Parse(Console.ReadLine());
        Console.Write("Enter Password: ");
        string password = Console.ReadLine();

        using (SqlCommand cmd = new SqlCommand("RegisterUser", connection))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FirstName", firstName);
            cmd.Parameters.AddWithValue("@LastName", lastName);
            cmd.Parameters.AddWithValue("@Weight", weight);
            cmd.Parameters.AddWithValue("@Password", password);

            try
            {
                cmd.ExecuteNonQuery();
                Console.WriteLine("User registered successfully.");
            }
            catch (SqlException e)
            {
                Console.WriteLine("Error: " + e.Message);
            }
        }
    }

    // Method to log a workout
    private static void LogWorkout()
    {
        Console.Write("Enter Exercise Type: ");
        string exerciseType = Console.ReadLine();
        Console.Write("Enter Sets: ");
        int sets = int.Parse(Console.ReadLine());
        Console.Write("Enter Reps: ");
        int reps = int.Parse(Console.ReadLine());
        Console.Write("Enter Weight: ");
        double weight = double.Parse(Console.ReadLine());

        using (SqlCommand cmd = new SqlCommand("LogWorkout", connection))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ExerciseType", exerciseType);
            cmd.Parameters.AddWithValue("@Sets", sets);
            cmd.Parameters.AddWithValue("@Reps", reps);
            cmd.Parameters.AddWithValue("@Weight", weight);

            try
            {
                cmd.ExecuteNonQuery();
                Console.WriteLine("Workout logged successfully.");
            }
            catch (SqlException e)
            {
                Console.WriteLine("Error: " + e.Message);
            }
        }
    }

    // Method to view diet plans
    private static void ViewDietPlans()
    {
        using (SqlCommand cmd = new SqlCommand("GetDietPlans", connection))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    Console.WriteLine("Diet Plans:");
                    while (reader.Read())
                    {
                        Console.WriteLine("Plan ID: " + reader["PlanID"]);
                        Console.WriteLine("Diet Name: " + reader["DietName"]);
                        Console.WriteLine("Description: " + reader["Description"]);
                        Console.WriteLine();
                    }
                }
            }
            catch (SqlException e)
            {
                Console.WriteLine("Error: " + e.Message);
            }
        }
    }
}