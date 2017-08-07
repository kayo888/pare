//
//  Stock.swift
//  pare
//
//  Created by Ehi Airewele  on 7/28/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

struct Stock {
    let symbol: String
    let companyName: String
    let logo: UIImage
    let price: Double
    let changePercent: Double
    let change: Double
    
    let primaryExchange: String
    let calculationPrice: String
    let previousClose: Double
    let avgTotalVolume: Int
    let marketCap: UInt64
    let peRatio: Double
    let peRatioHigh: Double
    let peRatioLow: Double
    let week52High: Double
    let week52Low: Double
    let profitMargin: Double
    
    let isPositive: Bool
    let description: String
    let website: String
    let CEO: String
    var isFollowed = false 
}
//change, change% is calculated using calculationPrice from previousClose.

struct WatchlistStock {
    let symbol: String
    let companyName: String
    let logo: UIImage
    let price: Double
    let changePercent: Double
    let change: Double
    
    let isPositive: Bool
}

struct RecommendedStock {
    let symbol: String
    let logo: UIImage
}



//graph - 174w 158h
//name & symbol bold and price etc. opaque
