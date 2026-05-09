CREATE DATABASE ExerciseSchedule;

CREATE TABLE Users (
 user_id int PRIMARY KEY NOT NULL,
 user_first_name nvarchar(50),
 user_last_name nvarchar(50),
 user_weight decimal(5, 2),
 user_password nvarchar(255)
);
select * from Users ;
insert into  Users values (1, 'john', 'shipapo',68.0,'1234s');

CREATE TABLE Preferances (
 preferance_id int PRIMARY KEY NOT NULL,
 user_goal ntext,
 user_notification_frequency decimal(5, 2),
 user_profile_customization ntext
);
CREATE TABLE DietPlan (
 diet_plan_id int PRIMARY KEY NOT NULL,
 plane_name nvarchar(100),
 protein decimal(5, 2),
 fats decimal(5, 2),
 calories decimal(10, 2)
);
CREATE TABLE Settings (
 settings_id int PRIMARY KEY NOT NULL,
 theme nvarchar(50),
 privacy nvarchar(50),
 backup_restore nvarchar(50)
);
CREATE TABLE Notification (
 notification_id int PRIMARY KEY NOT NULL,
 preview_text ntext,
 notification_date datetime,
 priority_level int
);
CREATE TABLE WorkoutPlan (
 workout_plan_id int PRIMARY KEY NOT NULL,
 exercise_type nvarchar(50),
 sets int,
 reps int,
 weight decimal(5, 2)
);
CREATE TABLE User_Settings (
 user_id int,
 settings_id int,
 PRIMARY KEY (user_id, settings_id),
 CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
 CONSTRAINT fk_settings_id FOREIGN KEY (settings_id) REFERENCES Settings(settings_id)
);
CREATE TABLE User_Notification (
 user_id int,
 notification_id int,
 PRIMARY KEY (user_id, notification_id),
 CONSTRAINT fk1_user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
 CONSTRAINT fk_notification_id FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
);
CREATE TABLE User_Preferance (
 user_id int,
 preferance_id int,
 PRIMARY KEY (user_id, preferance_id),
 CONSTRAINT fk2_user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
 CONSTRAINT fk_preferance_id FOREIGN KEY (preferance_id) REFERENCES Preferances(preferance_id)
);

CREATE PROCEDURE RegisterUser
   
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Weight DECIMAL(5,2),
    @Password NVARCHAR(255)
AS
BEGIN
    INSERT INTO Users (user_first_name, user_last_name, user_weight, user_password)
    VALUES (@FirstName, @LastName, @Weight, @Password);
END


CREATE PROCEDURE LogWorkout
    @ExerciseType NVARCHAR(50),
    @Sets INT,
    @Reps INT,
    @Weight DECIMAL(5,2)
AS
BEGIN
    INSERT INTO WorkoutPlan (exercise_type, sets, reps, weight)
    VALUES (@ExerciseType, @Sets, @Reps, @Weight);
END




CREATE TRIGGER SetDefaultPreferences
ON Users
AFTER INSERT
AS
BEGIN
    DECLARE @UserID INT;
    SELECT @UserID = user_id FROM inserted;
    
    INSERT INTO Preferances (preferance_id, user_goal, user_notification_frequency, user_profile_customization)
    VALUES (@UserID, 'General Fitness', 1, 'Default');
END



CREATE PROCEDURE GetDietPlans
AS
BEGIN
    DECLARE @PlanName NVARCHAR(100), @Protein DECIMAL(5,2), @Fats DECIMAL(5,2), @Calories DECIMAL(10,2);
    
    DECLARE DietCursor CURSOR FOR
    SELECT plane_name, protein, fats, calories FROM DietPlan;
    
    OPEN DietCursor;
    
    FETCH NEXT FROM DietCursor INTO @PlanName, @Protein, @Fats, @Calories;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Plan Name: ' + @PlanName + ', Protein: ' + CAST(@Protein AS NVARCHAR(5)) +
              ', Fats: ' + CAST(@Fats AS NVARCHAR(5)) + ', Calories: ' + CAST(@Calories AS NVARCHAR(10));
        FETCH NEXT FROM DietCursor INTO @PlanName, @Protein, @Fats, @Calories;
    END
    
    CLOSE DietCursor;
    DEALLOCATE DietCursor;
END


