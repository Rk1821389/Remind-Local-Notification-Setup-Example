//
//  UNService.swift
//  Remind
//
//  Created by Manoj kumar on 10/01/23.
//

import Foundation
//Import
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    // after creating private init then you cannot ever make UN Service object. you can only reference the shared object and from the share you can call the functios or access the variables
    static let shared = UNService()
    
    
    let unCenter = UNUserNotificationCenter.current()
    
    //Step 1 we want to show request permsion to sent alerts to user
    func authorize() {
        /*
         Request notification permissions: Before scheduling a notification, we will need to request permission from the user to send them notifications. we can do this by calling the requestAuthorization method on the UNUserNotificationCenter class and passing in the notification options you'd like to request.
         */
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
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue,
                                               title: "Run timer logic",
                                               options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
                                               title: "Run date logic",
                                               options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue,
                                               title: "Run location logic",
                                               options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue,
                                                   actions: [timerAction],
                                                   intentIdentifiers: [])
        
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
                                                  actions: [dateAction],
                                                  intentIdentifiers: [])
        
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue,
                                                      actions: [locationAction],
                                                      intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
        
    }
    
    func getAttachments(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer:
            imageName = "TimeAlert"
        case .date:
            imageName = "DateAlert"
        case .location:
            imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attachemt = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachemt
        } catch {
         return nil
        }
    }
    
    func timerRequest(with interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Your timer is all done. YAY!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        if let attachment = getAttachments(for: .timer) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification",
                                            content: content,
                                            trigger: trigger)
        
        unCenter.add(request)
    }
    
    func dateRequest(with component: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date Trigger"
        content.body = "It is now the future"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        if let attachment = getAttachments(for: .date) {
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotification.date",
                                            content: content,
                                            trigger: trigger)
        unCenter.add(request)
    }
    
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "You have returned"
        content.body = "Welcome back you silly coder you!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.location.rawValue
        
        if let attachment = getAttachments(for: .location) {
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
}


/*
 UNUserNotificationCenterDelegate is a protocol in the UserNotifications framework of iOS, macOS and watchOS that you can use to handle various events related to local and remote notifications. The protocol defines several methods that are called in response to different actions by the user or the system, such as when a notification is delivered, when a user interacts with a notification, or when a notification is dismissed.
 
 By implementing the UNUserNotificationCenterDelegate protocol, you can handle these events and perform custom actions in response to them, such as updating your app's UI, tracking metrics, or running custom logic.
 */

//MARK: UNUserNotificationCenterDelegate

extension UNService: UNUserNotificationCenterDelegate {
    /*
     userNotificationCenter(_:didReceive:withCompletionHandler:) method is a delegate method of the UNUserNotificationCenterDelegate protocol, which is called when a notification is delivered to the user.
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"),
                                            object: action)
        }
        
        completionHandler()
    }
    
    /*
     UNUserNotificationCenterDelegate protocol, that is called when a local or remote notification is about to be presented to the user. It is called when the app is in the background, or in foreground and the notification is delivered while the app is inactive.
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.banner, .sound]
        completionHandler(options)
    }
}
