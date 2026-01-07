# How to Run the Application

## Backend (ASP.NET Core)

### Prerequisites
- .NET 9.0 SDK installed
- Visual Studio, Visual Studio Code, or Rider (optional)

### Steps

1. **Navigate to the backend project directory:**
   ```bash
   cd backend/FindTeammate
   ```

2. **Restore NuGet packages (if needed):**
   ```bash
   dotnet restore
   ```

3. **Run the backend:**
   ```bash
   dotnet run
   ```
   
   Or if you want to use a specific profile:
   ```bash
   dotnet run --launch-profile http
   ```

4. **The backend will start on:**
   - HTTP: `http://localhost:5266`
   - HTTPS: `https://localhost:7028` (if using https profile)

5. **Verify it's running:**
   - Open a browser and go to: `http://localhost:5266/weatherforecast`
   - You should see JSON data if the API is working

### Using Visual Studio/Rider:
- Simply open the `backend/FindTeammate.sln` solution file
- Set `FindTeammate` as the startup project
- Press F5 or click Run

## Frontend (Flutter)

### Prerequisites
- Flutter SDK installed
- Dart SDK (comes with Flutter)

### Steps

1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Get Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Flutter app:**
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```
   or
   ```bash
   flutter run -d web-server --web-port=8080
   ```

   **For Android:**
   ```bash
   flutter run -d android
   ```
   (Make sure you have an emulator running or device connected)

   **For iOS (Mac only):**
   ```bash
   flutter run -d ios
   ```

4. **If running on Android emulator or physical device:**
   - Update the `baseUrl` in `frontend/lib/services/login_service.dart`
   - For Android emulator: use `http://10.0.2.2:5266`
   - For physical device: use your computer's IP address (e.g., `http://192.168.1.100:5266`)

## Running Both Together

1. **Terminal 1 - Start Backend:**
   ```bash
   cd backend/FindTeammate
   dotnet run
   ```

2. **Terminal 2 - Start Frontend:**
   ```bash
   cd frontend
   flutter pub get
   flutter run -d chrome
   ```

## API Endpoints

Once the backend is running, you can test the endpoints:

- **Login:** POST `http://localhost:5266/api/login`
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **Register:** POST `http://localhost:5266/api/register`
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "userName": "username"
  }
  ```

## Troubleshooting

### Backend Issues:
- **Port already in use:** Change the port in `Properties/launchSettings.json`
- **Database errors:** Make sure the `database.db` file is writable
- **Package errors:** Run `dotnet restore` again

### Frontend Issues:
- **Connection errors:** Make sure the backend is running first
- **CORS errors:** Backend CORS is already configured, but make sure backend is running
- **Package errors:** Run `flutter pub get` again
- **Port conflicts:** Use a different port with `--web-port` flag

## Notes

- The database file (`database.db`) will be created automatically in the `backend/FindTeammate` directory
- CORS is configured to allow all origins (for development only)
- The backend runs on port 5266 by default (HTTP) or 7028 (HTTPS)

