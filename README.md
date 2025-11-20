

# 📱 Flutter Social WebView App

A Flutter application that provides:

- Google Login
- Facebook Login
- Settings Screen to configure:
  - A custom website URL to load in a WebView
  - Wi-Fi scanning using `wifi_scan`
  - Bluetooth Low Energy (BLE) device scanning using `flutter_reactive_ble`
- WebView Screen that displays the configured URL

This project is a complete authentication + settings + WebView + network device discovery template.

---

## 📌 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Dependencies](#dependencies)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Platform Setup](#platform-setup)
  - [Google Sign-In](#google-sign-in)
  - [Facebook Login](#facebook-login)
- [Permissions](#permissions)
- [App Flow](#app-flow)
- [Troubleshooting](#troubleshooting)
- [Enhancements](#enhancements)

---

## 📖 Overview

This Flutter app contains three main pages:

### 1️⃣ Social Login Page

Allows logging in using:

- Google  
- Facebook *(requires Facebook app verification)*

### 2️⃣ Settings Page

Allows the user to:

- ✔ Enter & save a website URL  
- ✔ Scan and display Wi-Fi networks  
- ✔ Scan and display Bluetooth (BLE) devices  
- ✔ Save selections using `shared_preferences`

### 3️⃣ WebView Page

Loads the URL saved in the Settings page using `webview_flutter`.

---

## 🚀 Features

- ✔ Google Authentication  
- ✔ Facebook Authentication *(Facebook login will ONLY work after app review & publish)*  
- ✔ WebView with full navigation  
- ✔ Save URL using `SharedPreferences`  
- ✔ BLE scanning (printers, IoT devices)  
- ✔ Wi-Fi scanning  
- ✔ Firebase Core integrated  
- ✔ Simple and clean project structure

---

## 📦 Dependencies

```yaml
google_sign_in: ^6.2.2
flutter_facebook_auth: ^7.1.0
shared_preferences: ^2.2.3
firebase_core: ^3.4.0
webview_flutter: ^4.8.0
flutter_reactive_ble: ^5.0.0
wifi_scan: ^0.4.0
```

## 📂 Project Structure

```yaml
lib/
│
├─ main.dart
├─ screens/
│   ├─ login_screen.dart
│   ├─ settings_screen.dart
│   └─ webview_screen.dart
├─ services/
│   ├─ ble_service.dart
│   └─ storage_service.dart
```

## 🧰 Getting Started

### Clone the repository

```bash
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

---

## ⚙ Platform Setup

Authentication packages require platform configuration.

---

### 🔐 Google Sign-In

Steps:

1. Create a Firebase project
2. Add your Android app
3. Add SHA-1 & SHA-256 fingerprints
4. Download `google-services.json`
5. Add iOS config (`GoogleService-Info.plist`)

---

### 🔵 Facebook Login

Facebook login requires:

* ✔ A Facebook Developer App
* ✔ Correct key hashes
* ✔ Correct package name
* ❗ **App Verification (Important)**

⚠ **Important Note:**

> Facebook Login WILL NOT work until your Facebook app is verified and published.
> In development mode, only test users added in the Facebook developer dashboard can log in.
> This is a Facebook policy — not a code issue.

---

## 🛑 Permissions

### Android — `AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" android:usesPermissionFlags="neverForLocation" />
```

### iOS — `Info.plist`

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth to scan nearby BLE devices.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Required to scan Wi-Fi networks.</string>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 🧩 App Flow

### 🔐 Login Page

* Google Login
* Facebook Login *(needs published Facebook app)*

### ⚙ Settings Page

Contains:

* URL Input
* Wi-Fi Scanning
* BLE Device Scanning

### 🌐 WebView Page

Displays the chosen URL inside the app.

---

## 🧯 Troubleshooting

| Issue                        | Cause                      | Fix                                               |
| ---------------------------- | -------------------------- | ------------------------------------------------- |
| Facebook Login not working   | App not verified/published | ✔ Add test users ✔ Submit for Facebook App Review |
| Google login fails           | Wrong SHA-1/SHA-256        | Re-generate fingerprints                          |
| BLE scan not showing devices | Missing permissions        | Request Bluetooth + Location                      |
| Wi-Fi scan empty             | Location permission denied | Grant permission                                  |
| WebView blank                | HTTP blocked               | Enable ATS on iOS                                 |

---

## 🔮 Enhancements (Optional)

* Add ESC/POS Printer Support
* Add WebView toolbar (Back, Refresh)
* Add multi-language support
* Save BLE device name + MAC
* Add logout

