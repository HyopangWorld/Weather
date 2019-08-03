//
//  ViewController.swift
//  weather
//
//  Created by 김효원 on 31/07/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import CoreLocation

class MainContentViewController: UIViewController {
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
   
    var weatherVO = WeatherVO()
    var currentVO = WeatherCurrentVO()
    var hourlyVOList = Array<WeatherHourlyVO>()
    var dailyVOList = Array<WeatherDailyVO>()
    
    var hourlyCollection: WTCollectionPagingView? = nil
    var detailCollection: WTCollectionView? = nil
    var bgColor: UIColor = UIColor.gray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMainView()
    }
    
    
    // MARK: - 날씨 정보
    func initMainView(){
        // current View 설정
        setCurrentWeatherView()

        // view color 설정
        bgColor = UIColor.gray
        setColorWithWeather(bgColor)

        // time Collection 설정
        hourlyCollection = .init(type: .time, collection: hourlyCollectionView, cellWidth: 110, backgroundColor: bgColor, dataList: hourlyVOList)
        hourlyCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        hourlyCollectionView.delegate = hourlyCollection
        hourlyCollectionView.dataSource = hourlyCollection

        // day Table 설정
        dayTableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        dayTableView.delegate = self
        dayTableView.dataSource = self

        // detail Collection 설정
        detailCollection = .init(type: .detail, collection: detailCollectionView, backgroundColor: bgColor, dataList: currentVO.getCurrentDetailArray())
        detailCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCell")
        detailCollectionView.delegate = detailCollection
        detailCollectionView.dataSource = detailCollection
    }
    
    
    // MARK: - 날씨 정보 사이트로 이동
    @IBAction func webButtonDidTap(_ sender: Any) {
    }
    
    
    // MARK: - 리스트화면으로 이동
    @IBAction func listButtonDidTap(_ sender: Any) {
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


