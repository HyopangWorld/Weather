//
//  ViewController.swift
//  weather
//
//  Created by 김효원 on 31/07/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!  // 배경 색깔 뷰 (날씨에 따라 변경)
    @IBOutlet weak var currentTopView: UIView!  // 현재 위치 뷰
    @IBOutlet weak var scrollView: UIScrollView!  // 전체 스크롤 뷰
    @IBOutlet weak var hourlyCollectionView: UICollectionView!  // 시간별 날씨 collection
    @IBOutlet weak var totalSummaryView: UIView!   // 날씨 총 요약문 뷰
    @IBOutlet weak var dayTableView: UITableView!  // 일별 날씨 테이블
    @IBOutlet weak var detailCollectionView: UICollectionView! // 상세 날씨 collection
    @IBOutlet weak var bottomView: UIView!
    
    //현재 위치 뷰 Items
    @IBOutlet weak var curPosLabel: UILabel!
    @IBOutlet weak var curWetLabel: UILabel!
    @IBOutlet weak var curTempLabel: UILabel!
    
    @IBOutlet weak var totalSummaryLabel: UILabel!  // 날씨 총 요약문
    
    var curLatitude: Double = 0.0
    var curLongitude: Double = 0.0
    
    var weatherVO = WeatherVO()
    var currentVO = WeatherCurrentVO()
    var hourlyVOList = Array<WeatherHourlyVO>()
    var dailyVOList = Array<WeatherDailyVO>()
    
    var hourlyCollection: WTCollectionPagingView? = nil
    var detailCollection: WTCollectionView? = nil
    var bgColor: UIColor = UIColor.gray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 위치 정보 가져오기
        let appDel = UIApplication.shared.delegate as? AppDelegate
        curLatitude = appDel?.curLocation!["latitude"] as! Double
        curLongitude = appDel?.curLocation!["longitude"] as! Double
        
        // 데이터 호출
        getWeatherInfo()
    }

    
    // MARK: - 날씨 정보 API
    func getWeatherInfo(){
        ApiClient().request("\(curLatitude),\(curLongitude)\(WTUrl.postFixUrl().getWeather)", success: { result in
            //JSON 객체 파싱하기
            do {
                let weather = try! JSONSerialization.jsonObject(with: result, options: []) as! NSDictionary
                
                // 날씨 위치
                self.weatherVO.latitude = weather["latitude"] as? Double
                self.weatherVO.logitude = weather["logitude"] as? Double
                self.weatherVO.timezone = weather["timezone"] as? String
                
                // 현재 날씨
                let currently = weather["currently"] as! NSDictionary
                self.currentVO.summary = currently["summary"] as? String
                self.currentVO.icon = WeatherIcon(rawValue: (currently["icon"] as? String)!)
                self.currentVO.temperature = WTFormat().toCelsius(currently["temperature"] as! NSNumber) // 현재 온도
                self.currentVO.humidity = WTFormat().toPercentString(currently["humidity"] as! NSNumber) // 습도
                self.currentVO.pressure = WTFormat().toHPaString(currently["pressure"] as! NSNumber) // 기압
                self.currentVO.cloudCover = WTFormat().toPercentString(currently["cloudCover"] as! NSNumber) // 구름
                self.currentVO.uvIndex = (currently["uvIndex"] as! NSNumber).intValue // 자외선 지수
                self.currentVO.visibility = WTFormat().toKmString(currently["visibility"] as! NSNumber)  // 가시거리
                self.currentVO.ozone = (currently["ozone"] as! NSNumber).doubleValue // 오존
                
                //일별 날씨 (7)
                let daily = weather["daily"] as! NSDictionary
                
                for items in daily["data"] as! NSArray {
                    let dailyList = items as! NSDictionary
                    let dailyVO = WeatherDailyVO()
                    
                    if(self.dailyVOList.count == 0){
                        self.currentVO.sunsetTime =  WTFormat().toHourMinute(dailyList["sunsetTime"] as! NSNumber)
                        self.currentVO.sunriseTime =  WTFormat().toHourMinute(dailyList["sunriseTime"] as! NSNumber)
                        self.currentVO.temperatureMin = WTFormat().toCelsius(dailyList["temperatureMin"] as! NSNumber)
                        self.currentVO.temperatureMax = WTFormat().toCelsius(dailyList["temperatureMax"] as! NSNumber)
                        self.currentVO.weekSummary = daily["summary"] as? String
                    }
                    
                    dailyVO.dailyTime =  WTFormat().toDayOfWeek(dailyList["sunsetTime"] as! NSNumber)
                    dailyVO.icon = WeatherIcon(rawValue: (dailyList["icon"] as? String)!)
                    dailyVO.temperatureMin = WTFormat().toCelsius(dailyList["temperatureMin"] as! NSNumber)
                    dailyVO.temperatureMax = WTFormat().toCelsius(dailyList["temperatureMax"] as! NSNumber)
                    
                    self.dailyVOList.append(dailyVO)
                    if(self.dailyVOList.count > 6){
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
                    hourlyVO.temperature = WTFormat().toCelsius(hourlyList["temperature"] as! NSNumber)
                    hourlyVO.humidity = WTFormat().toPercentString(hourlyList["humidity"] as! NSNumber) // 습도
                    
                    self.hourlyVOList.append(hourlyVO)
                    if(self.hourlyVOList.count > 25){
                        break
                    }
                }
            }
            
            // UI 초기 설정
            self.initMainView()
            
        }, fail: { err in
            let alert = UIAlertController(title: "날씨를 확인할 수 없습니다", message: "인터넷에 접속할 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive, handler : nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    // MARK: - 날씨 정보
    func initMainView(){
        // current View 설정
        setCurrentWeatherView()
        
        // view color 설정
        bgColor = UIColor.gray
        setColorWithWeather(bgColor)
        
        // time Collection 설정
        hourlyCollection = .init(navigation: navigationController!, type: .time, collection: hourlyCollectionView, cellWidth: 110, backgroundColor: bgColor, dataList: hourlyVOList)
        hourlyCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        hourlyCollectionView.delegate = hourlyCollection
        hourlyCollectionView.dataSource = hourlyCollection
        
        // day Table 설정
        dayTableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        dayTableView.delegate = self
        dayTableView.dataSource = self
        
        // detail Collection 설정
        detailCollection = .init(navigation: navigationController!, type: .detail, collection: detailCollectionView, backgroundColor: bgColor, dataList: currentVO.getCurrentDetailArray())
        detailCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCell")
        detailCollectionView.delegate = detailCollection
        detailCollectionView.dataSource = detailCollection
    }
    
    
    // MARK: - 날씨 정보 사이트로 이동
    @IBAction func webButtonDidTap(_ sender: Any) {
    }
    
    
    // MARK: - 검색화면으로 이동
    @IBAction func searchButtonDidTap(_ sender: Any) {
    }
    
    
    // MARK: - 현재 날씨 뷰 설정
    func setCurrentWeatherView(){
        curPosLabel.text = weatherVO.timezone
        curWetLabel.text = currentVO.summary
        curTempLabel.text = "\(currentVO.temperature!)˚"
        totalSummaryLabel.text = "주간 : 날씨는 \(currentVO.weekSummary!)"
    }
    
    // MARK: - 날씨 별 배경 색 설정
    func setColorWithWeather(_ weatherColor: UIColor){
        bgColor = weatherColor
        backgroundView.backgroundColor = weatherColor
        currentTopView.backgroundColor = weatherColor
        scrollView.backgroundColor = weatherColor
        hourlyCollectionView.backgroundColor = weatherColor
        totalSummaryView.backgroundColor = weatherColor
        dayTableView.backgroundColor = weatherColor
        detailCollectionView.backgroundColor = weatherColor
        bottomView.backgroundColor = weatherColor
    }
}


