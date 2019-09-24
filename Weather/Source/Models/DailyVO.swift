//
//  WeatherDailyVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 일별 날씨 VO
 */

import Foundation

struct DailyVO {
    var dailyTime: DayOfWeek? = .wed  // 요일
    var icon: WeatherIcon? = .rain    // 날씨 아이콘
    var temperatureMin: Int? = 28     // 최고기온
    var temperatureMax: Int? = 30     // 최저기온
}
