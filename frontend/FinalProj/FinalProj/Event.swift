//
//  Event.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import Foundation
import UIKit

class Event {
    var eventName: String
    var eventDate: String
    var eventDescription: String
    
    init(eventName: String, eventDate: String, eventDescription: String) {
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventDescription = eventDescription
    }
    
}
