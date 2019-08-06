//
//  SearchViewController.swift
//  weather
//
//  Created by 김효원 on 04/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchTableViewController: UITableViewController {
    var searchController = UISearchController()
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cancleBtn: UIButton!
    
    var matchingItems : [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 초기 설정
        initView()
    }
    
    func initView(){
        // 검색 화면 설정
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        self.definesPresentationContext = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 검색 bar 설정
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
        
        searchView.addSubview(searchController.searchBar)
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        tableView.separatorStyle = .none
    }
    
    
    // MARK: - 리스트 화면으로 이동한다. (새로운 리스트 업데이트)
    func goListVC(){
        searchController.isActive = false
        let storyboard = self.storyboard!
        let listVC = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.present(listVC, animated: true, completion: nil)
    }
    
}


// MARK: - 검색
extension SearchTableViewController : UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    // MARK: - 검색 결과 업데이트
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.filterSearchResults()
            self.tableView.reloadData()
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
    }
}


// MARK: - 검색 결과 테이블 뷰
extension SearchTableViewController {
    
    // setting section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 50
        return matchingItems.count
    }
    
    // setting cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.areaLabel?.text = selectedItem.title
        cell.timezone = selectedItem.thoroughfare ?? selectedItem.subLocality ?? selectedItem.locality ?? selectedItem.administrativeArea ?? selectedItem.country
        cell.latitude = selectedItem.coordinate.latitude
        cell.longitude = selectedItem.coordinate.longitude
        
        cell.backgroundColor = UIColor(displayP3Red: 47/255, green: 47/255, blue: 41/255, alpha: 1.0)
        cell.tintColor = UIColor.white
        
        return cell
    }
 
    
    // MARK: - cell 정보 저장 및 리스트 뷰 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        
        let userDefaults = UserDefaults.standard
        if var areaList = userDefaults.dictionary(forKey: "areaList") {
            areaList.updateValue([
                "timezone" : selectedCell.timezone!,
                "latitude" : selectedCell.latitude!,
                "logitude" : selectedCell.longitude!
                ], forKey: selectedCell.timezone)
            
            userDefaults.set(areaList, forKey: "areaList")
        }
        
        // index 순서 저장
        var areaIndex = userDefaults.array(forKey: "areaIndex") as! Array<String>
        // 중복 제거
        if areaIndex.firstIndex(of: selectedCell.timezone!) == nil {
            areaIndex.append(selectedCell.timezone!)
            userDefaults.set(areaIndex, forKey: "areaIndex")
        }
        
        userDefaults.synchronize()
        
        self.goListVC()
    }
}
