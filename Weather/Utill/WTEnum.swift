//
//  WTEnum.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation


// MARK: - TableView type
enum TableViewType: Int {
    case day = 0  // 일별 날씨 Table
}


// MARK: - CollectionView type
enum CollectionViewType: Int {
    case time = 0  // 시간별 날씨 Collection
    case detail = 1  // 날씨 상세 정보 Collection
}


// MARK: - 요일 String type
enum DayOfWeek: Int {
    case mon = 0
    case thu = 1
    case wed = 2
    case the = 3
    case fri = 4
    case sat = 5
    case sun = 6
    
    func getDayOfWeekString() -> String {
        switch self {
        case .mon :
            return "월요일"
        case .thu :
            return "화요일"
        case .wed :
            return "수요일"
        case .the :
            return "목요일"
        case .fri :
            return "금요일"
        case .sat :
            return "토요일"
        case .sun :
            return "일요일"
        }
    }
}


// MARK: - 날씨 icon type
enum WeatherIcon: String {
    case clear_day = "clear-day"
    case clear_night = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partly_cloudy_day = "partly-cloudy-day"
    case partly_cloudy_night = "partly-cloudy-night"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case tornado = "tornado"
    
    func getWeatherIcon() -> String {
        switch self {
        case .clear_day:
            return "☀️"
        case .clear_night:
            return "☀️"
        case .rain:
            return "☔️"
        case .snow:
            return "❄️"
        case .sleet:
            return "🌧"
        case .wind:
            return "🌬"
        case .fog:
            return "🌫"
        case .cloudy:
            return "☁️"
        case .partly_cloudy_day:
            return "⛅️"
        case .partly_cloudy_night:
            return "⛅️"
        case .hail:
            return "🌊"
        case .thunderstorm:
            return "⛈"
        case .tornado:
            return "🌪"
        }
    }
}


// MARK: - 현재 날씨 상세 type String
enum DetailTypeString: Int {
    case sunrise = 0
    case cloudCover
    case ozone
    case visibility
    case sunset
    case humidity
    case pressure
    case uvIndex
    
    func getDetailTypeString() -> String {
        switch self {
        case .sunrise:
            return "일출"
        case .cloudCover:
            return "구름"
        case .ozone:
            return "오존"
        case .visibility:
            return "가시거리"
        case .sunset:
            return "일몰"
        case .humidity:
            return "습도"
        case .pressure:
            return "기압"
        case .uvIndex:
            return "자외선 지수"
        }
    }
}
