//
//  ViewController.swift
//  weather
//
//  Created by 김효원 on 31/07/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!  // 배경 색깔 뷰 (날씨에 따라 변경)
    @IBOutlet weak var currentTopView: UIView!  // 현재 위치 뷰
    @IBOutlet weak var scrollView: UIScrollView!  // 전체 스크롤 뷰
    @IBOutlet weak var timeCollectionView: UICollectionView!  // 시간별 날씨 collection
    @IBOutlet weak var noticeView: UIView!  // 오늘 날씨 안내문 뷰
    @IBOutlet weak var dayTableView: UITableView!  // 일별 날씨 테이블
    @IBOutlet weak var detailCollectionView: UICollectionView! // 상세 날씨 collection
    @IBOutlet weak var bottomView: UIView!
    
    var timeCollection: WTCollectionPagingView? = nil
    var dayTable: WTTableView? = nil
    var detailCollection: WTCollectionView? = nil
    var bgColor: UIColor = UIColor.gray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 초기 설정
        initMainView()
    }
    
    func initMainView(){
        // view color 설정
        bgColor = UIColor.gray
        setColorWithWeather(bgColor)
        
        // time Collection 설정
        timeCollection = .init(navigation: navigationController!, type: .time, collection: timeCollectionView, cellWidth: 90, backgroundColor: bgColor)
        timeCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        timeCollectionView.delegate = timeCollection
        timeCollectionView.dataSource = timeCollection
        
        // day Table 설정
        dayTable = .init(navigation: navigationController!, type: .day, table: dayTableView, cellWidth: dayTableView.frame.width, cellHeight: 39, backgroundColor: bgColor)
        dayTableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        dayTableView.delegate = dayTable
        dayTableView.dataSource = dayTable
        
        // detail Collection 설정
        detailCollection = .init(navigation: navigationController!, type: .detail, collection: detailCollectionView, backgroundColor: bgColor)
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
    
    
    // MARK: - 날씨 별 배경 색 설정
    func setColorWithWeather(_ weatherColor: UIColor){
        bgColor = weatherColor
        backgroundView.backgroundColor = weatherColor
        currentTopView.backgroundColor = weatherColor
        scrollView.backgroundColor = weatherColor
        timeCollectionView.backgroundColor = weatherColor
        noticeView.backgroundColor = weatherColor
        dayTableView.backgroundColor = weatherColor
        detailCollectionView.backgroundColor = weatherColor
        bottomView.backgroundColor = weatherColor
    }
}

