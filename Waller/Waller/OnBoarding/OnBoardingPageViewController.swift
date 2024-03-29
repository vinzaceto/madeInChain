//
//  OnBoardingPageViewController.swift
//  Waller
//
//  Created by Pasquale Mauriello on 05/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnBoardingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIViewControllerTransitioningDelegate {


    lazy var orderedViewController:[UIViewController] = {
        
        
        let st = UIStoryboard(name: "OnBoarding", bundle: nil)
        
        var controller1 = st.instantiateViewController(withIdentifier: "onPage3") as! OnViewController

        var controller2 = st.instantiateViewController(withIdentifier: "onPage2") as! OnViewController2

        var controller3 = st.instantiateViewController(withIdentifier: "onPage1") as! OnViewController3


        return [controller3,controller2,controller1]
    }()
    
    let transition = CircleTransition()

    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        if let firstVC = orderedViewController.first {
            
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
           
        }
        self.delegate = self
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen
            .main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewController.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
       
        
        self.view.addSubview(pageControl)
    }
    
    func newVC(controllerID: String) -> UIViewController {
        return UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: controllerID)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            // return self.orderedViewController.last
            return nil
        }
        
        guard orderedViewController.count > previousIndex else {
            return nil
        }
        return orderedViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewController.count != nextIndex else {
            //return self.orderedViewController.first
            return nil
        }
        
        guard orderedViewController.count > nextIndex else {
            return nil
        }
        return orderedViewController[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewController.index(of: pageContentViewController)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
