import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    weak var screen : UIView? = nil
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
//        let blankViewController = UIViewController()
//        blankViewController.view.backgroundColor = UIColorFromRGB(rgbValue: 0xF3F3FB)
//        window.rootViewController?.present(blankViewController, animated: false)
        
        screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        screen?.addSubview(blurBackground)
        blurBackground.frame = (screen?.frame)!
        window?.addSubview(screen!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            exit(0)
        }
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
//        screen?.removeFromSuperview()
    }
    
    func blurScreen(style: UIBlurEffect.Style) {
        screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        screen?.addSubview(blurBackground)
        blurBackground.frame = (screen?.frame)!
        window?.addSubview(screen!)
    }
    
    func removeBlurScreen() {
        screen?.removeFromSuperview()
    }
    
}


func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
