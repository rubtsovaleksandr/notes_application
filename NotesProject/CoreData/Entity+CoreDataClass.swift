//
//  Entity+CoreDataClass.swift
//  NotesProject
//
//  Created by Aleksandr on 09/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//
//

import Foundation
import CoreData


public class Entity: NSManagedObject {
    convenience init() {
        // Создание управляемого объекта
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Entity"), insertInto: CoreDataManager.instance.persistentContainer.viewContext)
    }
}
