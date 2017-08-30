//
//  Message.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/22/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var sender: String?
    var text: String?
    var timeStamp: AnyObject?
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var videoUrl: String?
    
    
    init(dictionary: [String:AnyObject]) {
        super.init()
        
        sender = dictionary["sender"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as AnyObject
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        videoUrl = dictionary["videoUrl"] as? String
        
    }
    
    
}

