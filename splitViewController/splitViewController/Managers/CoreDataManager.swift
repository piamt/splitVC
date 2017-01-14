//
//  CoreDataManager.swift
//  splitViewController
//
//  Created by Pia on 13/1/17.
//  Copyright © 2017 iOSWorkshops. All rights reserved.
//

import UIKit
import CoreData
import Deferred

class CoreDataManager {
    
    //MARK: - Singleton
    static let manager = CoreDataManager()
    
    //MARK: - Public API
    func feedRow(_ rowNumber: CLong, image: UIImage, text: String, switchValue: Bool) {
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObject(forEntityName: "CellEntity", into: moc) as! CellEntity
        
        // add our data
        entity.setValue(rowNumber, forKey: "rowNumber")
        
        let imageData = UIImagePNGRepresentation(image);
        entity.setValue(imageData, forKey: "imageData")
        
        entity.setValue(text, forKey: "text")
        entity.setValue(switchValue, forKey: "switchValue")
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetchCellForRow(_ row: CLong) -> TaskResult<CellEntity> {
        let moc = DataController().managedObjectContext
        let cellFetch: NSFetchRequest<CellEntity> = CellEntity.fetchRequest()
        cellFetch.predicate = NSPredicate(format: "rowNumber == %d", row)
        
        do {
            let fetchedCell = try moc.fetch(cellFetch)
            
            if fetchedCell.count > 0 {
                return .success(fetchedCell.first! as CellEntity)
            } else {
                return .failure(APIError.resourceNotFound)
            }
            
        } catch {
            fatalError("Failed to fetch cell: \(error)")
        }
    }
    
    func updateSwitchForRow(_ row: CLong, newValue: Bool) {
        let moc = DataController().managedObjectContext
        let cellFetch: NSFetchRequest<CellEntity> = CellEntity.fetchRequest()
        cellFetch.predicate = NSPredicate(format: "rowNumber == %d", row)
        
        do {
            let fetchedCell = try moc.fetch(cellFetch)
            
            if fetchedCell.count > 0 {
                let cell = fetchedCell.first! as CellEntity
                cell.switchValue = newValue
                
                // we save our entity
                do {
                    try moc.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            
        } catch {
            fatalError("Failed to fetch cell: \(error)")
        }
    }
    
    func removeObjects() {
        let moc = DataController().managedObjectContext
        let cellFetch: NSFetchRequest<CellEntity> = CellEntity.fetchRequest()
        cellFetch.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedCell = try moc.fetch(cellFetch)
            for entity in fetchedCell
            {
                let managedObjectData:NSManagedObject = entity as CellEntity
                moc.delete(managedObjectData)
            }
            
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
        } catch let error as NSError {
            print("Detele all data in CellEntity - error : \(error) \(error.userInfo)")
        }
    }
}
