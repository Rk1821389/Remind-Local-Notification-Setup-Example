# Remind-Local-Notification-Setup-Example
In this App I have implemted Local Push Notification and show to add action and handle actions

#Features
Many ways to sent push notification
notificiation reminder to repeat on a daily, weekly, or monthly basis
Customize the notification message and sound
Add actions to your notifications, such as "Snooze" or "Mark as Complete"

#Local Notifications with Action Handling
Remind uses local notifications. These notifications can include custom actions that allow you to snooze or mark the reminder as complete.

To handle these actions, we have implemented the UNUserNotificationCenterDelegate and overridden the userNotificationCenter(_:didReceive:withCompletionHandler:) method. In this method, we check the action identifier and perform the appropriate action.
