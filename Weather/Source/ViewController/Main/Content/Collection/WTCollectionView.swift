//
//  WTCollectionView.swift
//  weather
//
//  Created by 김효원 on 01/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

/*
 * CollectionView DataSource, Delegate (날씨 상세 정보 View)
 */

import Foundation
import UIKit

class WTCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // TableView 생성 Type
    var type: CollectionViewType? = nil
    
    // cell의 데이터 리스트
    var dataList = Array<Any>()
    
    var collection: UICollectionView? = nil
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    init(type: CollectionViewType, collection: UICollectionView, dataList: Array<Any>){
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.collection = collection
        self.dataList = dataList
        
        // View 초기 설정
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
    
    
    // MARK: - set cell size
    func setCellSize(){
        cellWidth = collection!.frame.width / 2
        cellHeight = collection!.frame.height / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        setCellSize()
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // setting section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        return dataList.count
    }
    
    // setting cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .time? :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCollectionViewCell
            let data = dataList[indexPath.row] as! HourlyVO
            
            cell.timeLabel.text = "\(data.hourlyTime!)"
            cell.icoLabel.text = data.icon!.getWeatherIcon()
            cell.humLabel.text = "\(data.humidity!)"
            cell.tempLabel.text = "\(WTFormat().toTemp(data.temperature!))˚"
            
            return cell
            
        case .detail? :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionViewCell
            
            cell.titleLabel.text = DetailTypeString(rawValue: indexPath.row)?.getDetailTypeString()
            cell.infoLabel.text = "\(dataList[indexPath.row])"
            
            return cell
            
        case .none:
            break
            
        }
        
        return UICollectionViewCell()
    }
}
