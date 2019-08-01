//
//  WTEnum.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation


// MARK: - TableView type
enum TableViewType: Int {
    case day = 0  // 일별 날씨 Table
}


// MARK: - CollectionView type
enum CollectionViewType: Int {
    case time = 0  // 시간별 날씨 Collection
    case detail = 1  // 날씨 상세 정보 Collection
}
