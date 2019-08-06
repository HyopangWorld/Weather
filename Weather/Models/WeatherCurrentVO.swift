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
    var currentTime: DayOfWeek = .wed  // 요일
    var timezone: String = "서울특별시"  // 요청한 지역명
    var summary: String = "흐림"  // 요약
    var weekSummary: String = "내일동안 약한 비, 내일 87˚E까지 하강"  // 요약 // 주간 요약
    var icon: WeatherIcon = .rain  // 날씨 아이콘
    var temperature: Int = 30 // 현재 온도
    var temperatureMin: Int = 28  // 최저기온
    var temperatureMax: Int = 36  // 최고기온
    var sunriseTime: String = "오전 5:41" // 일출 시간 - daily info
    var sunsetTime: String = "오후 7:37"  // 일몰 시간 - daily info
    var humidity: String = "58%" // 습도
    var pressure: String = "1005hPa" // 기압
    var cloudCover: String = "79%" // 구름
    var uvIndex: Int = 0 // 자외선 지수
    var visibility: String = "6.53km"  // 가시거리
    var ozone: Double = 282.1 // 오존
    
    
    // MARK: - Detail 정보 Array getter
    func getCurrentDetailArray() -> Array<Any> {
        var currentDetailArray = Array<Any>()
        
        currentDetailArray.append(self.sunriseTime)
        currentDetailArray.append(self.cloudCover)
        currentDetailArray.append(self.ozone)
        currentDetailArray.append(self.visibility)
        currentDetailArray.append(self.sunsetTime)
        currentDetailArray.append(self.humidity)
        currentDetailArray.append(self.pressure)
        currentDetailArray.append(self.uvIndex)
        
        return currentDetailArray
    }
}
