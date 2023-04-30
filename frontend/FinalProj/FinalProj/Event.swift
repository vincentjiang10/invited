//
//  Event.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import Foundation
import UIKit

struct Event: Codable  {
    var eventName: String
    var eventDate: String
    var eventDescription: String
    
}

struct EventResponse: Codable {
    var events: [Event]
}
