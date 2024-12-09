# CAPSTONE-Chuah-Mobile-App

Installation: You'll need git installed to clone this repository.  Once cloned, cd into the "mobile_app" folder and run main.dart on an emulator or physical device.  Please ensure you have the correct version of Flutter installed and, if using an emulator, a version that is compatible with this app.  
Run 'flutter pub get' under mobile_app to add dependencies

Summary: This app is a help coach app geared towards college students to get them active and interested in the community while also helping to relieve stress through features such as location-based commenting with others, daily activities, journaling, profile sharing, and quests to keep users interested. The "mobile_app" folder is where our app is contained - anything outside of that is testing or legacy data. The "lib" folder inside of that contains all of the pages of our app.

Firebase: Our app uses Firebase Firestore as our database for user and location information. Create your own google-services.json using firebase and replace it under android/app, an example is provided
//https://firebase.google.com/docs/android/setup

Branching: PLEASE ensure that you have pulled from the correct branch (testing).  Our main branch contains legacy code and has not been updated to a large swath of improvements.