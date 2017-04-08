#include "AppDelegate.h"
#include "FirebaseDatabasePlugin.h"

@implementation AppDelegate {
  FirebaseDatabasePlugin *_firebaseDatabasePlugin;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* flutterController = (FlutterViewController*)self.window.rootViewController;
    _firebaseDatabasePlugin = [[FirebaseDatabasePlugin alloc] initWithFlutterView:flutterController];
    return YES;
}

@end
