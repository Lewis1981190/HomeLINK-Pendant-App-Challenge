# Lewis Kosztan - HomeLINK Pendant App Challenge

A Flutter App demonstating a Proof of Concept app for HomeLINK.

Created on Flutter v3.32.7. Running Java 17. Built and tested on a Google Pixel 6 Pro running Android 16. 

## Video Demonstration
A video demonstration of me talking through the app and how it runs (Including information about Firebase backend services) can be found here:
- ...Video Link Pending...

## APK Download
The latest build of the app can be downloaded from here:
- https://drive.google.com/file/d/1BqaJrlmZ11TRx-z2anC5MIKoDwpLi6UH/view?usp=sharing

## Installing & Running
### 1. Prerequisites
Make sure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install). This app was developed using Flutter v3.32.7, which I recommend.
- Java for running on Android. This app was developed using Java 17, highly recommended if you're building from source. 
- [Git](https://git-scm.com/)
- A code editor like [VS Code](https://code.visualstudio.com/)

I use version managers to easily switch between Java and Flutter versions. I highly recommend the following:
- [jenv](https://github.com/jenv/jenv) for Java. 
- [fvm](https://fvm.app) for Flutter. 

### 2. Clone the repo
```
git clone https://github.com/Lewis1981190/HomeLINK-Pendant-App-Challenge.git
```

### 3. Install Dependencies
```
flutter pub get
```

### 4. Run the App
To launch the app on an emulator or a connected device:
```
flutter run
```

### 5. Release Build
For Android:
```
flutter build apk --release
```

## How the App Works
### Summary
This app serves as a basic proof-of-concept showing my adherance to the defined user stories, Figma designs and the clickable prototype video.

### Features
- All buttons in the application will either work, or provide a placeholder with a short description of the expected functionality upon implementation.
- **Firebase integration!** The alerts are currently shared and stored in a Firestore (NoSQL) database; interacting with the alerts means you are interacting with real data. The username is also using Firebase data, but the target user ID is currently hardcoded due to no login functionality.
- **Realtime Database Updates:** The alert cards and the username in the top bar uses a StreamBuilder connected via Firestore. If your name is changed in the database, or if another user dismisses or adds an alert, you'll see it in real-time.
- **Multiple Alert Support:** Alerts will stack vertically in a scrollable view, can be addressed and dismissed in any order.

### Caveats
- Target user ID is hardcoded due to no current login functionality.
- The update video needs a transparent background. I've done a workaround by cropping it to a circle, *but* the video itself needs to be cropped to the edges for it to look right.
- Resident picture is hardcoded; this is not pulled from Firebase.
- Clicking the button to add a new alert picks randomly from a hardcoded pool of 3.
- Alerts are deleted on the backend when resolved, rather than copied & moved to a "Resolved / Actioned" collection (For viewing in the summary screen).

### What I Would Do If Given More Time
- Redo the routing system to use the AutoRoute library.
- Implement the login, use BLoC and Hive to abstract the business logic and manage user state and data consistently between screens, cut down on repeat database / API calls.
- Polish the animations. Most of the animations work well, a few are a little jumpy.
- Fix the black circle around the resolved video animation.
- Break up the big alert card widget into helper files, child widgets.
- If developing a real end-to-end application, I'd have the backend services and database modelled before implementing it on the frontend.

### Libraries I would Recommend for Scaling Up & Out
- BLoC & Hive - Great for separating business logic and managing state
- AutoRoute - Standardises and simplifies the routing, lowered the chances of devlopers running into edge-case router issues.
