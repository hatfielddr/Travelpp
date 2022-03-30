//
//  FlightListViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/22/22.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import Alamofire
import SwiftyJSON


var flightList = [Flight](repeating: Flight(airline: "", date: "", dest: "", flightID: "", flightNo: "", origin: ""), count: 1)

class FlightListViewController: UITableViewController {
    
    var newFlight = Flight(airline: "", date: "", dest: "", flightID: "",
                          flightNo: "", origin: "")
    
    @IBAction func fetchFlights() {
        let urlStr = "https://aeroapi.flightaware.com/aeroapi/flights/UAL4-1648098922-fa-0000"
        let headers : HTTPHeaders = ["Accept":"application/json; charset=UTF-8",
                                         "x-apikey":"HjhlXTf3o0G0V9tOnA5hU385xU0BKGb5"]
        AF.request(urlStr, parameters: [:], headers: headers).responseJSON { response in
            if response.data != nil {
                do {
                    let json = try JSON(data: response.data!)
                    //print(json)
                    print(json["flights"][0]["destination"]["code"])
                } catch let error as NSError {
                    
                }
            }
        }
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }

    @IBAction func done(segue:UIStoryboardSegue) {
        let flightDetailVC = segue.source as! FlightAddViewController
        newFlight.origin = flightDetailVC.originAddString
        newFlight.dest = flightDetailVC.destAddString
        newFlight.date = flightDetailVC.dateAddString
           
        flightList.append(newFlight)
        tableView.reloadData()
    }
    
    let nameRef = ref.child("flights").child("00001")
    
    override func viewDidLoad() {
        // Here we replace the default values
        getData()
    }
    
    func getData() {
        let group = DispatchGroup()
        
        group.enter()
        nameRef.observe(.value, with: { snapshot in
            
            if let flightInfoArray = snapshot.value as? [String : String] {
                var airlineVar = ""
                if let airlineDB = flightInfoArray["airline"] {
                    airlineVar = airlineDB
                }
                var dateVar = ""
                if let dateDB = flightInfoArray["date"] {
                    dateVar = dateDB
                }
                var destVar = ""
                if let destDB = flightInfoArray["destination_id"] {
                    destVar = destDB
                }
                var flightidVar = ""
                if let flightidDB = flightInfoArray["flight_id"] {
                    flightidVar = flightidDB
                }
                var flightnoVar = ""
                if let flightnoDB = flightInfoArray["number"] {
                    flightnoVar = flightnoDB
                }
                var orgVar = ""
                if let orgDB = flightInfoArray["origin_id"] {
                    orgVar = orgDB
                }
                var count = 0
                flightList[count] = Flight(airline: airlineVar, date: dateVar, dest: destVar, flightID: flightidVar, flightNo: flightnoVar, origin: orgVar)
                
                print(flightList[count])
                group.leave()

            } else {
                print("empty")
            }
        
        }, withCancel: nil)
        
        
        
        group.notify(queue: .main, execute: {
            print("Going to Refresh")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
}

extension FlightListViewController {
    
    static let flightListCellIdentifier = "FlightListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.flightListCellIdentifier,
                                        for: indexPath) as? FlightListCell else {
            fatalError("Unable to dequeue FlightCell")
        }
        let flights = flightList[indexPath.row]
        cell.flightID.text = flights.flightNo
        cell.depart.text = flights.origin
        cell.arrive.text = flights.dest
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlightDetailSegue" {
            let detailViewController = segue.destination as! FlightDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            detailViewController.flight = flightList[row]
        }
    }
    
}


