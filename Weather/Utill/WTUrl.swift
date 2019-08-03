//
//  WTUrl.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

struct WTUrl {
    static let developerKey = "e953fb03d875d3354d8e97acd7764771"
    static let prefixUrl = "https://api.darksky.net/forecast/\(developerKey)"
    
    struct postFixUrl {
        
        // (currently, hourly, daily), 한글
        let getWeather = "?exclude=minutely,alerts,flag&lang=ko"
        
    }
}
