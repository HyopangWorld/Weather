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
    var hourlyTime: String?  // 시간 (오전/오후 00시)
    var icon: WeatherIcon?  // 날씨 아이콘
    var temperature: Int?  // 온도
    var humidity: String?  // 습도
}
