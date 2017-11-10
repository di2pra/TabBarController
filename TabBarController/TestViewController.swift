//
//  TestViewController.swift
//  TabBarController
//
//  Created by Pradheep Rajendirane on 02/11/2017.
//  Copyright © 2017 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var tabBarItemTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    convenience init(backgroundColor color: UIColor, tabBarItemTitle: String, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = color
        self.tabBarItemTitle = tabBarItemTitle
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
