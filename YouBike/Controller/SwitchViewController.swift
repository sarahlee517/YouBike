//
//  SwitchViewController.swift
//  YouBike
//
//  Created by Sarah on 5/18/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import PureLayout

enum ViewType: Int{
    case ListView
    case GridView

}

class SwitchViewController: UIViewController, YouBikeManagerDelegate{

    private lazy var listView: YouBikeTableViewController = { [unowned self] in
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YouBikeTableViewController") as! YouBikeTableViewController
        
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        
        return controller
        
    }()
    
    private lazy var gridView: YouBikeCollectionViewController = { [unowned self] in
    
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YouBikeCollectionViewController")  as! YouBikeCollectionViewController
        
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        
        return controller
    }()
    

    
    
    @IBOutlet var rootSwitchView: UIView!

    @IBAction func switchView(sender: UISegmentedControl!) {
        
        switch ViewType(rawValue: sender.selectedSegmentIndex)! {
        case .ListView:
            
            listView.view.removeFromSuperview()
            view.addSubview(listView.tableView)
            listView.tableView.autoPinEdgesToSuperviewEdges()
         
            
        case .GridView:
            
            gridView.view.removeFromSuperview()
            view.addSubview(gridView.view)
            gridView.view.autoPinEdgesToSuperviewEdges()
           
        }
    }
    
    var stations = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YouBikeManager.sharedManager.tableViewDelegate = self
        YouBikeManager.sharedManager.YouBikeGetJsonRequest()

        self.edgesForExtendedLayout = UIRectEdge.None

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getStationsDidFinish() {
        
        YouBikeManager.sharedManager.tableViewDelegate = self.listView
        
        view.addSubview(self.listView.view)
        self.listView.view.autoPinEdgesToSuperviewEdges()

        self.listView.tableView.reloadData()
        
    }
    
    func didFinishPostRequest(){
        self.listView.tableView.reloadData()
        self.gridView.collectionView?.reloadData()
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
