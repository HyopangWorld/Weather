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
    var hourlyTime: String = "오후 5시"  // 시간 (오전/오후 00시)
    var icon: WeatherIcon = .rain  // 날씨 아이콘
    var temperature: Int = 31  // 온도
    var humidity: String = "60%"  // 습도
}
