//
//  IntroViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 현재 위치 정보를 얻어오기 위한 Intro

import UIKit
import CoreLocation

class IntroViewController: UIViewController, CLLocationManagerDelegate{

    var locationManager: CLLocationManager?
    // 좌표 defaults, 카카오페이
    var curLatitude = 37.4790986
    var curLongitude = 126.8754323
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 위치 요청
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization() // 사용자 권한 요청
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let coor = locationManager!.location?.coordinate{
            curLatitude = coor.latitude
            curLongitude = coor.longitude
        }
        
        // 현재 좌표값 저장
        let userDefaults = UserDefaults.standard
        if var areaList = userDefaults.dictionary(forKey: "areaList") {
            areaList.updateValue([
                "latitude" : curLatitude,
                "logitude" : curLongitude
                ], forKey: "curLocation")
            
            userDefaults.set(areaList, forKey: "areaList")
            userDefaults.synchronize()
            
        } else {
            // 초기값 저장
            userDefaults.setValue([
                "curLocation" : [ "latitude" : curLatitude,
                                  "logitude" : curLatitude]]
                , forKey: "areaList")
            
            userDefaults.synchronize()
        }
        
        presentMainVC()
    }
    
    
    // MARK: - 메인화면으로 이동
    func presentMainVC(){
        let changeVC = UINavigationController.init(rootViewController: MainViewController())
        changeVC.isNavigationBarHidden = true
        
        // 메인 스토리보드 이동
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        navigationController?.present(controller, animated: true, completion: nil)
    }
}
