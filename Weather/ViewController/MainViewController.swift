//
//  MainViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainPageVC : UIPageViewController!
    
    var areaList: Dictionary<String,Any>!  // 지역 리스트
    var weatherList = Array<Dictionary<String, Any>>()  // 지역마다의 날씨 리스트
    var areaInfoList = Array<Dictionary<String, Any>>()  // 지역 정보 리스트
    
    var startIndex: Int = 0  // 페이지 뷰 시작 인덱스
    var index: Int = 0  // 현재 인덱스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Area List 가져오기
        let userDefaults = UserDefaults.standard
        areaList = userDefaults.dictionary(forKey: "areaList")!
        for area in areaList{
            // 리스트 갯수만큼 날씨 데이터 가져오기
            getWeatherInfo(area.value as! Dictionary<String, Double>)
        }
        
        // view 초기 설정
        initView()
        
    }
    
    
    // MARK: - init view
    func initView(){
        // Page View storyBoard와 연결
        self.mainPageVC = (self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController)
        self.mainPageVC.dataSource = self
        
        let startVC = self.viewControllerAtIndex(index: startIndex) as MainContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.mainPageVC.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        self.mainPageVC.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChild(self.mainPageVC)
        self.view.addSubview(self.mainPageVC.view)
    }
    
    
    // MARK: - 날씨데이터 가져오기
    func getWeatherInfo(_ area: Dictionary<String, Double>){
        ApiClient().request("\(area["latitude"]!),\(area["logitude"]!)\(WTUrl.postFixUrl().getWeather)", success: { result in
            //JSON 객체 파싱하기
            do {
                let weather = try! JSONSerialization.jsonObject(with: result, options: []) as! NSDictionary
                
                let weatherVO = WeatherVO()
                let currentVO = WeatherCurrentVO()
                var hourlyVOList = Array<WeatherHourlyVO>()
                var dailyVOList = Array<WeatherDailyVO>()
                
                // 날씨 위치
                weatherVO.latitude = weather["latitude"] as? Double
                weatherVO.logitude = weather["logitude"] as? Double
                weatherVO.timezone = weather["timezone"] as? String
                
                // 현재 날씨
                let currently = weather["currently"] as! NSDictionary
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
                        currentVO.sunsetTime =  WTFormat().toHourMinute(dailyList["sunsetTime"] as! NSNumber)
                        currentVO.sunriseTime =  WTFormat().toHourMinute(dailyList["sunriseTime"] as! NSNumber)
                        currentVO.temperatureMin = Int(round((dailyList["temperatureMin"] as! NSNumber).doubleValue))
                        currentVO.temperatureMax = Int(round((dailyList["temperatureMax"] as! NSNumber).doubleValue))
                        currentVO.weekSummary = daily["summary"] as? String
                    }
                    
                    dailyVO.dailyTime =  WTFormat().toDayOfWeek(dailyList["sunsetTime"] as! NSNumber)
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
                
                self.weatherList.append([
                    "weatherVO" : weatherVO,
                    "currentVO" : currentVO,
                    "dailyVOList" : dailyVOList,
                    "hourlyVOList" : hourlyVOList
                ])
                
                self.areaInfoList.append([
                    "timezone" : WTFormat().toCityString(weatherVO.timezone!),
                    "icon" : currentVO.icon!,
                    "temp" : currentVO.temperature!
                ])
            }
        }, fail: { err in
            let alert = UIAlertController(title: "날씨를 확인할 수 없습니다", message: "인터넷에 접속할 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive, handler : nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
    }
}


// MARK: - Page View content set
extension MainViewController: UIPageViewControllerDataSource{
    
    // current VC
    func viewControllerAtIndex (index : Int) -> MainContentViewController {
        let vc : MainContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! MainContentViewController
        self.index = index
        
        let weather = weatherList[index]
        vc.areaInfoList = areaInfoList
        vc.weatherVO = weather["weatherVO"] as! WeatherVO
        vc.currentVO = weather["currentVO"] as! WeatherCurrentVO
        vc.dailyVOList = weather["dailyVOList"] as! [WeatherDailyVO]
        vc.hourlyVOList = weather["hourlyVOList"] as! [WeatherHourlyVO]
        
        return vc
    }
    
    // before VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return (index - 1) <= 0 ? nil : self.viewControllerAtIndex(index: self.index - 1)
    }
    
    // after VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return (index + 1) >= self.areaList.count ?  nil : self.viewControllerAtIndex(index: self.index + 1)
    }
    
    // view 갯수
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.areaList.count
    }
    
    
    // view 시작 index
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
