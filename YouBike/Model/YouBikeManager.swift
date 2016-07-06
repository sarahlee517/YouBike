//
//  YouBikeManager.swift
//  YouBike
//
//  Created by Sarah on 5/4/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import Alamofire
import JWT
import CoreData
import UILoadControl

protocol YouBikeManagerDelegate: class {
    
    func getStationsDidFinish()
    func didFinishPostRequest()
    
}

//MARK: - Data Storage

class StationDatas{
    
    var titleCn: String = ""
    var titleEn: String = ""
    var locationCn: String = ""
    var locationEn: String = ""
    var available: Int = 0
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    init(){
        
    }
    
    init(titleCn:String, titleEn:String, locationCn: String, locationEn:String, available: Int, lat: Double, lng: Double){
        self.titleCn = titleCn
        self.titleEn = titleEn
        self.locationCn = locationCn
        self.locationEn = locationEn
        self.available = available
        self.lat = lat
        self.lng = lng
    }
}

extension StationDatas {
    var title: String {
        let currentLanguage = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) ?? "en"
        return (currentLanguage as? String == "zh") ? titleCn : titleEn
    }
    
    var location: String {
        let currentLanguage = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) ?? "en"
        return (currentLanguage as? String == "zh") ? locationCn : locationEn
    }
}


// MARK - YouBikeManager

class YouBikeManager{
    
    static let sharedManager = YouBikeManager()
    
    var stations = [StationDatas]()
    
    weak var tableViewDelegate: YouBikeManagerDelegate?
    weak var collectionViewDelegate: YouBikeManagerDelegate?
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var stationNextToken: String?
    var stationPreviousToken: String?
    var commentNextToken: String?
    var commentPreviousToken: String?
    func YouBikeGetJsonRequest(){
        
        let URL = "http://data.taipei/youbike"
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            Alamofire.request(
                .GET,
                URL,
                encoding: .JSON)
                .validate()
                .responseJSON {
                    response in
                    if let stationdatas = response.result.value as? [String: AnyObject] {
                        self.cleanUpStation()
                        self.readJSONObject(stationdatas)
                    }else{
                        print("Parsing Json file failed...")
                    }
                    
                    self.readStation()
    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableViewDelegate?.getStationsDidFinish()
                    })
                    
            }
        })
    }
    
    func readJSONObject(objects: [String: AnyObject]){
        
        for objects in objects.values{
            
            guard let data = objects as? [String: AnyObject] else { return }
            
            for object in data.values {
                
                guard let station = object as? [String: AnyObject] else { return }
                
                if let sna = station["sna"] as? String,
                    let snaen = station["snaen"] as? String,
                    let ar = station["ar"] as? String,
                    let aren = station["aren"] as? String,
                    let ssbi = station["sbi"] as? String,
                    let sbi = Int(ssbi),
                    let llat = station["lat"] as? String,
                    let lat = Double(llat),
                    let llng = station["lng"] as? String,
                    let lng = Double(llng) {
                    
                    self.addStation(
                        titleCn: sna,
                        titleEn: snaen,
                        locationCn: ar,
                        locationEn: aren,
                        available: sbi,
                        lat: lat,
                        lng: lng
                    )
                }
                
            }
        }
    } 
}



// MARK: - Core Data CRUD
extension YouBikeManager{
    
    func addStation(titleCn titleCn: String, titleEn: String, locationCn: String, locationEn: String, available: Int, lat: Double, lng: Double){
        let station = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: self.moc) as! Station
        
        station.titleCn = titleCn
        station.titleEn = titleEn
        station.locationCn = locationCn
        station.locationEn = locationEn
        station.available = available
        station.lat = lat
        station.lng = lng
        
        
        do{
            // the new entity is store in the memory now, use save() to save into disk
            try self.moc.save()
        }catch{
            fatalError("Failed to save context: \(error)")
        }
    }
    
    func cleanUpStation(){
        let request = NSFetchRequest(entityName: "Station")
        
        do{
            let results = try moc.executeFetchRequest(request) as! [Station]
            
            for result in results{
                moc.deleteObject(result)
            }
            
            do{
                try moc.save()
            }catch{
                fatalError("Failed to save context: \(error)")
            }
        }catch{
            fatalError("failed to fetch data: \(error)")
        }
    }
    
    func readStation(){
        let request = NSFetchRequest(entityName: "Station")
        
        do{
            let stations = try moc.executeFetchRequest(request) as! [Station]
            
            for station in stations {
                
                guard
                    let titleCn = station.titleCn,
                    let titleEn = station.titleEn,
                    let locationCn = station.locationCn,
                    let locationEn = station.locationEn,
                    let available = station.available as? Int,
                    let lat = station.lat as? Double,
                    let lng = station.lng as? Double
                    else { continue }
                
                YouBikeManager.sharedManager.stations.append(
                    StationDatas(
                        titleCn: titleCn,
                        titleEn: titleEn,
                        locationCn: locationCn,
                        locationEn: locationEn,
                        available: available,
                        lat: lat,
                        lng: lng
                    )
                )
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
    

}












