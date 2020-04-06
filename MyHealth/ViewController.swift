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

class ViewController: UIViewController {
    
    @IBOutlet weak var Chart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var dataSelector: UISegmentedControl!
    
    //future update: take data from server
    var temperature : [Double] = [36.7, 37.0, 38.2, 39.3, 37.0, 36.6]
    var pulse : [Double] = [66, 80, 73, 55, 59, 90]
    
    //test feeling
    //var feeling : [Double] = [1, 2, 3, 4, 5, 6]
    let status = ["Good", "Medium", "Bad", "SOS"]
    let statusAmount = [10, 13, 4, 1]
    
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
        
        pieChart.isHidden = true
        //updatePieChart(dataPoints: status, values: statusAmount.map{ Double($0) })
        
        Chart.rightAxis.enabled = false
        Chart.xAxis.enabled = false
        updateLineChart(data: temperature)
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch dataSelector.selectedSegmentIndex{
        case 0:
            Chart.isHidden = false
            pieChart.isHidden = true
            updateLineChart(data: temperature)
        case 1:
            Chart.isHidden = false
            pieChart.isHidden = true
            updateLineChart(data: pulse)
        case 2:
            updatePieChart(dataPoints: status, values: statusAmount.map{ Double($0) })
            Chart.isHidden = true
            pieChart.isHidden = false
        default:
            break
        }
    }
    
    func updateLineChart(data: [Double]){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        for i in 0..<data.count {

            let value = ChartDataEntry(x: Double(i), y: data[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let description = dataSelector.titleForSegment(at: dataSelector.selectedSegmentIndex)
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: description)
        line1.colors = [NSUIColor.blue]

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        Chart.data = data
        //Chart.legend.enabled = false
        //Chart.chartDescription?.text = description
    }
    
    func updatePieChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        
        //pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        var  colors: [UIColor] = []
        colors.append(UIColor.green)
        colors.append(UIColor.orange)
        colors.append(UIColor.red)
        colors.append(UIColor.magenta)
        //pieChartDataSet.colors = colors
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: 4)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)

        pieChart.data = pieChartData
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
}

