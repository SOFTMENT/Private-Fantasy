//
//  PushNotificationSender.swift
//  private fantasy
//
//  Created by Vijay Rathore on 28/07/21.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : "/topics/kaiball",
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA2_C2ls4:APA91bEY4AtRHOn7Dmz7w7A01deLVukS_2PqNhSdJMNtc4p1F74Ic0BU6xFN6VzdtgVT1tZ0o8TGA0CqfLWS-1DJIbR4BxAUFgdmV7p-8A5Zwv-4B0JDsnpQDcOYUg74xsFUrRhLIODN", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                        
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
