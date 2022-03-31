//
//  DirectionsViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 3/30/22.
//

import UIKit

class DirectionsViewController: UIViewController {
    
    /*struct TextValue: Codable {
        let text: String
        let value: Int
    }
    
    struct LatLng: Codable {
        let lat : Float
        let lng : Float
    }
    
    struct Steps: Codable {
        let distance: TextValue
        let duration: TextValue
        let end_location: LatLng
        let html_instructions: String
    }
    
    struct Legs: Codable {
        let steps: Steps
    }
    
    struct Routes: Codable {
        let legs: Legs
    }
    
    struct Directions: Codable {
        var status: String
        var routes: Routes
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apikey = "AIzaSyA7og50VFTk6EC9H-cq09vQk5xGA2znJJc"
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=" + apikey)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let json = data else { return }
            print(String(data: json, encoding: .utf8)!)
            
            let directions = try? JSONSerialization.jsonObject(with: json, options: [])
            
            
            /*let decoder = JSONDecoder()
            let directions = try! decoder.decode(Directions.self, from: json)*/
            
            //print("STATUS: " + directions.status)
            //print("ROUTE: ")
            
            /*for step in directions.routes.legs.steps.length {
                print(directions.routes.steps.html_instructions)
            }*/
        }
        task.resume()
    }
}
