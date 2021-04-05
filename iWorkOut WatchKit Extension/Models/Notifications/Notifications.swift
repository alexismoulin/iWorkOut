import Foundation
import UserNotifications

func requestPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Rest time is over"
    content.subtitle = "Be ready for the next set"
    content.sound = UNNotificationSound.default

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request)
}
