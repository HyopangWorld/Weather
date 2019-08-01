//
//  WTCollectionView.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

// 공통 CollectionView DataSource, Delegate

import Foundation
import UIKit

class WTCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var navigation: UINavigationController? = nil
    
    var type: CollectionViewType? = nil  // TableView 생성 Type
    var collection: UICollectionView? = nil
    var backgroundColor: UIColor? = nil
    
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    init(navigation: UINavigationController, type: CollectionViewType, collection: UICollectionView, backgroundColor: UIColor){
        super.init(nibName: nil, bundle: nil)
        self.navigation = navigation
        self.type = type
        self.collection = collection
        self.backgroundColor = backgroundColor
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView(){
        let flowLayout = collection!.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    
    //set cell size
    func setCellSize(){
        cellWidth = collection!.frame.width / 2
        cellHeight = collection!.frame.height / 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        setCellSize()
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //setting section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type == .time ? 26 : 10
    }
    
    // setting cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch type {
        case .time? :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCollectionViewCell
        case .detail? :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionViewCell
        case .none: break
        }
        
        cell.backgroundColor = backgroundColor
        
        return cell
    }
}
