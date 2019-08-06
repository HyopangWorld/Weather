//
//  ListViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class ListViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var celBtn: UIButton!  // 섭씨 변환 버튼
    @IBOutlet weak var fahBtn: UIButton!  // 화씨 변환 버튼
    
    var areaList: Dictionary<String,Any>!  // 지역 리스트
    var weatherList: Array<Dictionary<String, Any>>!  // 날씨 리스트
    
    @IBAction func backListVC(segue : UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 날씨 정보 가져오기
        updateWeather()
        
        // view 초기 설정
        initView()
    }
    
    func initView(){
        //button 설정
        celBtn.isSelected = UserDefaults.standard.bool(forKey: "isCelsius")
        fahBtn.isSelected = !UserDefaults.standard.bool(forKey: "isCelsius")
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - 데이터 생성 여부에 따라 api를 재호출한다.
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

    
    // MARK: - Change to celsious
    @IBAction func celBtnDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        fahBtn.isSelected = !fahBtn.isSelected
        
        UserDefaults.standard.set(true, forKey: "isCelsius")
        UserDefaults.standard.synchronize()
        
        tableView.reloadData()
    }
    
    
    // MARK: - Change to fahenhit
    @IBAction func fahBtnDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        celBtn.isSelected = !celBtn.isSelected
        
        UserDefaults.standard.set(false, forKey: "isCelsius")
        UserDefaults.standard.synchronize()
        
        tableView.reloadData()
    }

}


// MARK: - setting Table VIew
extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 75
        
        return weatherList.count
    }
    
    // setting cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        let weather = weatherList[indexPath.row]
        let weatherVO = weather["weatherVO"] as! WeatherVO
        
        cell.icoLabel.text = weatherVO.icon!.getWeatherIcon()
        cell.areaLabel.text = weatherVO.timezone
        cell.tempLabel.text = "\(WTFormat().toTemp(weatherVO.temperature!))˚"
        
        return cell
    }
    
    
    // MARK: - cell 삭제
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (delete, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
            // 현재 위치 제외
            if indexPath.row == 0 {
                return
            }
            
            let userDefaults = UserDefaults.standard
            if var areaList = userDefaults.dictionary(forKey: "areaList") {
                //선택 cell 삭제
                areaList.removeValue(forKey: cell.areaLabel.text!)
                userDefaults.set(areaList, forKey: "areaList")
            }
            
            // index 순서 삭제
            var areaIndex = userDefaults.array(forKey: "areaIndex") as! Array<String>
            areaIndex.remove(at: areaIndex.firstIndex(of: cell.areaLabel.text!)!)
            userDefaults.set(areaIndex, forKey: "areaIndex")
            
            userDefaults.synchronize()
            
            // 리스트 삭제
            self.weatherList.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
        
        return [delete]
    }
    
    
    // MARK: - 메인 화면으로 이동한다. (선택한 cell이 첫 화면으로 보이게 된다.)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard!
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainVC.weatherList = Array<Dictionary<String, Any>>()
        mainVC.weatherList = self.weatherList
        mainVC.startIndex = indexPath.row
        
        self.present(mainVC, animated: true, completion: nil)
    }
}
