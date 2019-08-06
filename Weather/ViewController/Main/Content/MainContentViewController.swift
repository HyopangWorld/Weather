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
    @IBOutlet weak var curTimeLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    // 하단 page control
    @IBOutlet weak var pageControl: UIPageControl!
    var pageCnt: Int!
    var curPageCnt: Int!
    
    var currentVO = WeatherCurrentVO()
    var hourlyVOList = Array<WeatherHourlyVO>()
    var dailyVOList = Array<WeatherDailyVO>()
    var bgColor: UIColor = UIColor.gray
    
    // collectionView
    var hourlyCollection: WTCollectionPagingView!
    var detailCollection: WTCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View 초기 설정
        self.initView()
    }
    
    func initView(){
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
        
        //page control 설정
        pageControl.numberOfPages = pageCnt
        pageControl.currentPage = curPageCnt
    }
    
    
    // MARK: - 날씨 정보 사이트로 이동
    @IBAction func webButtonDidTap(_ sender: Any) {
        
    }
    
    // MARK: - 리스트 뷰로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goListSegue":
            let listVC = segue.destination as! ListViewController
            for vc in navigationController!.viewControllers {
                if vc is MainViewController{
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
        curTempLabel.text = "\(WTFormat().toTemp(currentVO.temperature))˚"
        curTimeLabel.text = currentVO.currentTime.getDayOfWeekString()
        maxTempLabel.text = "\(WTFormat().toTemp(currentVO.temperatureMax))˚"
        minTempLabel.text = "\(WTFormat().toTemp(currentVO.temperatureMin))˚"
        
        totalSummaryLabel.text = "주간 : 날씨는 \(currentVO.weekSummary)"
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


