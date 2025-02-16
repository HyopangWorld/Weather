//
//  WeatherVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 날씨 기본 파라미터 VO
 */

import Foundation

struct WeatherVO{
    var latitude: Double?                // 요청한 위도
    var logitude: Double?                // 요청한 경도
    var timezone: String? = "Seoul"      // 요청한 지역명
    var temperature: Int? = 30           // 요청한 온도
    var icon: WeatherIcon? = .rain       // 요청한 아이콘
    var current: CurrentVO?
    var hourly: HourlyVO?
    var daily: DailyVO?
}
