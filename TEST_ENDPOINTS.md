# Testing Backend Endpoints

Your backend is running on **http://localhost:5266**

## Quick Test Methods

### Method 1: Using the .http file (Recommended for VS Code/Rider)
1. Open `backend/FindTeammate/FindTeammate.http` in your IDE
2. Click "Send Request" above each request
3. View the response in the output panel

### Method 2: Using curl (Command Line)

#### Test Register Endpoint:
```bash
curl -X POST http://localhost:5266/api/register ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"test@example.com\",\"password\":\"Test123!\",\"userName\":\"testuser\"}"
```

#### Test Login Endpoint:
```bash
curl -X POST http://localhost:5266/api/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"test@example.com\",\"password\":\"Test123!\"}"
```

### Method 3: Using PowerShell (Invoke-WebRequest)

#### Test Register:
```powershell
$body = @{
    email = "test@example.com"
    password = "Test123!"
    userName = "testuser"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:5266/api/register" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body
```

#### Test Login:
```powershell
$body = @{
    email = "test@example.com"
    password = "Test123!"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:5266/api/login" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body
```

### Method 4: Using Postman
1. Open Postman
2. Create a new POST request
3. URL: `http://localhost:5266/api/register` or `http://localhost:5266/api/login`
4. Headers: `Content-Type: application/json`
5. Body (raw JSON):
   ```json
   {
     "email": "test@example.com",
     "password": "Test123!",
     "userName": "testuser"
   }
   ```
6. Click Send

### Method 5: Using Flutter Frontend (Best for Full Integration Test)
1. Start the Flutter app: `cd frontend && flutter run`
2. Navigate to the register screen
3. Fill in the form and test registration
4. Then test login with the registered credentials

## Expected Responses

### Successful Registration:
```json
{
  "success": true,
  "message": "Registration successful",
  "userId": "guid-here",
  "userName": "testuser"
}
```

### Failed Registration (Weak Password):
```json
{
  "success": false,
  "message": "Password must contain at least one uppercase letter",
  "userId": null,
  "userName": null
}
```

### Successful Login:
```json
{
  "success": true,
  "message": "Login successful",
  "userId": "guid-here",
  "userName": "testuser"
}
```

### Failed Login:
```json
{
  "success": false,
  "message": "Invalid email or password",
  "userId": null,
  "userName": null
}
```

## Test Scenarios

### 1. Register with Valid Data ✅
- Email: `test@example.com`
- Password: `Test123!` (has uppercase, lowercase, number, special char)
- Username: `testuser`
- **Expected**: 200 OK with success response

### 2. Register with Duplicate Email ❌
- Use the same email from test #1
- **Expected**: 409 Conflict with "already exists" message

### 3. Register with Invalid Email ❌
- Email: `not-an-email`
- **Expected**: 400 Bad Request with validation error

### 4. Register with Weak Password ❌
- Password: `test123` (no uppercase, no special char)
- **Expected**: 400 Bad Request with password complexity error

### 5. Login with Valid Credentials ✅
- Use credentials from successful registration
- **Expected**: 200 OK with success response

### 6. Login with Wrong Password ❌
- Correct email, wrong password
- **Expected**: 401 Unauthorized with error message

### 7. Login with Non-existent Email ❌
- Email that doesn't exist
- **Expected**: 401 Unauthorized with error message

## Password Requirements
- ✅ At least 6 characters
- ✅ At least one uppercase letter (A-Z)
- ✅ At least one lowercase letter (a-z)
- ✅ At least one number (0-9)
- ✅ At least one special character (!@#$%^&*()_+-=[]{}|;':"\,.<>/? etc.)

## Quick Test Password Examples
- ✅ Valid: `Test123!`, `MyPass1@`, `Secure#2024`
- ❌ Invalid: `test123` (no uppercase, no special), `TEST123!` (no lowercase), `TestPass!` (no number)

