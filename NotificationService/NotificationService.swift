//
//  NotificationService.swift
//  NotificationService
//
//  Created by Mateus Rodrigues on 23/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        //        self.contentHandler = contentHandler
        //        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        //
        //        if let bestAttemptContent = bestAttemptContent {
        //            // Modify the notification content here...
        //            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
        //
        //            contentHandler(bestAttemptContent)
        //        }
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        print(request.content.description)
        
        // Get the custom data from the notification payload
        if let notificationData = request.content.userInfo["data"] as? [String: String] {
            // Grab the attachment
            if let urlString = notificationData["attachment-url"], let fileUrl = URL(string: urlString) {
                // Download the attachment
                URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                    if let location = location {
                        // Move temporary file to remove .tmp extension
                        let tmpDirectory = NSTemporaryDirectory()
                        let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                        let tmpUrl = URL(string: tmpFile)!
                        
                        if !FileManager.default.fileExists(atPath: tmpUrl.path) {
                            try! FileManager.default.moveItem(at: location, to: tmpUrl)
                        }
                        
                        print(tmpUrl)
                        
                        // Add the attachment to the notification content
                        if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                            self.bestAttemptContent?.attachments = [attachment]
                        }
                    }
                    // Serve the notification content
                    self.contentHandler!(self.bestAttemptContent!)
                    }.resume()
            }
        } else {
            print("FAILED")
            self.contentHandler!(self.bestAttemptContent!)
        }
        
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("will expire")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
