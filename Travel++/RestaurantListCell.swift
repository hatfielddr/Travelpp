//
//  RestaurantListCell.swift
//  Travel++
//
//  Created by csuser on 2/22/22.
//

import UIKit

class RestaurantListCell: UITableViewCell {
    typealias FaveButtonAction = () -> Void

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var faveButton: UIButton!

    var faveButtonAction: FaveButtonAction?
    
    @IBAction func faveButtonTriggered(_ sender: UIButton) {
        faveButtonAction?()
    }
}

