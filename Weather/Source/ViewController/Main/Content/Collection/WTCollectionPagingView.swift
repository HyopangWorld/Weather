//
//  WTCollectionView + Paging.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * Paging CollectionView, WTCollectionView를 상속받는다. (Weather Hourly View)
 */

import Foundation
import UIKit

class WTCollectionPagingView: WTCollectionView {
    
    init(type: CollectionViewType, collection: UICollectionView, cellWidth: CGFloat, dataList: Array<Any>) {
        super.init(type: type, collection: collection, dataList: dataList)
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
        let talLayout = collection!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = talLayout.itemSize.width
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidth
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidth - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
