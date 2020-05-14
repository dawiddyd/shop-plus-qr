//
//  ExtensionDelegate.swift
//  Shop Plus QR WatchKit Extension
//
//  Created by Dawid Dydliński on 13/05/2020.
//  Copyright © 2020 Dawid Dydliński. All rights reserved.
//

import WatchKit
import WatchConnectivity
import SwiftUI

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    @ObservedObject var userData: UserDataModel = UserDataModel.Instance;

    func applicationDidFinishLaunching() {
        WKExtension.shared().isAutorotating = true
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func applicationDidBecomeActive() {
       DispatchQueue.main.async {
            guard WCSession.default.isReachable else { return }
            WCSession.default.sendMessage(
                ["requestForActualUserId": String(self.userData.id)],
                replyHandler: { reply in print(reply["id"]!) },
                errorHandler: { e in print("Error sending the message: \(e.localizedDescription)")
            })
        }
    }
    
    func updateUserId(id: String) {
           self.userData.id = id
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Active session")
    }
    
    public func session(_: WCSession,
                            didReceiveMessage message: [String: Any],
                            replyHandler: @escaping ([String: Any]) -> Void) {
        
         DispatchQueue.main.async {
    
            guard let m = message as? [String: String] else { return }
        
            replyHandler([
                "response": "properly formed message!",
                "originalMessage": m,
            ])
       
            if m["id"] != self.userData.id {
                print("changing id to \(m["id"]!) in user defaults")
                self.userData.id = m["id"]!
            }
        }
    }
}
