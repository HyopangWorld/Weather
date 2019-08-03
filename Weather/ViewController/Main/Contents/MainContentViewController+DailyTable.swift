//
//  MainContentViewController+DayTable.swift
//  weather
//
//  Created by 김효원 on 02/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// TableView DataSource, Delegate (Weather Daily View)

import Foundation
import UIKit

extension MainContentViewController: UITableViewDataSource, UITableViewDelegate{
    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dayTableView.rowHeight = 39
        
        return dailyVOList.count
    }
    
    // setting cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayTableViewCell
        
        cell.dayLabel.text = dailyVOList[indexPath.row].dailyTime!.getDayOfWeekString()
        cell.iconLabel.text = dailyVOList[indexPath.row].icon!.getWeatherIcon()
        cell.minTempLabel.text = "\(dailyVOList[indexPath.row].temperatureMin!)˚"
        cell.maxTempLabel.text = "\(dailyVOList[indexPath.row].temperatureMax!)˚"
        
        cell.selectionStyle = .none
        cell.backgroundColor = dayTableView.backgroundColor
        
        return cell
    }
}
