//
//  StockViewCell.swift
//  pare
//
//  Created by Ehi Airewele  on 7/28/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit
import Charts

class StockViewCell: UICollectionViewCell {
    var stock: Stock?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var lineChartView: LineChartView!
    let positiveGreen = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    let negativeRed = UIColor(red: 250/255.0, green: 92/255.0, blue: 120/255.0, alpha: 1.0)
    var yVals1: [ChartDataEntry] = []
    
    
    func setChart(values: [Double]) {
        yVals1 = insertChartDataEntry(values)
        let lineChartDataSet1 = LineChartDataSet(values: yVals1, label: "")
        
        let gradientColorGreen = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray
        let gradientColorRed = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradientGreen = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColorGreen, locations: colorLocations) else { print("graident error"); return }
        guard let gradientRed = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColorRed, locations: colorLocations) else { print("graident error"); return }
        
        if (stock?.isPositive)! {
            lineChartDataSet1.setColor(positiveGreen)
            lineChartDataSet1.fill = Fill.fillWithLinearGradient(gradientGreen, angle: 90.0)
        } else {
            lineChartDataSet1.setColor(negativeRed)
           lineChartDataSet1.fill = Fill.fillWithLinearGradient(gradientRed, angle: 90.0)
        }
        lineChartDataSet1.drawCirclesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false 
        
        var lineChartDataSets: [LineChartDataSet] = []
        lineChartDataSets.append(lineChartDataSet1)
        lineChartView.legend.enabled = false
        
        //let lineChartData = LineChartData(xVals: sessions, dataSets: lineChartDataSets)
        
        let lineChartData = LineChartData(dataSets: lineChartDataSets)
        lineChartView.data = lineChartData
        
        lineChartView.chartDescription?.text = ""
        let limitLine = ChartLimitLine(limit: values.max()!, label: "High") // There's an alternative initializer without the label
        lineChartView.rightAxis.addLimitLine(limitLine)
        
        // Remove rightAxis labels. Comes from class ChartAxisBase.
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: .easeInSine)
        
        // Change the position of the x-axis labels
        lineChartView.xAxis.labelPosition = .bottom
        
        // Remove the chart's gray background color
        lineChartView.drawGridBackgroundEnabled = false
        
        
        lineChartView.xAxis.granularity = 1
    }
    
    // Helper method
    func insertChartDataEntry(_ values: [Double]) -> [ChartDataEntry] {
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<values.count {
            let yVal = ChartDataEntry(x: Double(i), y: values[i])
            chartDataEntries.append(yVal)
        }
        return chartDataEntries
    }

}

















