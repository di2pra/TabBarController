//
//  MainViewController.swift
//  TabBarController
//
//  Created by Pradheep Rajendirane on 02/11/2017.
//  Copyright © 2017 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {

    let pageColor:[UIColor] = [
        .gray,
        .brown,
        .green,
        .orange,
        .red,
        .yellow
    ]
    
    let menuHeight:CGFloat = 60
    let menuItemLineWidth:CGFloat = 3
    
    
    var stackView: UIStackView! = UIStackView()
    var menuScrollView: UIScrollView! = UIScrollView(frame: .zero)
    var lineView: UIView = UIView()
    var scrollView: UIScrollView! = UIScrollView(frame: .zero)
    var pages = [UIViewController?]()
    
    
    var transitioning = false
    
    var currentPage:Int = 0 {
        didSet {
            self.scrollToMenuButton(atIndex: currentPage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /**
         Setup the initial scroll view content size and first pages only once.
         (Due to this function called each time views are added or removed).
         */
        _ = setupInitialPages
    }
    
    fileprivate func newColoredViewController(number: Int) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "vc\(number)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pages = [UIViewController?](repeating: nil, count: pageColor.count)
        
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuScrollView)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .blue
        
        self.view.addConstraints([
            NSLayoutConstraint(item: menuScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: menuHeight),
            NSLayoutConstraint(item: menuScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: menuScrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: menuScrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
        stackView.spacing = 0
        stackView.distribution  = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.menuScrollView.addSubview(stackView)
        
        
        
        self.menuScrollView.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: self.menuScrollView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.menuScrollView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self.menuScrollView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self.menuScrollView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self.menuScrollView, attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
        
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.menuScrollView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
    }
    
    @objc func selected(sender: UIButton) {
        
        if let page = stackView.subviews.index(of: sender) {
            gotoPage(page: page, animated: true)
            scrollMenu(toButton: sender)
            sender.isSelected = true
        }
        
    }
    
    func scrollToMenuButton(atIndex index: Int) {
        
        if index < stackView.arrangedSubviews.count {
            if let btn = stackView.arrangedSubviews[index] as? UIButton {
                scrollMenu(toButton: btn)
            }
        }
        
    }
    
    func scrollMenu(toButton button: UIButton) {
        var contentOffset = CGPoint(x: button.frame.midX - self.menuScrollView.frame.width/2, y: 0)
        
        contentOffset.x = max(contentOffset.x, 0)
        contentOffset.x = min(contentOffset.x, self.menuScrollView.contentSize.width - self.menuScrollView.frame.width)
        
        self.menuScrollView.setContentOffset(contentOffset, animated: true)
        
        lineView.removeFromSuperview()
        button.addSubview(lineView)
        setLineConstraint(toButton: button)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /**
         Since we transitioned to a different screen size we need to reconfigure the scroll view content.
         Remove any the pages from our scrollview's content.
         */
        //removeAnyPages()
        
        coordinator.animate(alongsideTransition: nil) { _ in
            // Adjust the scroll view's contentSize (larger or smaller) depending on the new transition size.
            self.adjustScrollView()
            
            // Clear out and reload the relevant pages.
            //self.pages = [UIViewController?](repeating: nil, count: self.pageColor.count)
            
            self.transitioning = true
            
            // Go to the appropriate page (but with no animation).
            //self.gotoPage(page: 2, animated: false)
            /*for index in 0...self.pageColor.count {
                self.loadPage(index)
            }*/
            
            self.gotoPage(page: self.currentPage, animated: false)
            
            self.transitioning = false
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    lazy var setupInitialPages: Void = {
        /**
         Setup our initial scroll view content size and first pages once.
         
         Layout the scroll view's content size after we have knowledge of the topLayoutGuide dimensions.
         Each page is the width and height of the scroll view's frame.
         
         Note: Set the scroll view's content size to take into account the top layout guide.
         */
        adjustScrollView()
        
        // Pages are created on demand, load the visible page and next page.
        
        for index in 0...pageColor.count {
            loadPage(index)
        }
    }()
    
    /// Readjust the scroll view's content size in case the layout has changed.
    fileprivate func adjustScrollView() {
        
        scrollView.contentSize =
            CGSize(width: scrollView.frame.width * CGFloat(pageColor.count),
                   height: scrollView.frame.height)
        
        //menuScrollView.contentSize = CGSize(width: stackView.frame.width, height: menuHeight)
    }
    
    fileprivate func loadPage(_ page: Int) {
        
        guard page < pageColor.count && page != -1 else { return }
        
        if pages[page] == nil {
            
            
            
            
            let vc = TestViewController(backgroundColor: pageColor[page], tabBarItemTitle: pageColor[page].description, nibName: "TestViewController", bundle: nil)
            
            self.addItemToMenu(title: vc.tabBarItemTitle)
            
            if(page == 0) {
                
                if let btn = stackView.arrangedSubviews[page] as? UIButton {
                    
                    btn.addSubview(lineView)
                    setLineConstraint(toButton: btn)
                    
                }
                
            }
            
            
            /**
             Setup the canvas view to hold the image.
             Its frame will be the same as the scroll view's frame.
             */
            var frame = scrollView.frame
            
            // Offset the frame's X origin to its correct page offset.
            frame.origin.x = frame.width * CGFloat(page)
            // Set frame's y origin value to take into account the top layout guide.
            frame.origin.y = 0
            //frame.size.height += self.topLayoutGuide.length
            vc.view.frame = frame
            
            self.addChildViewController(vc)
            scrollView.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            pages[page] = vc
            
        }
    }
    
    func addItemToMenu(title: String) {
        
        let btn = UIButton()
        let myAttribute = [
            NSAttributedStringKey.foregroundColor: UIColor.red,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .thin)
        ]
        btn.setAttributedTitle(NSAttributedString(string: title, attributes: myAttribute), for: .normal)
        btn.sizeToFit()
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        btn.addTarget(self, action: #selector(self.selected(sender:)), for: .touchUpInside)
        
        stackView.insertArrangedSubview(btn, at: stackView.arrangedSubviews.count)
        
    }
    
    func setLineConstraint(toButton button: UIButton) {
        button.addConstraints([
            NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: menuItemLineWidth),
            NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal, toItem: lineView.superview, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: lineView.superview, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lineView, attribute: .trailing, relatedBy: .equal, toItem: lineView.superview, attribute: .trailing, multiplier: 1, constant: 0)
            ])
    }

    
    /*fileprivate func removeAnyPages() {
        for page in pages where page != nil {
            page?.willMove(toParentViewController: nil)
            page?.view.removeFromSuperview()
            page?.removeFromParentViewController()
        }
    }*/
    
    fileprivate func gotoPage(page: Int, animated: Bool) {
        
        // Update the scroll view scroll position to the appropriate page.
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)
        
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        currentPage = Int(page)
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
