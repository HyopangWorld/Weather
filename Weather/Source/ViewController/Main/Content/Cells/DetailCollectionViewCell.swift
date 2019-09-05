//
//  DetailCollectionViewCell.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 날씨 상세 정보 collection view cell

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!  // 항목 명
    @IBOutlet weak var infoLabel: UILabel!   // 정보
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        infoLabel.text = nil
    }
}
