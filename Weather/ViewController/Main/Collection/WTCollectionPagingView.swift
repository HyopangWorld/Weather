//
//  WTCollectionView + Paging.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// Paging CollectionView, WTCollectionView를 상속받는다. (Weather Hourly View)

import Foundation
import UIKit

class WTCollectionPagingView: WTCollectionView {
    
    init(navigation: UINavigationController, type: CollectionViewType, collection: UICollectionView, cellWidth: CGFloat, backgroundColor: UIColor, dataList: Array<Any>) {
        super.init(navigation: navigation, type: type, collection: collection, backgroundColor: backgroundColor, dataList: dataList)
        self.cellWidth = cellWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - set cell size
    override func setCellSize(){
        cellHeight = collection!.frame.height
    }
    
    
    // MARK: - cell 페이징
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = self.collection!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
            
        }
        
        // 페이징 될 좌표값을 targetContentOffset에 대입
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
