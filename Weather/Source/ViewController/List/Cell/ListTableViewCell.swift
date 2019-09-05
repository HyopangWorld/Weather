//
//  ListTableViewCell.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 지역 리스트 tableView cell
 */

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var icoLabel: UILabel!   // 날씨 아이콘
    @IBOutlet weak var areaLabel: UILabel!  // 지역명
    @IBOutlet weak var tempLabel: UILabel!  // 현재 온도
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        areaLabel.text = nil
        icoLabel.text = nil
        tempLabel.text = nil
    }
}
