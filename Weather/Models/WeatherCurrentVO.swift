//
//  CurrentWeatherVO.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 현재 날씨 VO

import Foundation

class WeatherCurrentVO: NSObject {
    var currentTime: DayOfWeek?  // 요일
    var timezone: String?  // 요청한 지역명
    var summary: String?  // 요약
    var weekSummary: String? // 주간 요약
    var icon: WeatherIcon?  // 날씨 아이콘
    var temperature: Int? // 현재 온도
    var temperatureMin: Int?  // 최저기온
    var temperatureMax: Int?  // 최고기온
    var sunriseTime: String? // 일출 시간 - daily info
    var sunsetTime: String?  // 일몰 시간 - daily info
    var humidity: String? // 습도
    var pressure: String? // 기압
    var cloudCover: String? // 구름
    var uvIndex: Int? // 자외선 지수
    var visibility: String?  // 가시거리
    var ozone: Double? // 오존
    
    
    // MARK: - Detail 정보 Array getter
    func getCurrentDetailArray() -> Array<Any> {
        var currentDetailArray = Array<Any>()
        
        currentDetailArray.append(self.sunriseTime!)
        currentDetailArray.append(self.cloudCover!)
        currentDetailArray.append(self.ozone!)
        currentDetailArray.append(self.visibility!)
        currentDetailArray.append(self.sunsetTime!)
        currentDetailArray.append(self.humidity!)
        currentDetailArray.append(self.pressure!)
        currentDetailArray.append(self.uvIndex!)
        
        return currentDetailArray
    }
}
