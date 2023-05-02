//
//  Event.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import Foundation
import UIKit

struct Event: Codable  {
    var id: Int
    var name: String
    var start_time: String
    var end_time: String
    var location: String
    var access: String
    var description: String
}

struct EventResponse: Codable {
    var events: [Event]
}
