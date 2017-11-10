//
//  PageViewController.swift
//  TabBarController
//
//  Created by Pradheep Rajendirane on 01/11/2017.
//  Copyright © 2017 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    //weak var pageViewDelegate: PageViewControllerDelegate?
    
    convenience init(firstViewController: UIViewController, transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation) {
        
        self.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.dataSource = self
        //self.delegate = self
        
        //pageViewDelegate?.pageViewController(tutorialPageViewController: self, didUpdatePageCount: orderedViewControllers.count)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol PageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func pageViewController(tutorialPageViewController: PageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pageViewController(tutorialPageViewController: PageViewController,
                                    didUpdatePageIndex index: Int)
    
}
