//
//  DayTableViewCell.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 요일 별 날씨 table view cell
 */

import UIKit

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!      // 요일
    @IBOutlet weak var iconLabel: UILabel!     // 날씨 아이콘
    @IBOutlet weak var maxTempLabel: UILabel!  // 최고기온
    @IBOutlet weak var minTempLabel: UILabel!  // 최저기온
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        iconLabel.text = nil
        maxTempLabel.text = nil
        minTempLabel.text = nil
    }
    
}
