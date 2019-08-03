//
//  MainViewController.swift
//  weather
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController , UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    var pageImages : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "첫번째 페이지" , "두번째 페이지", "세번째 페이지" , "네번째 페이지", "다섯번째 페이지")
        self.pageImages = NSArray(objects: "img01" , "img02" , "img03" , "img04" , "img05")
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(index: 0) as MainContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController] , direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0,y: 30,width: self.view.frame.width, height: self.view.frame.height - 100)
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
    }
    
    
    /**
     * viewPageController 구성 함수
     */
    func viewControllerAtIndex (index : Int) -> MainContentViewController {
        
        let vc : MainContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! MainContentViewController
        
        
        return vc
    }
    
    
    
    /**
     * 이전 ViewPageController 구성
     */
    func pageViewController(_ pageViewController: UIPageViewController, _ viewControllerBefore: UIViewController) -> UIViewController? {
        
        let vc = viewControllerBefore as! MainContentViewController
        var index = vc.index(ofAccessibilityElement: vc) as Int
        
        if( index == 0 || index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
    }
    
    
    /**
     * 이후 ViewPageController 구성
     */
    func pageViewController(_ pageViewController: UIPageViewController, _ viewControllerBefore: UIViewController) -> UIViewController? {
        
        let vc = viewControllerBefore as! MainContentViewController
        
        var index = vc.index(ofAccessibilityElement: vc) as Int
        
        if( index == NSNotFound) {
            return nil
        }
        
        index += 1
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
    
    
    /**
     * 인디케이터의 총 갯수
     */
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    
    /**
     * 인디케이터의 시작 포지션
     */
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
