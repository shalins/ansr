//
//  AppDelegate.swift
//  IrisLabs4
//
//  Created by Shalin on 10/28/20.
//

import UIKit
import Firebase
import Mixpanel


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.configureAPIs()
        self.authorizationLogic()

        Mixpanel.mainInstance().track(event: "App Opened")

        return true
    }

    func configureAPIs() {
        FirebaseApp.configure()
//        try! Auth.auth().signOut()
        Mixpanel.initialize(token: "7ce37a52646cd422ad126e98041c0857")
    }
    
    func grabStoryboard() -> UIStoryboard {
        // determine screen size
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidht = UIScreen.main.bounds.size.width
        var storyboard: UIStoryboard! = nil
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            if ( screenHeight == 812 && screenWidht == 375) {
                // iphone xs
                storyboard = UIStoryboard.init(name: "MainXS", bundle: nil)
            } else if (screenHeight == 896 && screenWidht == 414) {
                // iphone x max
                storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            } else if (screenHeight == 736 && screenWidht == 414) {
                // iphone 7+ and 8+
                storyboard = UIStoryboard.init(name: "MainPlus", bundle: nil)
            } else {
                // iphone 7 and 8
                storyboard = UIStoryboard.init(name: "Main8", bundle: nil)
            }
        }

        return storyboard
    }

    func startWithSignUp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = self.grabStoryboard()
        let start: FirstScreenViewController? = storyboard.instantiateViewController()
        self.window?.rootViewController = start
        self.window?.makeKeyAndVisible()
    }
        
    func startWithClasses() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = self.grabStoryboard()
        let start: ClassesMultiSelectViewController? = storyboard.instantiateViewController()
        self.window?.rootViewController = start
        self.window?.makeKeyAndVisible()
    }
    
    func startWithHome() {
        print("starting")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = self.grabStoryboard()
        let start: FeedViewController? = storyboard.instantiateViewController()
        self.window?.rootViewController = start
        self.window?.makeKeyAndVisible()
    }
    
    func authorizationLogic() {
        if let _ = Auth.auth().currentUser {
            Mixpanel.mainInstance().identify(distinctId: Mixpanel.mainInstance().distinctId)
            if UserDefaults.standard.bool(forKey: "onboardingComplete") {
                self.startWithHome()
            } else {
                self.startWithClasses()
            }
        } else {
            self.startWithSignUp()
        }
    }
}

