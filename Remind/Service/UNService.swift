//
//  UNService.swift
//  Remind
//
//  Created by Manoj kumar on 10/01/23.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    // after creating private init then you cannot ever make UN Service object. you can only reference the shared object and from the share you can call the functios or access the variables
    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    //Step 1 we want to show request permsion to sent alerts to user
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        //we have to access user notification center
        unCenter.requestAuthorization(options: options) { granted, error in
            if let error {
                print(error.localizedDescription)
            }
            
            guard granted else {
                print("User Denied Access")
                return
            }
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
    
}

//MARK: UNUserNotificationCenterDelegate

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
}
