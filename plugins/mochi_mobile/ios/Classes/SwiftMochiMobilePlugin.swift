import Flutter
import UIKit
import Mobileapi

public class SwiftMochiMobilePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mochi_mobile", binaryMessenger: registrar.messenger())
        let instance = SwiftMochiMobilePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startDaemon":
            result(MobileapiStartDaemon())
        case "createNewIdentityString":
            result(MobileapiCreateNewIdentityString())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
