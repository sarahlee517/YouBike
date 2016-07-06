//
//  YouBikeCollectionViewController.swift
//  YouBike
//
//  Created by Sarah on 5/18/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import UILoadControl


class YouBikeCollectionViewController: UICollectionViewController, YouBikeManagerDelegate {

    @IBOutlet var stationCollectionView: UICollectionView!
    
    var stations = [StationDatas]()

    var loadDelaySeg: Double = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        
        YouBikeManager.sharedManager.YouBikeGetJsonRequest()

        let nib = UINib(nibName: "YouBikeCollectionViewCell", bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: "YouBikeCollectionViewCell")

        stationCollectionView.loadControl = UILoadControl(target: self, action: #selector(self.loadMore(_:)))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStationsDidFinish(){
        self.collectionView?.reloadData()
    }
    
    func didFinishPostRequest(){
        self.collectionView?.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YouBikeManager.sharedManager.stations.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YouBikeCollectionViewCell", forIndexPath: indexPath) as! YouBikeCollectionViewCell
        let station = YouBikeManager.sharedManager.stations[indexPath.row]
        
        cell.YBAvailableLabel.text = String(station.available)
        cell.YBStationLabel.text = station.title
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mapViewWithCell = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewWithCell") as! MapViewWithCellController
        mapViewWithCell.station = YouBikeManager.sharedManager.stations[indexPath.row]
        self.navigationController!.pushViewController(mapViewWithCell, animated: true)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(166, 166);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(14, 14, 14, 14); //top,left,bottom,right
    }
    
    @objc private func loadMore(sender: AnyObject?) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(loadDelaySeg * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            YouBikeManager.sharedManager.YouBikeGetJsonRequest()
            self.stationCollectionView.loadControl!.endLoading()
            self.stationCollectionView.reloadData()
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
}
