//
//  TimeCollectionViewCell.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!  // 시간
    @IBOutlet weak var humLabel: UILabel!   // 습도
    @IBOutlet weak var icoLabel: UILabel!   // icon
    @IBOutlet weak var tempLabel: UILabel!   // 온도
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        humLabel.text = nil
        icoLabel.text = nil
        tempLabel.text = nil
    }
}
