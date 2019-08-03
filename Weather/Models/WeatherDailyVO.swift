//
//  WeatherDailyVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 일별 날씨 VO

import Foundation

class WeatherDailyVO: NSObject {
    var dailyTime: DayOfWeek?
    var icon: WeatherIcon?
    var temperatureMin: Int?  // 최고기온
    var temperatureMax: Int?  // 최저기온
}
