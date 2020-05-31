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
        case "importNewIdentityString":
            if let args = call.arguments as? [String] {
                if args.count == 1 {
                    var error : NSError?
                    // result(MobileapiImportNewIdentityString(args[0], &error))
                    let res = MobileapiImportNewIdentityString(args[0], &error)
                    if let errorMessage = error?.userInfo.description {
                        result(
                            FlutterError.init(
                                code: "NATIVE_ERR",
                                message: "Error: " + errorMessage,
                                details: nil
                            )
                        )
                    } else {
                        result(res)
                    }
                } else {
                    result(
                        FlutterError.init(
                            code: "BAD_ARGS", 
                            message: "Wrong arg count: " + args.count.description,
                            details: nil
                        )
                    )
                }
            } else {
                result(
                    FlutterError.init(
                        code: "BAD_ARGS",
                        message: "Wrong argument types",
                        details: nil
                    )
                )
            }
        case "signAuthorizationRequestString":
            if let args = call.arguments as? [String] {
                if args.count == 2 {
                    var error : NSError?
                    let res = MobileapiSignAuthorizationRequestString(args[0], args[1], &error)
                    if let errorMessage = error?.userInfo.description {
                        result(
                            FlutterError.init(
                                code: "NATIVE_ERR",
                                message: "Error: " + errorMessage,
                                details: nil
                            )
                        )
                    } else {
                        result(res)
                    }
                } else {
                    result(
                        FlutterError.init(
                            code: "BAD_ARGS", 
                            message: "Wrong arg count: " + args.count.description,
                            details: nil
                        )
                    )
                }
            } else {
                result(
                    FlutterError.init(
                        code: "BAD_ARGS",
                        message: "Wrong argument types",
                        details: nil
                    )
                )
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
