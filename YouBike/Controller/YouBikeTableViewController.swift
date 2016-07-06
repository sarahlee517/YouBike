//
//  YouBikeTableViewController.swift
//  YouBike
//
//  Created by Sarah on 5/1/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MapKit
import UILoadControl

class YouBikeTableViewController: UITableViewController, CellDelegation, YouBikeManagerDelegate{
    
    
    @IBOutlet var ybTableview: UITableView!
    
    var stations = [StationDatas]()
    
    var loadDelaySeg = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ybTableview.loadControl = UILoadControl(target: self, action: #selector(self.loadMore(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(122)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YouBikeManager.sharedManager.stations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UINib(nibName: "YouBikeTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! YouBikeTableViewCell
        let station = YouBikeManager.sharedManager.stations[indexPath.row]
        
        cell.station = station
        cell.delegation = self
        cell.stationNameLabel.text = station.title
        cell.locationLabel.text = station.location
        cell.availableNumLabel.text = String(station.available)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mapViewWithCell = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewWithCell") as! MapViewWithCellController
        mapViewWithCell.station = YouBikeManager.sharedManager.stations[indexPath.row]
        self.navigationController!.pushViewController(mapViewWithCell, animated: true)
    }
    
    func getStationsDidFinish() {
        //self.tableView.reloadData()
    }
    
    func didFinishPostRequest(){
        self.tableView.reloadData()
    }
    
    func cell(cell: YouBikeTableViewCell, viewMap sender: AnyObject!) {
        
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("mapViewVCID") as! MapViewController
        
        //send datas
        VC1.station = cell.station
        
        //push the mapView on current view (send datas before switch the view)
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
    
    @objc private func loadMore(sender: AnyObject?) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(loadDelaySeg * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            YouBikeManager.sharedManager.YouBikeGetJsonRequest()
            self.ybTableview.loadControl!.endLoading()
            self.ybTableview.reloadData()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


