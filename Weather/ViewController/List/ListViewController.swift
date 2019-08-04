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
    
    // 리스트 뷰 데이터
    var areaInfoList = Array<Dictionary<String, Any>>()
    
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
        
        //select Button Notification 설정
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.goWithIndexMainVC),
                                               name: NSNotification.Name(rawValue: "goWithIndexMainVC"),
                                               object: nil)
    }

    
    // MARK: - Change to celsious
    @IBAction func celBtnDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        fahBtn.isSelected = !fahBtn.isSelected
        UserDefaults.standard.set(true, forKey: "isCelsius")
        
        tableView.reloadData()
    }
    
    
    // MARK: - Change to fahenhit
    @IBAction func fahBtnDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        celBtn.isSelected = !celBtn.isSelected
        UserDefaults.standard.set(false, forKey: "isCelsius")
        
        tableView.reloadData()
    }
    
    
    // MARK: - 메인 화면으로 이동한다. (선택한 cell이 첫 화면으로 보이게 된다.)
    @objc func goWithIndexMainVC(){
        let storyboard = self.storyboard!
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainVC.startIndex = tableView.indexPathForSelectedRow!.row
        self.present(mainVC, animated: true, completion: nil)
    }
}


// MARK: - setting Table VIew
extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 75
        
        return areaInfoList.count
    }
    
    // setting cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        
        let areaInfo = areaInfoList[indexPath.row]
        cell.icoLabel.text = (areaInfo["icon"] as! WeatherIcon).getWeatherIcon()
        cell.areaLabel.text = areaInfo["timezone"] as? String
        cell.tempLabel.text = "\(WTFormat().toTemp((areaInfo["temp"] as? Int)!))˚"
        
        return cell
    }
    
}
