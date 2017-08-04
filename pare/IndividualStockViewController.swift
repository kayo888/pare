//
//  IndividualStockViewController.swift
//
//
//  Created by Ehi Airewele  on 7/17/17.
//
//
// THIS IS ERIC'S PROJECT

import UIKit
import Charts

class IndividualStockViewController: UIViewController {
    var stock: Stock?
    var newsArray = [NewsItem]()
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var individualStockView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var followButton: UIButton!
    
    let positiveGreen = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    let negativeRed = UIColor(red: 250/255.0, green: 92/255.0, blue: 120/255.0, alpha: 1.0)
    
    var yVals1: [ChartDataEntry] = []
    var months = [String]()
    var values = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stock = stock {
            NetworkRequest.getMonthAverages(symbol: (stock.symbol)) { (dict: [String : Double]) in
                self.months = Array(dict.keys)
                self.values = Array(dict.values)
                
                self.setChart(dataPoints: self.months, values: self.values)
            }
            
            NetworkRequest.getNews(symbol: stock.symbol) { (newsItems: [NewsItem]) in
                
                self.newsArray = newsItems
                
                DispatchQueue.main.async {
                    self.newsCollectionView.reloadData()
                }
            }
            
        }
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        yVals1 = insertChartDataEntry(values)
        let lineChartDataSet1 = LineChartDataSet(values: yVals1, label: "")
        
        if (stock?.isPositive)! {
            lineChartDataSet1.setColor(positiveGreen)
        } else {
            lineChartDataSet1.setColor(negativeRed)
        }
        
        var lineChartDataSets: [LineChartDataSet] = []
        lineChartDataSets.append(lineChartDataSet1)
        
        //let lineChartData = LineChartData(xVals: sessions, dataSets: lineChartDataSets)
        
        let lineChartData = LineChartData(dataSets: lineChartDataSets)
        lineChartView.data = lineChartData
        
        lineChartView.chartDescription?.text = ""
        let limitLine = ChartLimitLine(limit: values.max()!, label: "High") // There's an alternative initializer without the label
        lineChartView.rightAxis.addLimitLine(limitLine)
        
        // Remove rightAxis labels. Comes from class ChartAxisBase.
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.animate(xAxisDuration: 2.5)
        
        // Change the position of the x-axis labels
        lineChartView.xAxis.labelPosition = .bottom
        
        // Remove the chart's gray background color
        lineChartView.drawGridBackgroundEnabled = false
        
        let gradientColors = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        //        lineChartDataSet1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        //        set.drawFilledEnabled = true // Draw the Gradient
        
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let stock = stock {
            nameLabel.text = stock.companyName
            priceLabel.text = "\(stock.price)"
            logo.image = stock.logo
            
            
        } else {
            
        }
    }
    
    func getNews () -> Void {
        let symbol = stock?.symbol
        if let symbol = symbol {
            NetworkRequest.getNews(symbol: symbol) { (newsItems: [NewsItem]) in
                
                self.newsArray = newsItems
                
            }
        } else {
            print("symbol is nil")
        }
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowNews" {
                
                let indexPath = newsCollectionView.indexPathsForSelectedItems?.first
                
                let news = newsArray[indexPath!.item]
                let newsViewController = segue.destination as! NewsViewController
                newsViewController.url = news.url
                //newsViewController.url = sender as? URL
            }
        }
    }
}





extension IndividualStockViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let newsCollection = newsArray[indexPath.item]
        cell.headlineLabel.text = newsCollection.headline
        cell.newsImage.image = #imageLiteral(resourceName: "Sample Scene.png")
        
        return cell
    }
    
}

extension IndividualStockViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //        let newsVC = storyboard.instantiateViewController(withIdentifier: "NewsView") as! NewsViewController
        
        
        //        performSegue(withIdentifier: "ShowNews", sender: newsVC.url)
        performSegue(withIdentifier: "ShowNews", sender: self)
        
        //        self.present(newsVC, animated: true, completion: nil)
    }
    
    
}










