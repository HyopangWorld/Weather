//
//  MainViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 현재 위치 및 지역 날씨를 보여주는 Main VC
 */

import UIKit

class MainViewController: BaseViewController {
    var mainPageVC : UIPageViewController! // page vc
    var viewControllers: NSArray!          // page content views array
    
    var areaList: Dictionary<String,Any>!             // 지역 리스트
    var weatherList: Array<Dictionary<String, Any>>!  // 날씨 리스트
    
    var startIndex: Int = 0  // 페이지 뷰 시작 인덱스
    var index: Int = 0       // 현재 인덱스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 날씨 정보 가져오기
        updateWeather()
        
        // view 초기 설정
        initView()
    }
    
    override func initView(){
        
        mainPageVC = (self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController)
        mainPageVC.dataSource = self
        
        // 시작 index 설정
        let startVC = self.viewControllerAtIndex(index: startIndex) as MainContentViewController
        viewControllers = NSArray(object: startVC)
        
        mainPageVC.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        mainPageVC.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChild(mainPageVC)
        self.view.addSubview(mainPageVC.view)
    }
    
    
    // MARK: - 전달 받은 데이터가 없을 경우 api를 재호출한다.
    func updateWeather(){
        
        // Area List 가져오기
        let userDefaults = UserDefaults.standard
        areaList = userDefaults.dictionary(forKey: "areaList")!
        let areaIndex = userDefaults.array(forKey: "areaIndex") as! Array<String>
        
        if weatherList == nil {
            weatherList = Array<Dictionary<String, Any>>()
            
            for area in areaIndex {
                // 리스트 갯수만큼 순서대로 날씨 데이터 가져오기 (에러 발생 시 중지)
                if !getWeatherApi(areaList[area] as! Dictionary<String, Any>) {
                    return
                }
            }
        }
    }
    
    
    // MARK: - 날씨데이터 가져오기
    func getWeatherApi(_ area: Dictionary<String, Any>) -> Bool {
        
        var result = true
        
        showIndicator()
        
        guard let latitude = area["latitude"], let logitude = area["logitude"], let timezone = area["timezone"] else {
            return false
        }
        
        ApiClient().request("\(latitude),\(logitude)\(WTUrl.postFixUrl().getWeather)", success: { result in
            
            self.hideIndicator()
            
            let weather = try! JSONSerialization.jsonObject(with: result, options: []) as! NSDictionary
            self.weatherList.append(ApiClient().getWeatherList(weather: weather, timezone: "\(timezone)"))
            
        }, fail: { err in
            
            self.hideIndicator()
            
            // 기본 데이터 입력
            self.weatherList.append([
                "weatherVO" : WeatherVO(),
                "currentVO" : CurrentVO(),
                "dailyVOList" : Array<DailyVO>(),
                "hourlyVOList" : Array<HourlyVO>() ])
            
            // 장애 뷰로 이동 (root view 전환)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let errVC = storyboard.instantiateViewController(withIdentifier: "ErrorPageViewController")
            
            let navigationController = UINavigationController.init(rootViewController: errVC)
            navigationController.isNavigationBarHidden = true
            
            self.present(navigationController, animated: true, completion: nil)
            
            result = false
        })
        
        return result
    }
}


// MARK: - Page View content set
extension MainViewController: UIPageViewControllerDataSource {
    
    // current VC
    func viewControllerAtIndex (index : Int) -> MainContentViewController {
        
        let contentVC : MainContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! MainContentViewController
        self.index = index
        
        let weather = weatherList[index]
        contentVC.currentVO = weather["currentVO"] as! CurrentVO
        contentVC.dailyVOList = weather["dailyVOList"] as! [DailyVO]
        contentVC.hourlyVOList = weather["hourlyVOList"] as! [HourlyVO]
        contentVC.pageCnt = weatherList.count
        contentVC.curPageCnt = index
        
        return contentVC
    }
    
    // before VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if( index == 0 ) {
            return nil
        }
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
    }
    
    // after VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if( index == UserDefaults.standard.dictionary(forKey: "areaList")!.count - 1){
            return nil
        }
        index += 1
        
        return self.viewControllerAtIndex(index: index)
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
