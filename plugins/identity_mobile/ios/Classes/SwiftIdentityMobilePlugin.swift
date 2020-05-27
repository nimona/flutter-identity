import Flutter
import UIKit
import Mobileapi

public class SwiftIdentityMobilePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "identity_mobile", binaryMessenger: registrar.messenger())
        let instance = SwiftIdentityMobilePlugin()
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
