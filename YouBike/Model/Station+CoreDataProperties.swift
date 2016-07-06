//
//  Station+CoreDataProperties.swift
//  
//
//  Created by Sarah on 5/19/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Station {

    @NSManaged var available: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lng: NSNumber?
    @NSManaged var locationCn: String?
    @NSManaged var locationEn: String?
    @NSManaged var titleCn: String?
    @NSManaged var titleEn: String?
    @NSManaged var previousToken: String?
    @NSManaged var nextToken: String?

}
