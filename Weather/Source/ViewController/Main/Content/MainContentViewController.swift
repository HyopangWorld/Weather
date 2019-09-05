//
//  ViewController.swift
//  weather
//
//  Created by 김효원 on 31/07/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * Main Page View에 들어가는 Content View
 */

import UIKit
import CoreLocation
import WebKit

class MainContentViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!                  // 배경 색깔 뷰 (날씨에 따라 변경)
    @IBOutlet weak var hourlyCollectionView: UICollectionView!  // 시간별 날씨 collection
    @IBOutlet weak var dayTableView: UITableView!               // 일별 날씨 테이블
    @IBOutlet weak var detailCollectionView: UICollectionView!  // 상세 날씨 collection
    
    //현재 위치 뷰 Items
    @IBOutlet weak var curPosLabel: UILabel!        // 위치
    @IBOutlet weak var curWetLabel: UILabel!        // 날씨 summary
    @IBOutlet weak var curTempLabel: UILabel!       // 기온
    @IBOutlet weak var totalSummaryLabel: UILabel!  // 날씨 총 요약문
    @IBOutlet weak var curTimeLabel: UILabel!       // 요일
    @IBOutlet weak var maxTempLabel: UILabel!       // 최고기온
    @IBOutlet weak var minTempLabel: UILabel!       // 최저기온
    
    // 하단 page control
    @IBOutlet weak var pageControl: UIPageControl!
    var pageCnt: Int!      // 총 페이지 수
    var curPageCnt: Int!   // 현재 페이지 index
    
    var currentVO = CurrentVO()            // 현재 날씨 정보 VO
    var hourlyVOList = Array<HourlyVO>()   // 시간별 날씨 정보 VO List
    var dailyVOList = Array<DailyVO>()     // 요일별 날씨 정보 VO List
    
    // collectionView
    var hourlyCollection: WTCollectionPagingView!  // 시간별 날씨 page collection 객체
    var detailCollection: WTCollectionView!        // 상세 날씨 collection 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View 초기 설정
        self.initView()
    }
    
    func initView(){
        // current View 설정
        setCurrentWeatherView()

        // time Collection 설정
        hourlyCollection = .init(type: .time, collection: hourlyCollectionView, cellWidth: 110, dataList: hourlyVOList)
        hourlyCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        hourlyCollectionView.delegate = hourlyCollection
        hourlyCollectionView.dataSource = hourlyCollection

        // day Table 설정
        dayTableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        dayTableView.delegate = self
        dayTableView.dataSource = self

        // detail Collection 설정
        detailCollection = .init(type: .detail, collection: detailCollectionView, dataList: currentVO.getCurrentDetailArray())
        detailCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCell")
        detailCollectionView.delegate = detailCollection
        detailCollectionView.dataSource = detailCollection
        
        //page control 설정
        pageControl.numberOfPages = pageCnt
        pageControl.currentPage = curPageCnt
    }
    
    
    // MARK: - 날씨 정보 사이트로 이동
    @IBAction func webButtonDidTap(_ sender: Any) {
        if var areaList = UserDefaults.standard.dictionary(forKey: "areaList") {
            let curLocation = areaList["curLocation"] as! Dictionary<String, Double>
            
            guard let url = URL(string: "\(WTUrl.weatherWebUrl)\(curLocation["latitude"]!),\(curLocation["logitude"]!)\(WTUrl.postFixUrl().getWeatherWeb)"), UIApplication.shared.canOpenURL(url) else {
                let alert = UIAlertController(title: "페이지를 연결할 수 없음", message: "네트워크 연결을 확인해주세요.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(alertAction)
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    // MARK: - 리스트 뷰로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goListSegue":
            let listVC = segue.destination as! ListViewController
            for vc in navigationController!.viewControllers {
                if vc is MainViewController {
                    listVC.weatherList = (vc as! MainViewController).weatherList
                }
            }
        default:
            break
        }
    }
    
    
    // MARK: - 현재 날씨 뷰 설정
    func setCurrentWeatherView(){
        curPosLabel.text = currentVO.timezone
        curWetLabel.text = currentVO.summary
        curTempLabel.text = "\(WTFormat().toTemp(currentVO.temperature!))˚"
        curTimeLabel.text = currentVO.currentTime!.getDayOfWeekString()
        maxTempLabel.text = "\(WTFormat().toTemp(currentVO.temperatureMax!))˚"
        minTempLabel.text = "\(WTFormat().toTemp(currentVO.temperatureMin!))˚"
        
        totalSummaryLabel.text = "주간 : 날씨는 \(currentVO.weekSummary!)"
        
        backgroundView.backgroundColor = UIColor(patternImage: currentVO.icon!.getBackgroundImg())
    }
}


