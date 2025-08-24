# 🚗 Car Route App (Flutter + Google Maps)

An interactive **car route planning application** built with **Flutter**.  
Users can tap on the map to select **origin** and **destination** points, and the app will immediately render the **optimal driving route** between them using the **Google Directions API**.

---

## ✨ Features
- 🗺 **Interactive Google Map** with zoom, pan, and tap support
- 📍 **Tap to Mark Points** → Origin and Destination
- 🚦 **Real-time Route Calculation** with distance & ETA
- 🔄 Swap origin/destination & clear markers easily
- 🔄 Swap Traffic to mode easily
- ⚡ Powered by **GetX** for state management

---

---

## 🛠 Tech Stack
- [Flutter](https://flutter.dev/)
- [GetX](https://pub.dev/packages/get) (^4.7.2) – state management
- [Dio](https://pub.dev/packages/dio) (^5.9.0) – networking
- [Shimmer](https://pub.dev/packages/shimmer) (^3.0.0) – loading placeholders
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) (^2.12.3) – Google Maps SDK
- [Geocoding](https://pub.dev/packages/geocoding) (^4.0.0) – reverse & forward geocoding
- [flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points) (^3.0.1) – drawing routes on maps
- [Geolocator](https://pub.dev/packages/geolocator) (^14.0.2) – device location services

---

## 📂 Project Structure
lib/
└── app/
├── core/
│   ├── apis/                     # API related logic (network calls, API configs)
│   ├── commons/                  # Common helpers, constants, utilities
│   ├── models/                   # Data models
│   └── middlewares/
│
├── modules/
│   └── map/                      # Map-related module (controllers, views, bindings)
│       └── _export.dart          # Barrel export file for map module
│
├── routes/                       # App routes (GetX routing definitions)
├── translations/                 # Multi-language translations
│
├── ui/
│   ├── layouts/                  # Common page/screen layouts
│   ├── theme/                    # Theme, colors, text styles
│   └── widgets/                  # Reusable UI components
│
└── utils/                        # General utility functions
main.dart                         # Application entry point


# 🛠 Installation Guide

Follow these steps to set up and run the project on your local machine.

---

## 1️⃣ Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable)
- Android Studio / VS Code
- Android Emulator or a physical device
- A valid **Google Maps API Key**

---

## 2️⃣ Clone the Repository
bash
git clone https://github.com/your-username/car-route-app.git
cd car-route-app
flutter pub get

## 4️⃣ Configure API Key

This project uses the Google Maps API Key in two places:

AppConstant (for programmatic access)

AndroidManifest.xml (for native Google Maps SDK usage)

Step 1: Add key in AppConstant

Edit lib/app/core/commons/app_constant.dart:

class AppConstant {
  static const String googleMapApiKey = "YOUR_API_KEY_HERE";
}

Step 2: Add key in AndroidManifest.xml

Open android/app/src/main/AndroidManifest.xml and update:

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>

## 5️⃣ Run the App

flutter run