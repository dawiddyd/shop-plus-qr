//
//  AppDelegate.swift
//  Shop Plus QR
//
//  Created by Dawid Dydliński on 13/05/2020.
//  Copyright © 2020 Dawid Dydliński. All rights reserved.
//

import UIKit
import WatchConnectivity
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    @ObservedObject var userData: UserDataModel = UserDataModel.Instance
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }
      
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
      
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
      
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange")
    }
    
    public func session(_: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        DispatchQueue.main.async {
            
            guard let m = message as? [String: String] else { return }
            
            if (m["requestForActualUserId"] != nil) {
                guard WCSession.default.isReachable else { return }
                print("Recivied message from watch with id \(m["requestForActualUserId"]!). Sending current id")

                WCSession.default.sendMessage(
                    ["id": String(self.userData.id)],
                    replyHandler: { reply in print(reply) },
                    errorHandler: { e in print("Error sending the message: \(e.localizedDescription)") })
            }
        }
    }
}

