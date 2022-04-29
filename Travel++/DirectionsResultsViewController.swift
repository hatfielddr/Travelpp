//
//  DirectionsResultsViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 4/25/22.
//

import UIKit
import CoreLocation

protocol DirectionsResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: CLLocationCoordinate2D)
}

class DirectionsResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: DirectionsResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var places: [Place] = []

    override func viewDidLoad() {
        print("in viewDidLoad")
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with places: [Place]) {
        print("in update")
        self.tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        print("in viewDidLayoutSubviews")
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here")
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let coordinate):
                
                if (toSearch) {
                    toSelectedName = place.name
                } else {
                    fromSelectedName = place.name
                }
                    
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
