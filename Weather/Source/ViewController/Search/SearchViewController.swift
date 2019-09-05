//
//  SearchViewController.swift
//  weather
//
//  Created by 김효원 on 04/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 지역 검색 VC
 */

import Foundation
import UIKit
import MapKit

class SearchViewController: BaseViewController {
    var searchController: UISearchController!
    @IBOutlet weak var resultTable: UITableView!
    
    var matchingItems : [MKMapItem] = []  // 검색 결과 데이터
    
    var weatherList: Array<Dictionary<String, Any>>!  // 날씨 리스트
    
    var notice: String = ""      // 안내문
    var searchText: String = ""  // 검색어 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 초기 설정
        initView()
    }
    
    override func initView(){
        // 검색 화면 설정
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        self.definesPresentationContext = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // 검색 bar 설정
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.barStyle = .black
        resultTable.tableHeaderView = searchController.searchBar
        
        resultTable.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.separatorStyle = .none
    }
    
    // MARK: - 날씨데이터 가져오기 (새로운 리스트 업데이트)
    func getWeatherApi(_ area: Dictionary<String, Any>) -> Bool {
        var result = true
        ApiClient().request("\(area["latitude"]!),\(area["logitude"]!)\(WTUrl.postFixUrl().getWeather)", success: { result in
            
            let weather = try! JSONSerialization.jsonObject(with: result, options: []) as! NSDictionary
            self.weatherList.append(ApiClient().getWeatherList(weather: weather, timezone: area["timezone"] as! String?))
            
        }, fail: { err in
            
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
    
    
    // MARK: - 리스트 화면으로 이동한다.
    func goListVC(){
        let storyboard = self.storyboard!
        let listVC = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listVC.weatherList = self.weatherList
        
        // pop ListView
        let navigationController = UINavigationController(rootViewController: listVC)
        navigationController.isNavigationBarHidden = true
        
        self.present(navigationController, animated: true, completion: nil)
    }

}


// MARK: - 검색
extension SearchViewController : UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    // MARK: - 검색 결과 업데이트
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        self.searchText = searchBarText
        
        // 안내문 출력
        self.matchingItems = []
        notice = "도시 확인 중..."
        self.resultTable.reloadData()
        
        // 이전 perform 삭제
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchResults(_:)), object: nil)
        // 1초 뒤 검색
        self.perform(#selector(self.searchResults(_:)), with: nil, afterDelay: 1.0)
    }
    
    
    //MARK: - 검색
    @objc func searchResults(_:String){
        
        // 검색창이 빈 경우 결과 테이블 지우기
        if searchText == "" {
            self.matchingItems = []
            notice = ""
            self.resultTable.reloadData()
            
            return
        }
        
        //MK 요청
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                self.matchingItems = []
                self.notice = "검색 결과가 없습니다."
                self.resultTable.reloadData()
                
                return
            }
            
            self.matchingItems = response.mapItems
            self.filterSearchResults()
            
            self.resultTable.reloadData()
        }
    }
    
    
    //MARK: - 국가 단위의 검색 제외 필터링
    func filterSearchResults(){
        var count = 0
        for item in matchingItems {
            guard item.placemark.administrativeArea != nil else {
                matchingItems.remove(at: count)
                count -= 1
                
                return
            }
            if (count < matchingItems.count){ count += 1 }
        }
        if matchingItems.count == 0 {
            self.matchingItems = []
            self.notice = "검색 결과가 없습니다."
            self.resultTable.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - 검색 결과 테이블 뷰 cell
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultTable.rowHeight = 50
        return matchingItems.count == 0 ? 1 : matchingItems.count
    }
    
    // setting cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        
        if matchingItems.count != 0 {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.areaLabel?.text = selectedItem.title
            cell.areaLabel?.tintColor = UIColor.white
            cell.timezone = selectedItem.thoroughfare ?? selectedItem.subLocality ?? selectedItem.locality ?? selectedItem.administrativeArea ?? selectedItem.country
            cell.latitude = selectedItem.coordinate.latitude
            cell.longitude = selectedItem.coordinate.longitude
            cell.isUserInteractionEnabled = true
            
        } else {
            cell.areaLabel?.text = self.notice
            cell.areaLabel?.tintColor = UIColor.lightGray
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
 
    
    // MARK: - cell 선택 시, 정보 저장 및 리스트 뷰 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        
        // 검색 화면 비활성화
        searchController.isActive = false
        
        // 지역 정보 저장
        let userDefaults = UserDefaults.standard
        if var areaList = userDefaults.dictionary(forKey: "areaList") {
            areaList.updateValue([
                "timezone" : selectedCell.timezone!,
                "latitude" : selectedCell.latitude!,
                "logitude" : selectedCell.longitude!
                ], forKey: selectedCell.timezone)
            
            userDefaults.set(areaList, forKey: "areaList")
        }
        userDefaults.synchronize()
        
        // 날씨 리스트 업데이트 추가 (api 호출)
        let _ = getWeatherApi([
            "timezone" : selectedCell.timezone!,
            "latitude" : selectedCell.latitude!,
            "logitude" : selectedCell.longitude!])
        
        // 리스트로 이동
        self.goListVC()
    }
}
