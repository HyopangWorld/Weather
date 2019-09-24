//
//  BaseViewController.swift
//  weather
//
//  Created by 김효원 on 19/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - view 초기화 작업
    func initView(){
        
    }
    
    
    // MARK: - 공통 show indicator
    func showIndicator(){
        
        if indicator == nil {
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        // 최상위 뷰에 띄우기
        if let keywindow = UIApplication.shared.keyWindow {
            
            indicator?.center = keywindow.center
            
            keywindow.addSubview(indicator!)
            keywindow.bringSubviewToFront(indicator!)
        }
        
        indicator.startAnimating()
    }
    
    
    // MARK: - 공통 hide indicator
    func hideIndicator(){
        indicator.stopAnimating()
    }
}
