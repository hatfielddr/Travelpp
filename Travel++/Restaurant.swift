//
//  Restaurant.swift
//  Travel++
//
//  Created by csuser on 2/22/22.
//

import Foundation

struct Restaurant {
    // Business' name
    var name: String
    // Rating
    var rating: Double
    // Delineates favorites currently - feel free to change to something else
    var isFavorite: Bool = false
    
    var url: URL
}
