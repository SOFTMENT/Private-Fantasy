//
//  PushNotificationSender.swift
//  private fantasy
//
//  Created by Vijay Rathore on 28/07/21.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(title: String, body: String, token : String,badge : Int) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body,"badge": badge],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAnIJIMPk:APA91bFoj4cSMiNqmKyAXnvtHFW6EaslHdaIKcC_hsX5dP5ZDd56JeSj7FIPfqdKoa7oPmwkM_5LzUub_HOt9QLpDYphianVUvX8BiUYY87AIZR6I_q-A-wCUYprMUMZn8UVn4o2NTMy", forHTTPHeaderField: "Authorization")

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
    
    func sendPushNotificationToTopic(title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        
        let paramString: [String : Any] = ["to" : "/topics/pfm",
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAnIJIMPk:APA91bFoj4cSMiNqmKyAXnvtHFW6EaslHdaIKcC_hsX5dP5ZDd56JeSj7FIPfqdKoa7oPmwkM_5LzUub_HOt9QLpDYphianVUvX8BiUYY87AIZR6I_q-A-wCUYprMUMZn8UVn4o2NTMy", forHTTPHeaderField: "Authorization")
        
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
