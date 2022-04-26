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

class TSAWaitTimesController: UIViewController, ChartViewDelegate, UISearchBarDelegate {
    
    //IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!
    @IBOutlet weak var currentWaitTime: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    //initialize TSA wait time chart data
    var values: [ChartDataEntry] = []
    
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
    
    //setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get and set date on wait times page
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        errorLabel.isHidden = true
        
        //make chart background
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        //set up searchController
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.searchBar.placeholder = "Enter IATA code here..."
        
        //get initial json data
        pullWaitTimes(name: "IND")
    }
    
    //respond when an iata code is searched
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        pullWaitTimes(name: searchBar.text!)
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
    
    //pull wait times from TSA given the IATA code
    func pullWaitTimes(name: String) {
        print("IN PULL WAIT TIMES")
        
        //set up page labels
        let index = Calendar.current.component(.weekday, from: Date()) // this returns an Int
        let day = Calendar.current.weekdaySymbols[index - 1] // subtract 1 since the index starts at 1
        let airportCode = name
        
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
            
            //error handling
            if (times.data.isEmpty) {
                //show error label
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                }
                print("Incorrect IATA Code: Airport does not exist")
                return
            }
            
            //reset data to be plotted
            values = []

            //add data to set entry array
            for i in 0...23 {
                let xval = Double(times.data[i].hour)
                let yval = Double(times.data[i].max_standard_wait)
                values.append(ChartDataEntry(x: xval!, y: yval!))
                
                //set currentWaitTime label to corresponding wait time
                if (xval! == Double(hour)) {
                    DispatchQueue.main.async {
                        print("HERE")
                        print(String(Int(yval!)))
                        self.airportLabel.text = airportCode
                        self.errorLabel.isHidden = true
                        self.currentWaitTime.text = String(Int(yval!))
                    }
                }
            }
            //add returned data to chart
            setData()
        }
        task.resume()
    }
}
