//
//  AppDelegate.swift
//  ADLoadingViewSample
//
//  Created by Edouard Siegel on 03/03/16.
//
//

import ADDynamicLogLevel
import CocoaLumberjack
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupLogger()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = LoadingViewPageViewController()
        window?.makeKeyAndVisible()
        return true
    }

    private func setupLogger() {
        ADDynamicLogLevel.setLogLevel(ADTargetSettings.shared().logLevel)
        DDLog.add(DDTTYLogger.sharedInstance())
        DDTTYLogger.sharedInstance().colorsEnabled = true
        DDLog.add(DDASLLogger.sharedInstance())
    }
}
