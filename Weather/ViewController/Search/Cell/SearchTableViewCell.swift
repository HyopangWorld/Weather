//
//  SearchTableViewCell.swift
//  weather
//
//  Created by 김효원 on 05/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var areaLabel: UILabel!
    
    var timezone: String!
    var latitude: Double!
    var longitude: Double!
    
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
