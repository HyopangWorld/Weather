//
//  Float+Utils.swift
//  weather
//
//  Created by 김효원 on 02/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

// JSON Data Formatter
struct WTFormat {
    
    
    // MARK: - to 섭씨 화씨
    func toTemp(_ fahrenheit: Int) -> Int {
        var temp = fahrenheit
        if (UserDefaults.standard.bool(forKey: "isCelsius")){
            temp = Int(round(Double(fahrenheit - 32) / 1.8))
        }
        return temp
    }
    
    
    // MARK: - to 요일
    func toDayOfWeek(_ numberDay: NSNumber) -> DayOfWeek {
        let cal = Calendar(identifier: .gregorian)
        let date = Date(timeIntervalSince1970: (numberDay).doubleValue)
        let dayComp = cal.dateComponents([.weekday], from: date)
        
        return DayOfWeek(rawValue: dayComp.weekday! - 1)!
    }
    
    
    // MARK: - to 시간
    func toHour(_ numberDay: NSNumber) -> String {
        let cal = Calendar(identifier: .gregorian)
        let date = Date(timeIntervalSince1970: (numberDay).doubleValue)
        let dateComp = cal.dateComponents([.hour], from: date)
        
        let hour = (dateComp.hour! > 12 ? "오후 \(dateComp.hour! - 12)" : "오전 \(dateComp.hour!)")
        
        return hour
    }
    
    
    // MARK: - to 시간:분
    func toHourMinute(_ numberDay: NSNumber) -> String {
        let cal = Calendar(identifier: .gregorian)
        let date = Date(timeIntervalSince1970: (numberDay).doubleValue)
        let dateComp = cal.dateComponents([.hour, .minute], from: date)
        
        let hourMinute = (dateComp.hour! > 12 ? "오후 \(dateComp.hour! - 12)" : "오전 \(dateComp.hour!)") + ":\(dateComp.minute!)"
        
        return hourMinute
    }
    
    
    // MARK: - to %
    func toPercentString(_ number: NSNumber) -> String {
        return "\(Int(number.floatValue * 100))%"
    }
    
    
    // MARK: - to 기압(hPa)
    func toHPaString(_ number: NSNumber) -> String {
        return "\(round(number.doubleValue))hPa"
    }
    
    
    // MARK: - to 거리(km)
    func toKmString(_ number: NSNumber) -> String {
        return "\(number.floatValue)km"
    }
    
    
    // MARK: - to 도시
    func toCityString(_ string: String) -> String {
        let str = string.split(separator: "/")
        
        return str.count > 1 ? String(str[1]) : string
    }
}
