# Ducky Quacker: All about ducks

Quacky Tapper is a short game about making a Duck quack. Create and login to an account to have your own ducks to Quack! Quack more to get upgrades to quack even more!


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
Modify the `.env.development` file in the root directory of your Flutter project:
```env
BASE_URL=http://10.0.2.2:8080
```

For **iOS Simulator** or **physical devices**, use your computer's local IP.
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
* **Dynamic Duck**: Every upgrade you buy gives the duck you quack some friends and food. Buy unique upgrades to make it happier!
* **Duck Sync**: Every owner has their own ducks saved in the duck server. If the owner disappears, so does the duck tied to it!
* **Incrementing Quacks**: The more Upgrades the more quacks! Get as many quacks as you can!

## 📸 Screenshots

### Login Screen
![Login Screen](screenshots/login_screen.png)

*Login screen with a working password visibility toggle on password*

### Login Screen
![Register Screen](screenshots/register_dialog.png)

*Register Dialog Box*

### Duck Screen
![Duck Screen](screenshots/duck_screen.png)

*Screen where you quack the duck*

### Duck Upgrade Screen
![Upgrades Screen](screenshots/upgrades_screen.png)

*Screen to show upgrades that you can buy with quacks to get more quacks from duck tapping*

## Duck Upgrade Screen: Dynamic Display
![Dynamic Upgrade Display](screenshots/upgrades_screen_more.png)

*Next available upgrade becomes available once you buy the previous upgrade once*

## Duck Upgrade Screen: Dynamic Duck
![Dynamic Upgrade Display](screenshots/dynamic_duck.png)

*The Duck you quack reflects the upgrades you bought*

### Duck Details Screen
![Details Screen](screenshots/task_complete.png)

*Specific list of details in actions the user has done with the duck. Includes duck mood*

<!-- **Screenshot Guidelines:**
- **Local Reference**: `![Alt Text](screenshots/image.png)` - Store images in a `screenshots` folder in your repo
- **GitHub URL**: `![Alt Text](https://github.com/username/repo/blob/main/path/image.png?raw=true)` - Use full GitHub URL with `?raw=true`
- **External Hosting**: `![Alt Text](https://imgur.com/your-image.png)` - Upload to Imgur, Cloudinary, or similar services -->


## 🔗 API Reference
Here are the endpoints available on the Dart Frog server:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/accounts` | Fetches all accounts |
| GET    | `/accounts/[id]` | Fetches a specific account by ID |
| GET    | `/ducks` | Fetches all ducks |
| GET    | `/ducks/[id]` | Fetches a specific duck by ID |
| POST   | `/accounts` | Adds a new Account |
| POST   | `/ducks` | Adds a new duck |
| PUT    | `/accounts/[id]` | Updates an existing Account |
| PUT    | `/ducks/[id]` | Updates an existing duck |
| DELETE | `/accounts/[id]` | Deletes an existing Account |
| DELETE | `/ducks/[id]` | Deletes an existing duck |

## 📁 Project Structure
```
duck_tapper/
├── duck_api/
| ├── 
├── assets/
│ ├── fonts/
│ │ └── ChelseaMarket-Regular.ttf
│ ├── images/
│ │ ├── Analytics.png
│ │ ├── Buy Upgrade.png
│ │ ├── DUCK 2.png
│ │ ├── DUCK FISH.png
│ │ ├── DUCK GROUP.png
│ │ ├── DUCK LAKE.png
│ │ ├── DUCK MELON.png
│ │ ├── DUCK PNG.png
│ │ ├── Duck.png
│ │ ├── Fish Food.png
│ │ ├── Flying Duck.png
│ │ ├── Lake.png
│ │ ├── Shopping Cart.png
│ │ └── Watermelon.png
├── lib/
│ ├── models/
│ │ ├── account.dart
│ │ └── duck.dart
│ ├── providers/
│ │ ├── account_provider.dart
│ │ └── duck_provider.dart
│ ├── repositories/
│ │ ├── account_repository.dart
│ │ └── duck_repository.dart
│ ├── screens/
│ │ ├── details_screen.dart
│ │ ├── duck_screen.dart
│ │ ├── login_screen.dart
│ │ ├── nav_screen.dart
│ │ └── upgrade_screen.dart
│ └── main.dart
│ ├── services/
│ │ ├── api_service.dart
│ │ └── duck_logic.dart
│ ├── widgets/
│ │ └── register_dialog.dart
├── screenshots/
│ ├── duck_screen.png
│ ├── dynamic_duck.png
│ ├── login_screen.png
│ ├── register_dialog.png
│ ├── upgrades_screen_more.png
│ ├── upgrades_screen.png
│ └── task_complete.png
├── test/
│ ├── api_test.dart
│ ├── models_test.dart
│ └── widget_test.dart
├── .env.development
├── .env.production
├── .env.staging
└── README.md
```

### AI USAGE ACKNOWLEDGEMENT

AI was used sparingly within the App and API. Here are the only parts where AI has been utilized:

* Duck pressing animations
* Alternative Provider usage (DuckLogic chassis, everything within DuckLogic is typewritten and trial tested)
* Alternative Provider troubleshooting 
* Register Dialog Widget
