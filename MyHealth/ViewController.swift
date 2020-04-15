//
//  ViewController.swift
//  MyHealth
//
//  Created by Renat Gasanov on 23.10.2019.
//  Copyright © 2019 Renat Gasanov. All rights reserved.
//

import UIKit
import Comets
import Charts
import Alamofire
import SkyFloatingLabelTextField
import FontAwesome_swift

class ViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var Chart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var dataSelector: UISegmentedControl!
    @IBOutlet weak var selectedPointLabel: SkyFloatingLabelTextFieldWithIcon!
    
    //future update: take data from server
    var temperature : [Double] = [36.7, 37.0, 38.2, 39.3, 37.0, 36.6]
    //var temperature : [Double] = [] //delete hardcoded data
    var pulse : [Double] = [66, 80, 73, 55, 59, 90]
    var status = ["Good", "Medium", "Bad", "SOS"]
    var statusAmount = [10, 13, 4, 1]
    
    var returnThisArray : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let width = view.bounds.width
        let height = view.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white)]

        // draw line track and animate
        for comet in comets {
            view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
        
        self.Chart.delegate = self
        
        pieChart.isHidden = true
        pieChart.drawHoleEnabled = false
        pieChart.noDataText = "Ошибка получения данных"
        //updatePieChart(dataPoints: status, values: statusAmount.map{ Double($0) })
        
        Chart.rightAxis.enabled = false
        Chart.xAxis.enabled = false
        //updateLineChart(data: temperature)
        Chart.setScaleEnabled(false)
        Chart.noDataText = "Ошибка получения данных"
        Chart.leftAxis.granularity = 1.0
        
        dataSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "Sonic Silver")!], for: .selected)
        dataSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "Sonic Silver")!], for: .normal)
        
        let limitT = ChartLimitLine(limit: 37.0)
        limitT.lineColor = UIColor.init(named: "Sonic Silver")!
        Chart.leftAxis.addLimitLine(limitT)
        
        self.getTempData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print(self.returnThisArray)
            self.updateLineChart(data: self.returnThisArray.map{ Double($0) })
        }
        
        //selectedPointLabel.isHidden = true
        selectedPointLabel.iconFont = UIFont.fontAwesome(ofSize: 10, style: .solid)
        //selectedPointLabel.iconText = String.fontAwesomeIcon(name: .heartbeat)
        selectedPointLabel.placeholder = ""
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            //print(entry.y) //print this data to textedit and show recomendations
        selectedPointLabel.text = String(entry.y)
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch dataSelector.selectedSegmentIndex{
        case 0:
            selectedPointLabel.isHidden = false
            selectedPointLabel.iconText = String.fontAwesomeIcon(name: .thermometer)
            selectedPointLabel.text = ""
            Chart.isHidden = false
            pieChart.isHidden = true
            let limitT = ChartLimitLine(limit: 37.0)
            limitT.lineColor = UIColor.init(named: "Sonic Silver")!
            Chart.leftAxis.addLimitLine(limitT)
            //updateLineChart(data: temperature)
            selectedPointLabel.title = dataSelector.titleForSegment(at: dataSelector.selectedSegmentIndex)
            getTempData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print(self.returnThisArray)
                self.updateLineChart(data: self.returnThisArray.map{ Double($0) })
            }
        case 1:
            selectedPointLabel.iconText = String.fontAwesomeIcon(name: .heartbeat)
            selectedPointLabel.isHidden = false
            selectedPointLabel.text = ""
            Chart.isHidden = false
            pieChart.isHidden = true
            let limitP = ChartLimitLine(limit: 60.0)
            limitP.lineColor = UIColor.init(named: "Sonic Silver")!
            Chart.leftAxis.addLimitLine(limitP)
            updateLineChart(data: pulse)
            selectedPointLabel.title = dataSelector.titleForSegment(at: dataSelector.selectedSegmentIndex)
        case 2:
            selectedPointLabel.isHidden = true
            updatePieChart(dataPoints: status, values: statusAmount.map{ Double($0) })
            Chart.isHidden = true
            pieChart.isHidden = false
            pieChart.animate(xAxisDuration: 1, yAxisDuration: 2)
            selectedPointLabel.title = dataSelector.titleForSegment(at: dataSelector.selectedSegmentIndex)
        default:
            break
        }
    }
    
    func updateLineChart(data: [Double]){
        if (data.count != 0) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<data.count {
            let value = ChartDataEntry(x: Double(i), y: data[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let description = dataSelector.titleForSegment(at: dataSelector.selectedSegmentIndex)
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: description)
        line1.drawFilledEnabled = true
        line1.fillColor = UIColor.init(named: "Aquamarine")!
        line1.circleRadius = 6
        line1.drawValuesEnabled = false
        line1.setColor(UIColor.init(named: "Eton Blue")!)
        line1.highlightColor = UIColor.init(named: "Sonic Silver")!
        line1.setCircleColor(UIColor.init(named: "Eton Blue")!)
        line1.mode = .cubicBezier
        line1.lineWidth = 2

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        Chart.data = data
        Chart.animate(xAxisDuration: 1)
        Chart.legend.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        } else {
            Chart.clear()
        }
    }
    
    func updatePieChart(dataPoints: [String], values: [Double]) {
        if (values.count != 0){
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
    
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        pieChart.data = pieChartData
        } else {
            pieChart.clear()
        }
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    
    func getTempData(){
        returnThisArray.removeAll()
        Alamofire.request("https://fakemyapi.com/api/fake?id=b97f7e56-86f4-4dd4-b596-a15ce4b91e09", method: .post, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        /*if let status = response.response?.statusCode {
                            switch(status){
                            case 200:
                                print("example success")
                            default:
                                print("error with response status: \(status)")
                            }
                        }*/
                        if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        guard let temps = JSON["temperature"] as? [[String: Any]] else {return}
                        for obj in temps {
                            //print(obj["temp"]!)
                            //self.returnThisArray.append(obj["temp"]! as! Int)
                            self.returnThisArray.append((obj["temp"]! as! Int)%6+36) //kolhoz
                        }
                    }
                }
        }
}

