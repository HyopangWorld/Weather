//
//  MainViewController+DayTable.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 공통 TableView DataSource, Delegate

import Foundation
import UIKit

class WTTableView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var navigation: UINavigationController? = nil
    
    var type: TableViewType? = nil  // TableView 생성 Type
    var table: UITableView? = nil
    var backgroundColor: UIColor? = nil
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    init(navigation: UINavigationController, type: TableViewType, table: UITableView, cellWidth: CGFloat, cellHeight: CGFloat, backgroundColor: UIColor){
        super.init(nibName: nil, bundle: nil)
        self.navigation = navigation
        self.type = type
        self.table = table
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // setting section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        table?.rowHeight = cellHeight
        
        return 7
    }
    
    // setting cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch type {
        case .day?:
            cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayTableViewCell
        case .none: break
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = backgroundColor
        
        return cell
    }
}
