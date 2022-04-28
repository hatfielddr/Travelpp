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
    
    var scheduled_out: String
    var scheduled_off: String
    var scheduled_on: String
    var scheduled_in: String
    var terminal_origin: String
    var gate_origin: String
    var terminal_dest: String
    var gate_dest: String
    var baggage_claim: String
    
}
