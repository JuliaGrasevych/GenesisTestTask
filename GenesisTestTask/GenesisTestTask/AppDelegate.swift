//
//  AppDelegate.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let viewController = window?.rootViewController as? BreathingViewController {
            viewController.phaseProvider = AssetPhaseProvider(fileName: "Phases")
        }
        return true
    }
}

