# Ducky Quacker: All about ducks

Quacky Tapper is a short game about making a Duck quack. Create and login to an account to have your own ducks to Quack! Quack more to get upgrades to quack even more!

![QuickTask App Preview](https://github.com/yourusername/quicktask/blob/main/screenshots/app_preview.png?raw=true)

## 🛠️ Prerequisites
Before running this project, ensure you have the following installed:
- Flutter SDK (v3.10 or later)
- Dart Frog CLI
- A working Android Emulator Simulator

## 🚀 Setup & Installation

### 1. Start the Server
First, you need to turn on the backend. Navigate to the `server` folder:
```bash
cd duck_api
dart_frog dev
```

**Note:** The server runs on `localhost:8080` by default.

### 2. Configure the App
Create a `.env` file in the root directory of your Flutter project:
```env
BASE_URL=http://10.0.2.2:8080
```

Make sure to load the `.env` file in your app configuration (e.g., using the `flutter_dotenv` package).

### 3. Run the App
Open a new terminal, navigate to the root folder, and run:
```bash
flutter pub get
flutter run
```

## 📱 Features
* **Ducks**: An unassuming duck that you can tap to quack.
* **Duck Upgrades**: Treat your duck right and give it the love it deserves. Feed your duck with upgrades and it might just give you more quacks.
* **Duck Sync**: Every owner has their own ducks saved in the duck server. If the owner disappears, do does the duck!

## 📸 Screenshots

### Login Screen
![Home Screen](screenshots/home_screen.png)
*Main task list view showing active todos*

### Duck Screen
![Add Task Screen](https://github.com/yourusername/quicktask/blob/main/screenshots/add_task.png?raw=true)
*Task creation interface*

### Duck Upgrade Screen
![Completed Task](screenshots/task_complete.png)
*Swipe gesture to mark tasks as complete*

### Duck Details Screen
![Completed Task](screenshots/task_complete.png)
*Swipe gesture to mark tasks as complete*

**Screenshot Guidelines:**
- **Local Reference**: `![Alt Text](screenshots/image.png)` - Store images in a `screenshots` folder in your repo
- **GitHub URL**: `![Alt Text](https://github.com/username/repo/blob/main/path/image.png?raw=true)` - Use full GitHub URL with `?raw=true`
- **External Hosting**: `![Alt Text](https://imgur.com/your-image.png)` - Upload to Imgur, Cloudinary, or similar services


## 🔗 API Reference
Here are the endpoints available on the Dart Frog server:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/accounts` | Fetches all accounts |
| GET | `/accounts/[id]` | Fetches a specific account by ID |
| GET | `/ducks` | Fetches all ducks |
| GET | `/ducks/[id]` | Fetches a specific duck by ID |

## 📁 Project Structure
```
duck_tapper/
├── duck_api/
| ├── 
├── lib/
│ ├── config/
│ │ └── env_config.dart
│ ├── screens/
│ └── main.dart
├── server/
│ └── routes/
├── screenshots/
│ ├── home_screen.png
│ ├── add_task.png
│ └── task_complete.png
├── .env
└── README.md
```