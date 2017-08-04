//
//  NetworkRequest.swift
//  pare
//
//  Created by Ehi Airewele  on 7/28/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct NetworkRequest {
    var stocks = [Stock]()
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    static func getTime() -> String {
        var date = Date()
        //        date.addTimeInterval(TimeInterval(-60))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    static func instantiateStock(symbol: String, completion: @escaping (Stock?) -> Void) {
        let thisSymbol = symbol
        let dispatchgroup = DispatchGroup()
        dispatchgroup.enter()
        var object:Stock?
        getStockName(symbol: thisSymbol, completion: { (name) in
            
            getStockLogo(symbol: thisSymbol) { (logo) in
                allCompany(symbol: thisSymbol, completion: { (description, site, ceo) in
                    quote(symbol: thisSymbol, completion: { (primaryExchange, calculationPrice, previousClose, avgTotalVolume, marketCap, peRatio, week52Low, week52High) in
                        
                        stats(symbol: thisSymbol, completion: { (profitMargin, peRatioLow, peRatioHigh) in
                            getMinuteData(symbol: thisSymbol) { (price) in
                                
                                var isPositive = true
                                let change = price - previousClose
                                var changePercent = 0.0
                                
                                if (change < 0) {
                                    isPositive = false
                                }
                                
                                if (change == 0) {
                                    changePercent = 0.0
                                } else {
                                    changePercent = (change / previousClose) * 100.00
                                }
                                
                                object = Stock(symbol: thisSymbol, companyName: name, logo: logo, price: price, changePercent: changePercent, change: change, primaryExchange: primaryExchange, calculationPrice: calculationPrice, previousClose: previousClose, avgTotalVolume: avgTotalVolume, marketCap: UInt64(marketCap), peRatio: peRatio, peRatioHigh: peRatioHigh, peRatioLow: peRatioLow, week52High: week52High, week52Low: week52Low, profitMargin: profitMargin, isPositive: isPositive, description: description, website: site, CEO: ceo)
                                completion(object)
                                //                                dispatchgroup.leave()
                            }
                            //                            dispatchgroup.leave()
                        })
                        //                        dispatchgroup.leave()
                        
                        
                    })
                    //                    dispatchgroup.leave()
                    
                })
                //                dispatchgroup.leave()
                
            }
            //            dispatchgroup.leave()
            
        })
        
        //        dispatchgroup.notify(queue: .main) {
        //            completion(object)
        
        //        }
        
    }
    
    static func getStockName(symbol: String, completion: @escaping (String) -> Void) {
        let stockNameEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.quote)"
        
        Alamofire.request(stockNameEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let name = json["companyName"].stringValue
                    completion(name)
                }
            case .failure(let error):
                print("name", symbol)
            }
        }
        
    }
    
    
    
    //    https://api.iextrading.com/1.0/stock/{symbol}/quote
    
    static func getStockLogo(symbol: String, completion: @escaping (UIImage) -> Void) {
        let stockLogoEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.logo)"
        
        Alamofire.request(stockLogoEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let logo = json["url"].stringValue
                    
                    guard let url = URL(string: logo) else {
                        
                        print("error", symbol)
                        let image = UIImage(named: "notPoop.png")
                        completion(image!)
                        return
                    }
                    
                    let data = try! Data(contentsOf: url)
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: (data)) else {
                            let image = UIImage(named: "notPoop.png")
                            completion(image!)
                            return
                        }
                        completion(image)
                    }
                }
            case .failure(let error):
                print("image", symbol)
                
            }
        }
    }
    //    https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=1min&apikey=demo
    //    time: String,
    
    static func getMinuteData(symbol: String, completion: @escaping (Double) -> Void) {
        let stockMinuteEndpoint = "\(Constants.AlphaVantage.alphaVantageBase)\(Constants.AlphaVantageParameters.intradayFunction)\(Constants.AlphaVantageParameters.symbolEqual)\(symbol)\(Constants.AlphaVantageParameters.interval1min)\(Constants.AlphaVantageParameters.AlphaVantageKey)"
        
        var close = 0.00
        var closeDayBefore = 0.00
        
        var time = Date()
        time.addTimeInterval(TimeInterval(-60))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        let resultTime = formatter.string(from: time)
        
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "yyyy-MM-dd"
        formatDate.timeZone = TimeZone(abbreviation: "EST")
        let resultDate = formatDate.string(from: date)
        
        let current = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let currentResult = dateFormatter.string(from: current)
        let calendar = Calendar.current
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)
        let resultYesterday = formatDate.string(from: yesterday!)
        let twoDays = Calendar.current.date(byAdding: .day, value: -2, to: date)
        let resultTwoDays = formatDate.string(from: twoDays!)
        let threeDays = Calendar.current.date(byAdding: .day, value: -3, to: date)
        let resultThreeDays = formatDate.string(from: threeDays!)
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        let (hour, minute) = stringToTime(string: resultTime)
        
        var between930And4 = (hour <= 16) && (hour >= 9)
        if (hour == 9) {
            if (minute >= 30) {
                between930And4 = true
            } else {
                between930And4 = false
            }
        } else if (hour == 16) {
            if (minute == 0) {
                between930And4 = true
            } else {
                between930And4 = false
            }
        }
        
        Alamofire.request(stockMinuteEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if (weekDay == 1) {
                        close = json["Time Series (1min)"]["\(resultTwoDays) 16:00:00"]["4. close"].doubleValue
                        closeDayBefore = json["Time Series (1min)"]["\(resultThreeDays) 16:00:00"]["4. close"].doubleValue
                    } else if (weekDay == 7) {
                        close = json["Time Series (1min)"]["\(resultYesterday) 16:00:00"]["4. close"].doubleValue
                        closeDayBefore = json["Time Series (1min)"]["\(resultTwoDays) 16:00:00"]["4. close"].doubleValue
                    } else if (!between930And4) {
                        close = json["Time Series (1min)"]["\(resultDate) 16:00:00"]["4. close"].doubleValue
                        closeDayBefore = json["Time Series (1min)"]["\(resultYesterday) 16:00:00"]["4. close"].doubleValue
                    } else {
                        close = json["Time Series (1min)"]["\(currentResult):00"]["4. close"].doubleValue
                        closeDayBefore = json["Time Series (1min)"]["\(resultYesterday) 16:00:00"]["4. close"].doubleValue
                    }
                    
                    close = Double(round(100 * close)/100)
                    let change = close - closeDayBefore
                    var changePercent = 0.00
                    
                    if (change < 0) {
                        changePercent = ((closeDayBefore - close)/(closeDayBefore)) * 100.00
                    } else if (change > 0) {
                        changePercent = ((close - closeDayBefore))/(closeDayBefore) * 100.00
                    } else {
                        changePercent = 0
                    }
                    completion(close)
                }
            case .failure(let error):
                print("minute", symbol)
                
            }
        }
    }
    
    static func stringToMinutes(input:String) -> Int {
        let components = input.components(separatedBy: ":")
        let hour = Int((components.first ?? "0")) ?? 0
        let minute = Int((components.last ?? "0")) ?? 0
        return hour*60 + minute
    }
    
    static func stringToTime(string: String) -> (hour: Int, minute: Int) {
        let result = string.components(separatedBy: ":")
        
        //let hour: Int = Int(result[0])!
        //let minute: Int = Int(result[1])!
        
        guard let hour = Int(result[0]), let minute = Int(result[1]) else {
            //print("hour \(hour) minute \(minute)")
            return (0, 1)
        }
        
        return (hour, minute)
        
    }
    
    //    static func getAverages (symbol: String, completion: @escaping ([String: Double]) -> Void) {
    //        let stockDataEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.chartOneDay)"
    //
    //        let time = Date()
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH:mm"
    //        formatter.timeZone = TimeZone(abbreviation: "EST")
    //        let resultTime = formatter.string(from: time)
    //
    //        let dayMinute = stringToTime(string: resultTime)
    //        var averages: [String:Double] = [:]
    //
    //        Alamofire.request(stockDataEndpoint).validate().responseJSON() { response in
    //            switch response.result {
    //            case .success:
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    let allTimeData = json.arrayValue
    //
    //                    for data in allTimeData {
    //                        let time = data["minute"].stringValue
    //                        let average = data["average"].doubleValue
    //
    //                        averages[time] = average
    //
    //                    }
    //                    completion(averages)
    //                }
    //            case .failure(let error):
    //                print(error)
    //            }
    //
    //
    //        }
    //
    //    }
    
    static func getMonthAverages(symbol: String, completion: @escaping ([String: Double]) -> Void) {
        let stockDataEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.chartOneMonth)"
        
        var averages: [String: Double] = [:]
        
        Alamofire.request(stockDataEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let allTimeData = json.arrayValue
                    
                    for data in allTimeData {
                        let date = data["date"].stringValue
                        let close = data["close"].doubleValue
                        
                        averages[date] = close
                    }
                    completion(averages)
                    
                }
            case .failure(let error):
                print("averages")
            }
        }
    }
    
    func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: NSCalendar.Options {
            switch self {
            case .Next:
                return .matchNextTime
            case .Previous:
                return [.searchBackwards, .matchNextTime]
            }
        }
    }
    
    func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDate(after: today as Date, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
        return date! as NSDate
    }
    
    
    static func getNews (symbol: String, completion: @escaping ([NewsItem]) -> Void) {
        var newsItems = [NewsItem]()
        
        let newsEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.stockNews)"
        
        Alamofire.request(newsEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let allNewsData = json.arrayValue
                    
                    for data in allNewsData {
                        let headline = data["headline"].stringValue
                        let source = data["source"].stringValue
                        let url = data["url"].url
                        let news = NewsItem(headline: headline, source: source, url: url!)
                        newsItems.append(news)
                        
                        completion(newsItems)
                    }
                }
            case .failure(let error):
                print("news", symbol)
            }
            
        }
        
    }
    
    static func getMarketNews(completion: @escaping ([NewsItem]) -> Void) {
        var newsItems = [NewsItem]()
        let newsEndpoint = "\(Constants.IEX.IEXBase)\(Constants.IEXParameters.marketNews)"
        
        Alamofire.request(newsEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let allNewsData = json.arrayValue
                    
                    for data in allNewsData {
                        let headline = data["headline"].stringValue
                        let source = data["source"].stringValue
                        let url = data["url"].url
                        let news = NewsItem(headline: headline, source: source, url: url!)
                        newsItems.append(news)
                        
                        completion(newsItems)
                    }
                }
            case .failure(let error):
                print("news")
            }
            
        }
        
    }
    
    
    static func allCompany (symbol: String, completion: @escaping (String, String, String) -> Void) {
        let companyEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.company)"
        
        //        var json: JSON
        var site: String = ""
        var description: String = ""
        var ceo: String = ""
        let group = DispatchGroup()
        group.enter()
        
        Alamofire.request(companyEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    site = json["website"].stringValue
                    description = json["description"].stringValue
                    ceo = json["CEO"].stringValue
                    
                    group.leave()
                    
                }
            case .failure(let error):
                print("company")
            }
            
        }
        group.notify(queue: .main) {
            completion(description, site, ceo)
        }
    }
    
    
    
    
    static func quote (symbol: String, completion: @escaping (String, String, Double, Int, UInt64, Double, Double, Double) -> Void) {
        let quoteEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.quote)"
        
        
        Alamofire.request(quoteEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let primaryExchange = json["primaryExchange"].stringValue
                    let calculationPrice = json["calculationPrice"].stringValue
                    let previousClose = json["previousClose"].doubleValue
                    let peRatio = json["peRatio"].doubleValue
                    let week52Low = json["week52Low"].doubleValue
                    let week52High = json["week52High"].doubleValue
                    let avgTotalVolume = json["avgTotalVolume"].intValue
                    let marketCap = Int(json["marketCap"].uInt64Value)
                    
                    completion(primaryExchange, calculationPrice, previousClose, avgTotalVolume, UInt64(marketCap), peRatio, week52Low, week52High)
                }
            case .failure(let error):
                print("quote", symbol)
            }
        }
    }
    
    static func stats (symbol: String, completion: @escaping (Double, Double, Double) -> Void) {
        let statsEndpoint = "\(Constants.IEX.IEXBase)\(symbol)\(Constants.IEXParameters.stats)"
        Alamofire.request(statsEndpoint).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let profitMargin = json["profitMargin"].doubleValue
                    let peRatioLow = json["peRatioLow"].doubleValue
                    let peRatioHigh = json["peRatioHigh"].doubleValue
                    
                    completion(profitMargin, peRatioLow, peRatioHigh)
                }
            case .failure(let error):
                print("stats", symbol)
            }
        }
    }
    
    //https://www.alphavantage.co/query?function=EMA&symbol=aapl&interval=monthly&time_period=10&series_type=close&apikey=IBRP1HQPU3LCZNXZ
    //    static func EMA (symbol: String, completion: @escaping (Double) -> Void) {
    //        let emaEndpoint = "\(Constants.AlphaVantage.alphaVantageBase)\(Constants.AlphaVantageParameters.emaFunction)\(Constants.AlphaVantageParameters.symbolEqual)\(symbol)\(Constants.AlphaVantageParameters.intervalMonthly)\(Constants.AlphaVantageParameters.timePeriod10)\(Constants.AlphaVantageParameters.closeSeriesType)\(Constants.AlphaVantageParameters.AlphaVantageKey)"
    //
    //        Alamofire.request(emaEndpoint).validate().responseJSON() { response in
    //            switch response.result {
    //            case .success:
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //
    //                    let ema = json["Technical Analysis: EMA"]
    //                }
    //        var consumerDiscretionary: [Stock] = []
    //        var consumerStaples: [Stock] = []
    //        var energy: [Stock] = []
    //        var financials: [Stock] = []
    //        var healthCare: [Stock] = []
    //        var industrials: [Stock] = []
    //        var informationTechnology: [Stock] = []
    //        var materials: [Stock] = []
    //        var realEstate: [Stock] = []
    //        var telecommunicationServices: [Stock] = []
    //        var utilites: [Stock] = []
    
    
    static func filterSectors(symbol: String, completion: @escaping ([String]) -> Void) {
        
        var symbolMarketCap: UInt64 = 0
        var symbolPeRatio = 0.0
        var marketCapDes = ""
        var thisMarketCap: UInt64 = 0
        var thisPeRatio = 0.0
        var thisMarketCapDes = ""
        
        //        DispatchQueue.main.sync {
        instantiateStock(symbol: symbol) { (symbolStock :Stock?) in
            //            dispatchGroup.enter()
            symbolMarketCap = (symbolStock?.marketCap)!
            symbolPeRatio = (symbolStock?.peRatio)!
            if (symbolMarketCap >= 10000000000) {
                marketCapDes = "large cap"
            } else if (symbolMarketCap >= 2000000000 && symbolMarketCap < 10000000000) {
                marketCapDes = "medium cap"
            } else {
                marketCapDes = "small cap"
            }
            
            guard let jsonURL = Bundle.main.url(forResource: "symbol + sector", withExtension: "json") else {
                return
            }
            //        DispatchQueue.global(qos: .userInitiated).sync {
            let jsonData = try! Data(contentsOf: jsonURL)
            let sectorData = JSON(data: jsonData)
            let allStockData = sectorData["results"].arrayValue
            
            //            dispatchGroup.enter()
            //            DispatchQueue.concurrentPerform(iterations: allStockData.count) { (i) in
            //                let stock = allStockData[i]
            let dispatchGroup = DispatchGroup()
            var recommendArray : [String] = []
            
            for stock in allStockData {
                dispatchGroup.enter()
                let thisSymbol = stock["Ticker symbol"].stringValue
                quote(symbol: thisSymbol, completion: { (_, _, _, _, marketCap, peRatio, _, _) in
                    thisMarketCap = UInt64(marketCap)
                    thisPeRatio = peRatio
                    if (thisMarketCap >= 10000000000) {
                        thisMarketCapDes = "large cap"
                    } else if (thisMarketCap >= 2000000000 && marketCap < 10000000000) {
                        thisMarketCapDes = "medium cap"
                    } else {
                        thisMarketCapDes = "small cap"
                    }
                    var count = 0
                    if (abs(thisPeRatio - symbolPeRatio) <= 5) && (marketCapDes == thisMarketCapDes) {
                        recommendArray.append(thisSymbol)
                        //                            instantiateStock(symbol: thisSymbol, completion: { (recommend :Stock?) in
                        //                                recommendArray.append(recommend!)
                        //                                dispatchGroup.leave()
                        //                            })
                        dispatchGroup.leave()
                    } else {
                        dispatchGroup.leave()
                    }
                })
                
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(recommendArray)
            }
        }
        
        
        //        }
        //        }
        
    }
    
    
    
    //                let highRange = ratio + 1 ... ratio + 10
    //                let lowRange = ratio - 10 ..< ratio
    //                for (i, stock) in allStocks.enumerated() {
    //                    if (stock.symbol == symbol) {
    //                        let index = allStocks[i]
    //
    //                        if (highRange ~= index.peRatio) {
    //                            recommendArray.append(index)
    //                        } else if (lowRange ~= index.peRatio) {
    //                            recommendArray.append(index)
    //
    //                        }
    //
    //                    }
    //                }
    //
    //            })
    //
    //
    //
    //
    //
    //
    //
    //            instantiateStock(symbol: thisSymbol, completion: { (Stock) in
    //                allStocks.append(Stock!)
    //                dispatchGroup.leave()
    //            })
    //        }
    //        //    }
    //        dispatchGroup.notify(queue: .main) {
    //            allStocks = allStocks.sorted{ ($0.peRatio > $1.peRatio) }
    //            var currStock: Stock? = nil
    //
    //            var marketCapDes = ""
    //            var marketCap: UInt64 = 0
    //            instantiateStock(symbol: symbol) { (Stock) in
    //                marketCap = UInt64((Stock?.marketCap)!)
    //                currStock = Stock
    //                if (marketCap >= 10000000000) {
    //                    marketCapDes = "large cap"
    //                } else if (marketCap >= 2000000000 && marketCap < 10000000000) {
    //                    marketCapDes = "medium cap"
    //                } else {
    //                    marketCapDes = "small cap"
    //                }
    //                //
    //                let ratio = currStock!.peRatio
    //                let highRange = ratio + 1 ... ratio + 10
    //                let lowRange = ratio - 10 ..< ratio
    //                for (i, stock) in allStocks.enumerated() {
    //                    if (stock.symbol == symbol) {
    //                        let index = allStocks[i]
    //
    //                        if (highRange ~= index.peRatio) {
    //                            recommendArray.append(index)
    //                        } else if (lowRange ~= index.peRatio) {
    //                            recommendArray.append(index)
    //
    //                        }
    //
    //                    }
    //                }
    //
    //                var thisMarketCapDes = ""
    //                for recommended in recommendArray {
    //                    if (recommended.marketCap >= 10000000000) {
    //                        thisMarketCapDes = "large cap"
    //                    } else if (recommended.marketCap >= 2000000000 && recommended.marketCap < 10000000000) {
    //                        thisMarketCapDes = "medium cap"
    //                    } else {
    //                        thisMarketCapDes = "small cap"
    //                    }
    //                    if (marketCapDes == thisMarketCapDes) {
    //                        finalArray.append(recommended)
    //                    }
    //                }
    //                completion(finalArray)
    //            }
    //
    //
    //        }
    //
    //
    //
    //    }
    //
    //}
    
    
    
    
    
    
    
    
    //            for stock in allStockData {
    //                let thisSymbol = stock["Symbol ticker"].stringValue
    //                let thisSector = stock["GICS Sector"].stringValue
    //
    //                if (thisSector == "Consumer Discretionary") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (consumerDiscretionaryStock) in
    //                        consumerDiscretionary.append(consumerDiscretionaryStock)
    //                    })
    //                } else if (thisSector == "Energy") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (energyStock) in
    //                        energy.append(energyStock)
    //                    })
    //                } else if (thisSector == "Consumer Staples") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (consumerStapleStock) in
    //                        consumerStaples.append(consumerStapleStock)
    //                    })
    //                } else if (thisSector == "Financials") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (financialsStock) in
    //                        financials.append(financialsStock)
    //                    })
    //                } else if (thisSector == "Health Care") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (healthCareStock) in
    //                        healthCare.append(healthCareStock)
    //                    })
    //                } else if (thisSector == "Industrials") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (industrialsStock) in
    //                        industrials.append(industrialsStock)
    //                    })
    //                } else if (thisSector == "Information Technology") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (informationTechStock) in
    //                        informationTechnology.append(informationTechStock)
    //                    })
    //                } else if (thisSector == "Materials") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (materialStock) in
    //                        materials.append(materialStock)
    //                    })
    //                } else if (thisSector == "Real Estate") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (realEstateStock) in
    //                        realEstate.append(realEstateStock)
    //                    })
    //                } else if (thisSector == "Telecommunications Services") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (telecommStock) in
    //                        telecommunicationServices.append(telecommStock)
    //                    })
    //                } else if (thisSector == "Utilities") {
    //                    instantiateStock(symbol: thisSymbol, completion: { (utilitiesStock) in
    //                        utilites.append(utilitiesStock)
    //                    })
    //                }
    //            }
    
    
    
    
    
    
    
    //            let allStocks: [String: [Stock]] = ["Consumer Discretionary": consumerDiscretionary, "Energy": energy, "Consumer Staples": consumerStaples, "Financials": financials, "Health Care": healthCare, "Industrials": industrials, "Information Technology": informationTechnology, "Materials": materials, "Real Estate": realEstate, "Telecommunications Services": telecommunicationServices, "Utilities": utilites]
    
    
    
    
    
    
    
    //        getMinuteData(symbol: symbol) { (price) in
    //
    //            quote(symbol: symbol, completion: { (_, _, previousClose, _, marketCap, peRatio, _, _) in
    //                if (marketCap >= 10000000000) {
    //                    marketCapDes = "large cap"
    //                } else if (marketCap >= 2000000000 && marketCap < 10000000000) {
    //                    marketCapDes = "medium cap"
    //                } else {
    //                    marketCapDes = "small cap"
    //                }
    //
    //                guard let jsonURL = Bundle.main.url(forResource: "symbol + sector", withExtension: "json") else {
    //                    return
    //                }
    //
    //                DispatchQueue.global(qos: .userInitiated).sync {
    //                    let jsonData = try! Data(contentsOf: jsonURL)
    //                    let sectorData = JSON(data: jsonData)
    //                    let allStockData = sectorData["results"].arrayValue
    //
    //                    for stocks in allStockData {
    //                        let thisSymbol = stocks["Symbol ticker"].stringValue
    //                        let thisSector = stocks["GICS Sector"].stringValue
    //
    ////                        let symbolSector = allStockData.filter{symbol == thisSymbol}
    //
    //                        if (symbol != thisSymbol) {
    //                            getMinuteData(symbol: thisSymbol, completion: { (thisPrice) in
    //
    //                                quote(symbol: thisSymbol, completion: { (_, _, thisPreviousClose, _, thisMarketCap, thisPeRatio, _, _) in
    //                                    if (thisMarketCap >= 10000000000) {
    //                                        thisMarketCapDes = "large cap"
    //                                    } else if (thisMarketCap >= 2000000000 && marketCap < 10000000000) {
    //                                        thisMarketCapDes = "medium cap"
    //                                    } else {
    //                                        thisMarketCapDes = "small cap"
    //                                    }
    //
    //                                    if (abs(price - thisPrice) <= 15) {
    //                                        if (marketCapDes == thisMarketCapDes) {
    //                                            if (abs(previousClose - thisPreviousClose) <= 10) {
    //
    //                                            }
    //                                        }
    //                                    }
    //                                })
    //                            })
    //                        })
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    
    
}
