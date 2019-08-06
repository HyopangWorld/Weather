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
    var weatherList: Array<Dictionary<String, Any>>!  // 날씨 리스트
    var viewControllers: NSArray!
    
    var startIndex: Int = 0  // 페이지 뷰 시작 인덱스
    var index: Int = 0  // 현재 인덱스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 날씨 정보 가져오기
        updateWeather()
        
        // view 초기 설정
        initView()
    }
    
    
    // MARK: - init view
    func initView(){
        // Page View storyBoard와 연결
        self.mainPageVC = (self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController)
        self.mainPageVC.dataSource = self
        
        let startVC = self.viewControllerAtIndex(index: startIndex) as MainContentViewController
        viewControllers = NSArray(object: startVC)
        
        self.mainPageVC.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        self.mainPageVC.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChild(self.mainPageVC)
        self.view.addSubview(self.mainPageVC.view)
    }
    
    
    // MARK: - ListView 에게 전달 받은 데이터 없을 경우 api를 재호출한다.
    func updateWeather(){
        if weatherList == nil {
            weatherList = Array<Dictionary<String, Any>>()
            
            // Area List 가져오기
            let userDefaults = UserDefaults.standard
            areaList = userDefaults.dictionary(forKey: "areaList")!
            
            let areaIndex = userDefaults.array(forKey: "areaIndex") as! Array<String>
            for area in areaIndex{
                // 리스트 갯수만큼 순서대로 날씨 데이터 가져오기
                getWeatherApi(areaList[area] as! Dictionary<String, Any>)
            }
        }
    }
    
    
    // MARK: - 날씨데이터 가져오기
    func getWeatherApi(_ area: Dictionary<String, Any>){
        ApiClient().request("\(area["latitude"]!),\(area["logitude"]!)\(WTUrl.postFixUrl().getWeather)", success: { result in
            let weather = try! JSONSerialization.jsonObject(with: result, options: []) as! NSDictionary
            
            self.weatherList.append(ApiClient().getWeatherList(weather: weather, timezone: area["timezone"] as! String?))

        }, fail: { err in
            let alert = UIAlertController(title: "날씨를 확인할 수 없습니다", message: "인터넷에 접속할 수 없습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive, handler : nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
    }
}


// MARK: - Page View content set
extension MainViewController: UIPageViewControllerDataSource {
    
    // current VC
    func viewControllerAtIndex (index : Int) -> MainContentViewController {
        let contentVC : MainContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! MainContentViewController
        self.index = index
        
        let weather = weatherList[index]
        contentVC.currentVO = weather["currentVO"] as! WeatherCurrentVO
        contentVC.dailyVOList = weather["dailyVOList"] as! [WeatherDailyVO]
        contentVC.hourlyVOList = weather["hourlyVOList"] as! [WeatherHourlyVO]
        contentVC.pageCnt = weatherList.count
        contentVC.curPageCnt = index
        
        return contentVC
    }
    
    // before VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if( self.index == 0 ) {
            return nil
        }
        self.index -= 1
        
        return self.viewControllerAtIndex(index: self.index)
    }
    
    // after VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if( self.index == UserDefaults.standard.dictionary(forKey: "areaList")!.count - 1){
            return nil
        }
        self.index += 1
        
        return self.viewControllerAtIndex(index: self.index)
    }
    
    // view 갯수
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return areaList.count
    }
    
    
    // view 시작 index
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return startIndex
    }

}
