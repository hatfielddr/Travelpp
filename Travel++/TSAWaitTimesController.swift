//
//  TSAWaitTimesController.swift
//  Travel++
//
//  Created by Emily Blanchard on 3/17/22.
//

import UIKit
import Charts
import TinyConstraints
import GooglePlaces

//global variables
var searchController: UISearchController?

class TSAWaitTimesController: UIViewController, ChartViewDelegate, UISearchControllerDelegate, GMSAutocompleteResultsViewControllerDelegate  {
    
    //IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!
    @IBOutlet weak var currentWaitTime: UILabel!
    
    //local variables
    var resultsViewController: GMSAutocompleteResultsViewController?
    var resultView: UITextView?
    
    //create structures to store TSA wait time data
    struct Contents: Codable {
        let day: String
        let hour: String
        let max_standard_wait: String
        let updated: String
    }
    
    struct Times: Codable {
        let data: [Contents]
    }
    
    //initialize TSA wait time chart data
    var values: [ChartDataEntry] = []

    //create chart
    lazy var lineChartView: LineChartView = {
        //make chart
        let chartView = LineChartView()
        chartView.backgroundColor = .systemTeal
        
        //remove rightAxis label
        chartView.rightAxis.enabled = false
        
        //modify yAxis label
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        //create xAxis label
        let times = ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm"]
        
        //modify xAxis label
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: times)
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .systemTeal
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get and set date on wait times page
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"

        dateLabel.text = dateFormatter.string(from: date)
        airportLabel.text = "IND"
        currentWaitTime.text = "-"
        
        //make chart background
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        //set up search
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController as! UISearchResultsUpdating

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        //get initial json data
        pullWaitTimes(name: "IND")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    //add wait time data to chart
    func setData() {
        print("IN SET DATA")
        
        let set1 = LineChartDataSet(entries: values, label: "TSA Wait Times")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    func pullWaitTimes(name: String) {
        print("IN PULL WAIT TIMES")
        
        //set up page labels
        let index = Calendar.current.component(.weekday, from: Date()) // this returns an Int
        let day = Calendar.current.weekdaySymbols[index - 1] // subtract 1 since the index starts at 1
        let airportCode = name
        airportLabel.text = airportCode
        
        //get time formatted in military time
        let components = Calendar.current.dateComponents([.hour], from: Date())
        let hour = components.hour ?? 0
        //print(hour)
        
        //set up query string
        let urlstring = "https://www.tsa.gov/api/checkpoint_waittime/v1/" + airportCode + "/" + day + ".json"
        let url = URL(string: urlstring)!
        
        //pull wait times
        let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in
            guard let json = data else { return }
            print(String(data: json, encoding: .utf8)!)

            let decoder = JSONDecoder()
            let times = try! decoder.decode(Times.self, from: json)
            
            //empty data
            values = []

            //add data to set entry array
            for i in 0...23 {
                let xval = Double(times.data[i].hour)
                let yval = Double(times.data[i].max_standard_wait)
                values.append(ChartDataEntry(x: xval!, y: yval!))
                
                //set currentWaitTime label to corresponding wait time
                if (yval! == Double(hour)) {
                    DispatchQueue.main.async {
                        print("HERE")
                        print(String(Int(yval!)))
                        self.currentWaitTime.text = String(Int(yval!))
                    }
                }
            }
            //add returned data to chart
            setData()
        }
        task.resume()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        pullWaitTimes(name: place.name!)
        place.types
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
}
