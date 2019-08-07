//
//  ListViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 지역 리스트 VC
 */

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var celBtn: UIButton!  // 섭씨 변환 버튼
    @IBOutlet weak var fahBtn: UIButton!  // 화씨 변환 버튼
    
    var areaList: Dictionary<String,Any>!             // 지역 리스트
    var weatherList: Array<Dictionary<String, Any>>!  // 날씨 리스트
    
    @IBAction func backListVC(segue : UIStoryboardSegue) {} // SearchView -> ListView BackButton(닫기)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    // MARK: - 검색 뷰로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goSearchSegue":
            let searchVC = segue.destination as! SearchTableViewController
            for vc in navigationController!.viewControllers {
                if vc is ListViewController {
                    // 날씨 데이터 전달 (api 중복 호출 방지)
                    searchVC.weatherList = (vc as! ListViewController).weatherList
                }
            }
            
        default:
            break
        }
    }
    
}


// MARK: - setting Table VIew
extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        
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
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let image = weatherVO.icon!.getBackgroundImg()
        imageView.image = image
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
    }
    
    
    // MARK: - cell 삭제
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (delete, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
            
            // 현재 위치 삭제 제외
            if indexPath.row == 0 {
                return
            }
            
            // 선택 cell 삭제
            let userDefaults = UserDefaults.standard
            if var areaList = userDefaults.dictionary(forKey: "areaList") {
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
        
        // pop MainView
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.isNavigationBarHidden = true
        
        self.present(navigationController, animated: true, completion: nil)
    }
}
