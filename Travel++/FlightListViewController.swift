//
//  FlightListViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/22/22.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuthUI
import Alamofire
import SwiftyJSON


var flightList = [Flight](repeating: Flight(airline: "", date: "", dest: "", flightID: "", flightNo: "", origin: "", status: "", delay: ""), count: 1)

class FlightListViewController: UITableViewController {
    
    
    
    func fetchFlights(flightAirline: String, flightId: String, flightOrigin: String, result: @escaping (_ flight: Flight?) -> Void) {
        var newFlight = Flight(airline: "", date: "", dest: "", flightID: "",
                              flightNo: "", origin: "", status: "", delay: "")
        var urlStr = "https://aeroapi.flightaware.com/aeroapi/flights/search/advanced?query=%7Bident+%7B" + flightAirline + flightId + "%7D%7D+%7Borig_or_dest+%7BK" + flightOrigin + "%7D%7D"
        let headers : HTTPHeaders = ["Accept":"application/json; charset=UTF-8",
                                         "x-apikey":"HjhlXTf3o0G0V9tOnA5hU385xU0BKGb5"]
        
        AF.request(urlStr, parameters: [:], headers: headers).responseJSON { response in
            if response.data != nil {
                do {
                    let json = try JSON(data: response.data!)
                    newFlight.flightID = json["flights"][0]["fa_flight_id"];
                    print(newFlight.flightID)
                    
                    // Second API call must be within the first's block to remain async
                    // Don't ask idk how to explain it very well, just put things that
                    // Need to happen in a certain order within the async block
                    urlStr = "https://aeroapi.flightaware.com/aeroapi/flights/" + newFlight.flightID.stringValue
                    AF.request(urlStr, parameters: [:], headers: headers).responseJSON { response in
                        if response.data != nil {
                            do {
                                let json = try JSON(data: response.data!)
                                print(json["flights"][0]["departure_delay"])
                                print(json["flights"][0]["arrival_delay"])
                                newFlight.dest = String(json["flights"][0]["destination"]["code"].stringValue.dropFirst(1))
                                newFlight.origin = String(json["flights"][0]["origin"]["code"].stringValue.dropFirst(1))
                                newFlight.flightNo = flightAirline+flightId
                                newFlight.airline = flightAirline
                                newFlight.date = json["flights"][0]["scheduled_out"].stringValue.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
                                newFlight.status = json["flights"][0]["status"].stringValue
                                newFlight.delay = json["flights"][0]["arrival_delay"].stringValue
                                result(newFlight)
                                
                                guard let key = ref.child("users/\(Auth.auth().currentUser!.uid)/flights").childByAutoId().key else { return }
                                let tempRef = ref.child("users/\(Auth.auth().currentUser!.uid)/flights/\(key)")
                                tempRef.updateChildValues(["airline": newFlight.airline as Any])
                                tempRef.updateChildValues(["flightNo": newFlight.flightNo as Any])
                                tempRef.updateChildValues(["flightID": newFlight.flightID.stringValue as Any])
                                tempRef.updateChildValues(["delay": newFlight.delay as Any])
                                tempRef.updateChildValues(["origin": newFlight.origin as Any])
                                tempRef.updateChildValues(["dest": newFlight.dest as Any])
                                tempRef.updateChildValues(["date": newFlight.date as Any])
                                tempRef.updateChildValues(["status": newFlight.status as Any])
                            } catch _ as NSError {
                                result(nil)
                            }
                        }
                    }
                } catch _ as NSError {
                    result(nil)
                }
            }
        }
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }

    @IBAction func done(segue:UIStoryboardSegue) {
        let flightAddVC = segue.source as! FlightAddViewController
        fetchFlights(flightAirline: flightAddVC.flightAirlineString, flightId: flightAddVC.flightIdString, flightOrigin: flightAddVC.flightOriginString){(f: Flight?) -> Void in
            flightList.append(f!)
            
            
            self.tableView.reloadData()
        }
    }
    
    // When refreshed, need to re-call api for all flights to
    // ensure updated data « could take a bit of time to complete
    @objc func refresher(sender:AnyObject)
    {
        // Updating your data here...
        
        print("REFRESHING DATA")
        // Temp reloading simulation for now because it aint in this sprint
        //sleep(5)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    let nameRef = ref.child("users/\(Auth.auth().currentUser!.uid)/flights")
    
    override func viewDidLoad() {
        // Here we replace the default values
        self.refreshControl?.addTarget(self, action: #selector(refresher), for: UIControl.Event.valueChanged)
        getData()
    }
    
    func getData() {
        let group = DispatchGroup()
        nameRef.observe(.value, with: { snapshot in
            var count = 0
            for child in snapshot.children {
                group.enter()
                let snap = child as! DataSnapshot
                let flightDict = snap.value as! [String: Any]
                print(flightDict)
                
                var airlineVar = ""
                if let airlineDB = flightDict["airline"] {
                    airlineVar = airlineDB as! String
                }
                var dateVar = ""
                if let dateDB = flightDict["date"] {
                    dateVar = dateDB as! String
                }
                var destVar = ""
                if let destDB = flightDict["dest"] {
                    destVar = destDB as! String
                }
                var flightidVar = ""
                if let flightidDB = flightDict["flightID"] {
                    flightidVar = flightidDB as! String
                }
                var flightnoVar = ""
                if let flightnoDB = flightDict["flightNo"] {
                    flightnoVar = flightnoDB as! String
                }
                var orgVar = ""
                if let orgDB = flightDict["origin"] {
                    orgVar = orgDB as! String
                }
                var statusVar = ""
                if let statusDB = flightDict["status"] {
                    statusVar = statusDB as! String
                }
                var delayVar = ""
                if let delayDB = flightDict["delay"] {
                    delayVar = delayDB as! String
                }
                while (count >= flightList.count) {
                    flightList.append(Flight(airline: "", date: "", dest: "", flightID: "", flightNo: "", origin: "", status: "", delay: ""))
                }
                flightList[count] = Flight(airline: airlineVar, date: dateVar, dest: destVar, flightID: JSON(rawValue: flightidVar) ?? "", flightNo: flightnoVar, origin: orgVar, status: statusVar, delay: delayVar)
                
                print(flightList[count])
                count+=1
                self.tableView.reloadData()
                group.leave()
            }
            
        }, withCancel: nil)
        
        
        
        group.notify(queue: .main, execute: {
            print("Going to Refresh")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
        tableView.reloadData()
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
        cell.status.text = flights.status
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


