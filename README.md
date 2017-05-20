# MemeChat
An example of a meme-enabled chat app on Flutter, using Firebase, Google Sign In, and device camera integration. 

MemeChat contains platform-specific elements for Android and iOS.

# Usage
1. Follow the installation instructions on www.flutter.io to install Flutter.
2. You'll need to create a Firebase instance. Follow the instructions at https://console.firebase.google.com.
3. Once your Firebase instance is created, you'll need to enable anonymous authentication.
  - Go to the Firebase Console for your new instance.
  - Click "Authentication" in the left-hand menu
  - Click the "sign-in method" tab
  - Click "anonymous" and enable it
4. (skip if not running on Android) 
- Create an app within your Firebase instance for Android, with package name com.yourcompany.memechat 
- Follow instructions to download google-services.json, and place it into memechat/android/app/
- Run the following command to get your SHA-1 key:
```
keytool -exportcert -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
```
- In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".
4. (skip if not running on iOS) 
- Create an app within your Firebase instance for iOS, with package name com.yourcompany.memechat
- Follow instructions to download GoogleService-Info.plist, and place it into memechat/ios/Runner
- Open memechat/ios/Runner/Info.plist. Locate the CFBundleURLSchemes key. The second item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from GoogleService-Info.plist
5. MemeChat can be run like any other Flutter app, either through the IntelliJ UI or through running the following command from within the MemeChat directory:

```
flutter run
```
