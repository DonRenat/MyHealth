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
    @IBOutlet weak var dataSelector: UISegmentedControl!
    
    //future update: take data from server
    var temperature : [Double] = [36.7, 37.0, 38.2, 39.3, 37.0, 36.6]
    var pulse : [Double] = [66, 80, 73, 55, 59, 90]
    var feeling : [Double] = [1, 2, 3, 4, 5, 6]
    
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
        
        Chart.rightAxis.enabled = false
        Chart.xAxis.enabled = false
        updateGraph(data: temperature)
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch dataSelector.selectedSegmentIndex{
        case 0:
            updateGraph(data: temperature)
        case 1:
            updateGraph(data: pulse)
        case 2:
            updateGraph(data: feeling)
        default:
            break
        }
    }
    
    func updateGraph(data: [Double]){
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
}

