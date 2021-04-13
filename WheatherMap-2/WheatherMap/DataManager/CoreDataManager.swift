//
//  CoreDataManager.swift
//  WheatherMap
//
//  Created by Somsubhra Dasgupta on 10/04/21.
//  Copyright © 2021 Somsubhra. All rights reserved.
//

import UIKit
import CoreData


class CoreDatamanager : NSObject
{
    public static let shared = CoreDatamanager()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var presentIds = [String]()
    
    private override init()
    {
        super.init()
    }
    
    func addLocationDetails(using location_name:String, location_latitude: Double, location_longitude:Double)
    {
        if let cntxt = self.context
        {
            let locationManager = Location(context: cntxt)
            locationManager.location_name = location_name
            locationManager.location_latitude = location_latitude
            locationManager.location_longitude = location_longitude

            do{
                try cntxt.save()
            }
            catch
            {
                print("Error while saving \(error)")
            }

        }
    }
    
    func removeLocationDetails(using location:Location)
    {
        if let cntxt = self.context
        {
            do{
                cntxt.delete(location)
                try cntxt.save()
            }
            catch
            {
                print("Error while saving \(error)")
            }

        }
    }
    
    func removeAllLocationDetails(using locations:[Location])
    {
        if let cntxt = self.context
        {
            do{
                for location in locations
                {
                    cntxt.delete(location)
                }
                
                try cntxt.save()
            }
            catch
            {
                print("Error while saving \(error)")
            }

        }
    }
    
    func fetchAllLocationList() -> [Location]
    {
        var activityList = [Location]()
        
        if let cntxt = self.context
        {
            let fetchRequest : NSFetchRequest<Location> = Location.fetchRequest()

            do{
                activityList = try cntxt.fetch(fetchRequest)
                return activityList
            }
            catch
            {
                print("Error while loading \(error)")
            }
            
        }
        
        return activityList
    }
    
}

