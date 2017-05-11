#include "AppDelegate.h"
#include "PluginRegistry.h"

@implementation AppDelegate {
  PluginRegistry *plugins;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  FlutterViewController *flutterController =
      (FlutterViewController *)self.window.rootViewController;
  plugins = [[PluginRegistry alloc] initWithController:flutterController];
  return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
  NSString *sourceApplication =
      options[UIApplicationOpenURLOptionsSourceApplicationKey];
  id annotation = options[UIApplicationOpenURLOptionsAnnotationKey];
  return [plugins.google_sign_in handleURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation];
}

@end
