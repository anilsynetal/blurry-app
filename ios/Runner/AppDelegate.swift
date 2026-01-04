import Flutter
import UIKit
import GoogleSignIn
import flutter_local_notifications
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  // MARK: - Google Sign-In URL Handling (REQUIRED)
  override func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle Google Sign-In OAuth redirect
    return GIDSignIn.sharedInstance.handle(url)
  }
  // Optional: Support for older iOS versions (iOS 8)
  override func application(
      _ application: UIApplication,
      open url: URL,
      sourceApplication: String?,
      annotation: Any
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}
