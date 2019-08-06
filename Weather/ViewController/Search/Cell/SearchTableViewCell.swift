//
//  SearchTableViewCell.swift
//  weather
//
//  Created by 김효원 on 05/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * 지역 검색 결과 tableView cell
 */

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var areaLabel: UILabel!  // 검색 결과 라벨
    
    // 검색 결과 데이터 저장
    var timezone: String!   // 지역명
    var latitude: Double!   // 위도
    var longitude: Double!  // 경도
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        areaLabel.text = nil
        timezone = nil
        latitude = nil
        longitude = nil
    }
}
