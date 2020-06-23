import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller: FlutterViewController = window.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.io/battery",
                                              binaryMessenger: controller as! FlutterBinaryMessenger)
    batteryChannel.setMethodCallHandler { (call, result) in
        // Handle battery messages.
        if "getBatteryLevel" == call.method {
            self.receiveBatteryLevel(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        switch device.batteryState {
        case .unknown:
            result(FlutterError(code: "UNAVAILABLE", message: "电池信息不可用", details: nil))
        default:
            result(Int(device.batteryLevel * 100))
        }
    }
    
}
