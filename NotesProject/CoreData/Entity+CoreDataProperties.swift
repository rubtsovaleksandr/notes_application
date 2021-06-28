//
//  Entity+CoreDataProperties.swift
//  NotesProject
//
//  Created by Aleksandr on 24/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var date: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var text: String?
    @NSManaged public var password: String?

}
