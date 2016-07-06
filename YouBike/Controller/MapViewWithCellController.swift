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

enum MapType: Int{
    case Standard
    case Satellite
    case Hybrid
}


class MapViewWithCellController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    let nib = UINib(nibName: "YouBikeTableViewCell", bundle: nil)
    var cellView = YouBikeTableViewCell()
    var station = StationDatas()
    let locationManager = CLLocationManager()
    var myRoute : MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        
        mapSetting()
        navigationSetting()
        staionDirection()
        addYouBikeTalbleViewCell()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapSetting()
    }
    
    func addYouBikeTalbleViewCell(){
        
        cellView = nib.instantiateWithOwner(self, options: nil)[0] as! YouBikeTableViewCell
        
        cellView.frame = CGRectMake(0, 0, view.frame.width, 122)
        cellView.stationNameLabel.text = station.title
        cellView.locationLabel.text = station.location
        cellView.availableNumLabel.text = String(station.available)
        cellView.viewMapButton.hidden = true
        
        mapView.addSubview(cellView)
    }
    
    func navigationSetting(){
        self.navigationItem.title = station.title
        navigationController?.navigationBar.tintColor = UIColor.ybkPaleGoldColor()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        cellView.frame = CGRectMake(0, 0, size.width, 122)
    }
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl!) {
        
        switch MapType(rawValue: sender.selectedSegmentIndex)! {
        case .Standard:
            mapView.mapType = .Standard
        case .Satellite:
            mapView.mapType = .Satellite
        case .Hybrid:
            mapView.mapType = .Hybrid
        }
    }
}

//MARK: - Map Setup 
extension MapViewWithCellController{
    
    func mapSetting(){
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func staionDirection(){
        
        let stationLocation = CLLocationCoordinate2D(
            latitude: station.lat,
            longitude: station.lng
        )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = stationLocation
        annotation.title = station.title
        annotation.subtitle = station.location
        
        mapView.addAnnotation(annotation)
        
        if let userLocation = locationManager.location?.coordinate{
            
            let directionsRequest = MKDirectionsRequest()
            let fromUserLocation = MKPlacemark(coordinate:userLocation, addressDictionary: nil)
            let toStationLocation = MKPlacemark(coordinate:stationLocation, addressDictionary: nil)
            
            directionsRequest.source = MKMapItem(placemark: fromUserLocation)
            directionsRequest.destination = MKMapItem(placemark: toStationLocation)
            
            directionsRequest.transportType = MKDirectionsTransportType.Automobile
            let directions = MKDirections(request: directionsRequest)
            
            directions.calculateDirectionsWithCompletionHandler(){
                response, error in
                
                if error == nil {
                    self.myRoute = response!.routes[0] as MKRoute
                    self.mapView.addOverlay(self.myRoute!.polyline)
                    self.setPolyLineRegion(self.myRoute!.polyline)
                }
            }
        }else{
            mapView.setRegion(MKCoordinateRegionMake(stationLocation, MKCoordinateSpanMake(0.05,0.05)), animated: true)
            print("Fail to get user location.")
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute!.polyline)
        myLineRenderer.strokeColor = UIColor.blueColor()
        myLineRenderer.lineWidth = 4
        return myLineRenderer
    }
    
    func setPolyLineRegion(polyline: MKPolyline){
        
        var regionRect = polyline.boundingMapRect
        
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(regionRect, animated: true)
    }
}
