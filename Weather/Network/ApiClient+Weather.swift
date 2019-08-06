//
//  ApiClient+Weather.swift
//  weather
//
//  Created by 김효원 on 05/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

extension ApiClient {
    func getWeatherList(weather: NSDictionary, timezone: String?) -> Dictionary<String, Any> {
        do {
            let weatherVO = WeatherVO()
            
            // 지역별 날씨
            weatherVO.latitude = weather["latitude"] as? Double
            weatherVO.logitude = weather["logitude"] as? Double
            weatherVO.timezone = timezone ??  "▼ " + WTFormat().toCityString(weather["timezone"] as! String)
            
            let currently = weather["currently"] as! NSDictionary
            weatherVO.icon = WeatherIcon(rawValue: (currently["icon"] as? String)!)
            weatherVO.temperature = Int(round((currently["temperature"] as! NSNumber).doubleValue))
            
            // 현재 위치의 날씨
            let currentVO = WeatherCurrentVO()
            var hourlyVOList = Array<WeatherHourlyVO>()
            var dailyVOList = Array<WeatherDailyVO>()
            
            // 현재 날씨
            currentVO.timezone = timezone ?? "▼ " + WTFormat().toCityString(weather["timezone"] as! String)
            currentVO.summary = currently["summary"] as? String
            currentVO.icon = WeatherIcon(rawValue: (currently["icon"] as? String)!)
            currentVO.temperature = Int(round((currently["temperature"] as! NSNumber).doubleValue)) // 현재 온도
            currentVO.humidity = WTFormat().toPercentString(currently["humidity"] as! NSNumber) // 습도
            currentVO.pressure = WTFormat().toHPaString(currently["pressure"] as! NSNumber) // 기압
            currentVO.cloudCover = WTFormat().toPercentString(currently["cloudCover"] as! NSNumber) // 구름
            currentVO.uvIndex = (currently["uvIndex"] as! NSNumber).intValue // 자외선 지수
            currentVO.visibility = WTFormat().toKmString(currently["visibility"] as! NSNumber)  // 가시거리
            currentVO.ozone = (currently["ozone"] as! NSNumber).doubleValue // 오존
            
            //일별 날씨 (7)
            let daily = weather["daily"] as! NSDictionary
            
            for items in daily["data"] as! NSArray {
                let dailyList = items as! NSDictionary
                let dailyVO = WeatherDailyVO()
                
                if(dailyVOList.count == 0){
                    currentVO.currentTime =  WTFormat().toDayOfWeek(dailyList["time"] as! NSNumber)
                    currentVO.sunsetTime =  WTFormat().toHourMinute(dailyList["sunsetTime"] as! NSNumber)
                    currentVO.sunriseTime =  WTFormat().toHourMinute(dailyList["sunriseTime"] as! NSNumber)
                    currentVO.temperatureMin = Int(round((dailyList["temperatureMin"] as! NSNumber).doubleValue))
                    currentVO.temperatureMax = Int(round((dailyList["temperatureMax"] as! NSNumber).doubleValue))
                    currentVO.weekSummary = daily["summary"] as? String
                }
                
                dailyVO.dailyTime =  WTFormat().toDayOfWeek(dailyList["time"] as! NSNumber)
                dailyVO.icon = WeatherIcon(rawValue: (dailyList["icon"] as? String)!)
                dailyVO.temperatureMin = Int(round((dailyList["temperatureMin"] as! NSNumber).doubleValue))
                dailyVO.temperatureMax = Int(round((dailyList["temperatureMax"] as! NSNumber).doubleValue))
                
                dailyVOList.append(dailyVO)
                if(dailyVOList.count > 6){
                    break
                }
            }
            
            // 시간별 날씨 (26)
            let hourly = weather["hourly"] as! NSDictionary
            for items in hourly["data"] as! NSArray {
                let hourlyList = items as! NSDictionary
                let hourlyVO = WeatherHourlyVO()
                
                hourlyVO.hourlyTime = WTFormat().toHour(hourlyList["time"] as! NSNumber)
                hourlyVO.icon = WeatherIcon(rawValue: (hourlyList["icon"] as? String)!)
                hourlyVO.temperature = Int(round((hourlyList["temperature"] as! NSNumber).doubleValue))
                hourlyVO.humidity = WTFormat().toPercentString(hourlyList["humidity"] as! NSNumber) // 습도
                
                hourlyVOList.append(hourlyVO)
                if(hourlyVOList.count > 25){
                    break
                }
            }
            
            return [
                "weatherVO" : weatherVO,
                "currentVO" : currentVO,
                "dailyVOList" : dailyVOList,
                "hourlyVOList" : hourlyVOList ]
        }
    }
}
