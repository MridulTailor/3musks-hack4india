# Wifi attendance app made in Flutter and Django submission for Hack4India hackathon by 3Musketeers

# Frontend
## Overview

This code is the main.dart file for a Flutter application. It sets up the configuration and structure of the application, including the routes and themes. The code imports necessary dependencies, such as firebase_options.dart and the different screen files (home_page.dart, login_page.dart, signup_page.dart, and splash_screen.dart), as well as other Flutter-related packages.

## Main Function

The main function is defined as an asynchronous function that initializes Firebase and then runs the Flutter application. It ensures that the Flutter bindings are initialized using `WidgetsFlutterBinding.ensureInitialized()`, and then it initializes Firebase using `Firebase.initializeApp()` with the default Firebase options for the current platform. Finally, it runs the `MyApp` widget.

## MyApp Class

The `MyApp` class is a stateless widget that serves as the root of the application. It extends the `StatelessWidget` class and overrides the `build` method. In the `build` method, a `MaterialApp` widget is returned, which represents the entire Flutter application.

## MaterialApp Widget

The `MaterialApp` widget has various properties and configurations. The `title` property sets the title of the application to "Flutter Demo". The `theme` property defines the theme for the application, including the color scheme, material3 usage, and the app bar theme.

The color scheme is set using `ColorScheme.fromSeed` with a seedColor of `Colors.deepPurple`. This sets the primary color for the application to deep purple.

The `useMaterial3` property is set to `true`, indicating that the application should use the Material3 design system.

The `appBarTheme` property configures the theme for the app bar. It sets the background color to indigo, centers the title, and defines the icon and title text styles.

The `routes` property is a map that defines the routes for the application. Each route is associated with a specific screen widget. The routes defined in the code include '/', '/login', '/signup', and '/home', which map to the SplashScreen, LoginPage, SignUpPage, and HomePage widgets, respectively.

## Additional Details

- The code initializes Firebase using the default Firebase options for the current platform.
- The `MyApp` class is a stateless widget that serves as the root of the application.
- The `MaterialApp` widget has various properties and configurations, including the color scheme, material3 usage, and the app bar theme.
- The `routes` property is a map that defines the routes for the application.
- The code sets up the basic structure and configuration of a Flutter application, including the initialization of Firebase, defining routes for different screens, and configuring the theme of the application.


# Backend
## Overview
This Python script defines an API view for managing attendance sessions using the Django REST framework. The API view provides three actions: starting a new attendance session, ending an active attendance session, and storing additional data for an attendance session. The script retrieves data from the HTTP request and processes it accordingly. 

## Dependencies
The script requires the following dependencies:
- Django
- Django REST framework

## Usage
To use the API view, you can send HTTP requests to the appropriate endpoint. The available endpoints are:
- `/attendance/start/`: Starts a new attendance session.
- `/attendance/end/`: Ends an active attendance session and returns a list of active students.
- `/attendance/data/`: Stores additional data for an attendance session.

The expected format of the request data is a JSON object with the following fields:
- `action`: The action to perform (`on`, `off`, or `custom`).
- `username`: The username of the student.
- `session_id`: The ID of the attendance session.
- `wifi_id`: The ID of the student's WiFi connection.
- `date`: The date of the attendance record.
- `checkIn`: The time of the attendance record.

## Logic
The script defines an `AttendanceSessionView` class that extends the `APIView` class from the Django REST framework. The `post` method of the `AttendanceSessionView` class handles HTTP POST requests to the API view.

The `post` method first retrieves the `action` field from the request data. If the `action` is `on`, a new attendance session is created and a response is returned with the ID of the new session. If the `action` is `off`, the active attendance session is ended, and a list of active students is returned. If the `action` is `custom`, additional data is stored for the attendance session.

If the `action` is `off`, the method retrieves the `wifi_id` and `session_id` fields from the request data. It then queries the `StudentData` model to retrieve all records for the specified `wifi_id` and `session_id`. If multiple records are found, a list of active students is created and returned in the response. If no records are found, an error response is returned. If only one record is found, the response includes the username, date, and check-in time of the student.

If the `action` is `custom`, the method retrieves the `username`, `session_id`, `wifi_id`, `date`, and `checkIn` fields from the request data. It then creates a new `StudentData` record with the specified data.

If an error occurs during the processing of the request, an appropriate error response is returned.

### Additional Details
- The script uses the `timezone` module from Django to get the current time.
- The `AttendanceSession` model has two fields: `start_time` and `is_active`. The `start_time` field stores the start time of the attendance session, and the `is_active` field indicates whether the session is currently active.
- The `StudentData` model has five fields: `username`, `session_id`, `wifi_id`, `date`, and `checkIn`. These fields store the attendance data for each student. 
- The `AttendanceSessionView` class uses the `Response` and `status` classes from the Django REST framework to return HTTP responses with appropriate status codes. 
- The `AttendanceSessionView` class uses `try-except` blocks to handle exceptions that may occur during the processing of the request. 
- The `AttendanceSessionView` class uses list comprehension to create a list of active students in the response.

