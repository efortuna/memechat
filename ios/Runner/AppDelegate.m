#include "AppDelegate.h"
#include "FirebaseDatabasePlugin.h"
#include "GoogleSignInPlugin.h"

@implementation AppDelegate {
  FirebaseDatabasePlugin *_firebaseDatabasePlugin;
  GoogleSignInPlugin *_googleSignInPlugin;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterController = (FlutterViewController*)self.window.rootViewController;
    _firebaseDatabasePlugin = [[FirebaseDatabasePlugin alloc] initWithFlutterView:flutterController];
    _googleSignInPlugin = [[GoogleSignInPlugin alloc] initWithFlutterView:flutterController];
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
