//
//  TimeVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 시간별 날씨 VO

import Foundation

class WeatherHourlyVO: NSObject {
    var hourlyTime: String?
    var icon: WeatherIcon?
    var temperature: Int?
    var humidity: String?
}
