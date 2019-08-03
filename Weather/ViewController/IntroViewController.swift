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
        // 좌표 defaults, 카카오페이
        var latitude = 37.4790986
        var longitude = 126.8754323
        
        if let coor = locationManager!.location?.coordinate{
            latitude = coor.latitude
            longitude = coor.longitude
        }
        
        // Appdelgate Share 데이터 저장
        let appDel = UIApplication.shared.delegate as? AppDelegate
        
        appDel?.curLocation = [
            "latitude" : latitude,
            "longitude" : longitude
        ]
        
        presentMainVC()
    }
    
    
    // MARK: - 메인화면으로 이동
    func presentMainVC(){
        let mainVC = UINavigationController.init(rootViewController: MainViewController())
        mainVC.isNavigationBarHidden = true
        
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
