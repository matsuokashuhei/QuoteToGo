//
//  CoreDataHelper.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    class func managedObjectContext() -> NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }

    class func insertManagedObject(className: NSString, managedObjectContext: NSManagedObjectContext) -> AnyObject {
        return NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext)
    }

    class func fetchEntities(className: NSString, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) -> NSArray {
        /*
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entityDescription
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        */
        let request: NSFetchRequest = {
            let request = NSFetchRequest()
            let entityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)
            request.entity = entityDescription
            if let predicate = predicate {
                request.predicate = predicate
            }
            if let sortDescriptor = sortDescriptor {
                request.sortDescriptors = [sortDescriptor]
            }
            return request
        }()
        //var items = []
        do {
            return try managedObjectContext.executeFetchRequest(request)
        } catch {
            print(error)
            return []
        }
        //return items
    }

}