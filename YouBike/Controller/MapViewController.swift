//
//  MapViewController.swift
//  YouBike
//
//  Created by Sarah on 5/1/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    
    var station = StationDatas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        
        navigationSetting()
        mapForStationLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func mapForStationLocation(){
        let location = CLLocationCoordinate2D(
            latitude: station.lat,
            longitude: station.lng
        )

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = station.title
        annotation.subtitle = station.location
        
        mapView.addAnnotation(annotation)
    }
    
    func navigationSetting(){
        
        self.navigationItem.title = station.title
        navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
        
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
