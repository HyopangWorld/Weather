//
//  WeatherVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 날씨 기본 파라미터

import Foundation

class WeatherVO: NSObject{
    var latitude: Double?  // 요청한 위도
    var logitude: Double?  // 요청한 경도
    var timezone: String?  // 요청한 지역명
    var temperature: Int?  // 요청한 지역명
    var icon: WeatherIcon?  // 요청한 아이콘
}
