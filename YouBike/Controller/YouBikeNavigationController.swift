//
//  YouBikeNavigationController.swift
//  YouBike
//
//  Created by Sarah on 5/1/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit

class YouBikeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.ybkCharcoalGreyColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor(), NSFontAttributeName: UIFont.ybkTextStyle4Font(17)!]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
