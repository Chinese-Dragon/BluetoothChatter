//
//  AppDelegate.swift
//  BTChatter
//
//  Created by Mark on 1/19/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// check if user is already registered
		let user = UserData.shareInstance
		user.restore()
		if (user.hasAllDataFilled) {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabbarVC") as! UITabBarController
			window?.rootViewController = viewController
		}
		
		return true
	}

}

