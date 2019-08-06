//
//  WTUrl.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * API URL
 */

import Foundation

struct WTUrl {
    // 고정 URL
    static let developerKey = "73015d0d22e9c7fddee042376b7ea5ed"
    static let prefixUrl = "https://api.darksky.net/forecast/\(developerKey)"
    
    // 상세 URL
    struct postFixUrl {
        
        // (currently, hourly, daily), 한글
        let getWeather = "?exclude=minutely,alerts,flag&lang=ko"
        
    }
}
