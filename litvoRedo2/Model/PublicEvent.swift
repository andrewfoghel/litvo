//
//  Event.swift
//  litvoRedo2
//
//  Created by Andrew Foghel on 8/15/17.
//  Copyright © 2017 andrewfoghel. All rights reserved.
//

import UIKit

class PublicEvent: NSObject {
    var poster: String?
    var placeName: String?
    var placeAddress: String?
    var placeImageUrl: String?
    var activity: String?
    var timeStamp: AnyObject?
    var rsvp: Int?
    var eventId: String?
    var userRsvp: [String : AnyObject]?
}

