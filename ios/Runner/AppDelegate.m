#include "AppDelegate.h"
#include "FirebaseDatabasePlugin.h"
#include "FirebaseStoragePlugin.h"
#include "GoogleSignInPlugin.h"
#include "ImagePickerPlugin.h"

@implementation AppDelegate {
  FirebaseDatabasePlugin *_firebaseDatabasePlugin;
  FirebaseStoragePlugin *_firebaseStoragePlugin;
  GoogleSignInPlugin *_googleSignInPlugin;
  ImagePickerPlugin *_imagePickerPlugin;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterController = (FlutterViewController*)self.window.rootViewController;
    _firebaseDatabasePlugin = [[FirebaseDatabasePlugin alloc] initWithFlutterView:flutterController];
    _firebaseStoragePlugin = [[FirebaseStoragePlugin alloc] initWithFlutterView:flutterController];
    _googleSignInPlugin = [[GoogleSignInPlugin alloc] initWithFlutterView:flutterController];
    _imagePickerPlugin = [[ImagePickerPlugin alloc] initWithFlutterView:flutterController];
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
  NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
  id annotation = options[UIApplicationOpenURLOptionsAnnotationKey];
  return [_googleSignInPlugin handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
}

@end
