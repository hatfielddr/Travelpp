//
//  Flight.swift
//  Travel++
//
//  Created by Tori Duguid on 3/22/22.
//

import Foundation
import SwiftyJSON

struct Flight {
    
    //flight information struct, can add or remove variables based on whats stored in Firebase
    var airline: String
    var date: String
    var dest: String
    var flightID: JSON
    var flightNo: String
    var origin: String
    var status: String
    var delay: String
    
}
