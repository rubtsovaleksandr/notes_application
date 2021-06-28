//
//  CoreDataNotesRepository.swift
//  NotesProject
//
//  Created by Aleksandr on 22/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataNotesRepository: NSObject, NotesRepositoryProtocol {
    
    weak var delegate: NotesRepositoryDelegate?
    
    let coreDataManager: CoreDataManager
    
    let resultController: NSFetchedResultsController<NSManagedObject>
    
    init(coreDataManager: CoreDataManager = .instance) {
        self.coreDataManager = coreDataManager
        self.resultController = coreDataManager.fetchResultController(entityName: CoreDataManager.EntityName.note.rawValue, keyForSort: "name")
        super.init()
        self.resultController.delegate = self
    }
    
    func fetchNotes(completionHandler: @escaping ([NoteItem]?, NotesRepositoryFetchNotesError?) -> Void) {
        do {
            try resultController.performFetch()
            if let noteEntities = resultController.fetchedObjects as? [Entity] {
                let noteItems = noteEntities.map({ NoteItem(title: $0.name ?? "", text: $0.text ?? "", date: $0.date ?? "", id: $0.id ?? "", password: $0.password ?? "") })
                completionHandler(noteItems, nil)
            } else {
                completionHandler(nil, .unableParseData)
            }
        } catch {
            completionHandler(nil, .unableLoadData)
        }
    }
    
    func fetchNotes(completionHandler: @escaping (Result<[NoteItem], NotesRepositoryFetchNotesError>) -> Void) {
        do {
            try resultController.performFetch()
            if let noteEntities = resultController.fetchedObjects as? [Entity] {
                let noteItem = noteEntities.map({ NoteItem(title: $0.name ?? "", text: $0.text ?? "", date: $0.date ?? "", id: $0.id ?? "", password: $0.password ?? "") })
                completionHandler(.success(noteItem))
            } else {
                completionHandler(.failure(.unableParseData))
            }
        } catch {
            completionHandler(.failure(.unableLoadData))
        }
    }
    
    func saveNote(with title: String, text: String) {
        let noteEntity = Entity()
        noteEntity.id = UUID().uuidString
        noteEntity.name = title
        noteEntity.text = text
        noteEntity.date = Date().toUTC
        coreDataManager.saveContext()
    }
    
    func editNote(by id: String, title: String, text: String) {
        if resultController.fetchedObjects?.isEmpty ?? true {
            try? resultController.performFetch()
        }
        guard let noteFetchedObjects = resultController.fetchedObjects as? [Entity] else { return }
        guard let noteFetchedObject = noteFetchedObjects.first(where: { $0.id == id }) else { return }
        noteFetchedObject.name = title
        noteFetchedObject.text = text
        coreDataManager.saveContext()
    }
    
    func deleteNote(by id: String) {
        
        if resultController.fetchedObjects?.isEmpty ?? true {
            try? resultController.performFetch()
        }
        guard let noteFetchedObjects = resultController.fetchedObjects as? [Entity] else { return }
        guard let noteFetchedObject = noteFetchedObjects.first(where: { $0.id == id }) else { return }
        coreDataManager.viewContext.delete(noteFetchedObject)
        coreDataManager.saveContext()
    }
    
    func savePassword(id: String, password: String) {
        if resultController.fetchedObjects?.isEmpty ?? true {
            try? resultController.performFetch()
        }
        guard let noteFetchedObjects = resultController.fetchedObjects as? [Entity] else { return }
        guard let noteFetchedObject = noteFetchedObjects.first(where: { $0.id == id }) else { return }
        noteFetchedObject.password = password
        coreDataManager.saveContext()
    }
    
    func deletePassword(id: String) {
        if resultController.fetchedObjects?.isEmpty ?? true {
            try? resultController.performFetch()
        }
        guard let noteFetchedObjects = resultController.fetchedObjects as? [Entity] else { return }
        guard let noteFetchedObject = noteFetchedObjects.first(where: { $0.id == id }) else { return }
        noteFetchedObject.password = nil
        coreDataManager.saveContext()
    }
}

extension CoreDataNotesRepository: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let noteEntities = resultController.fetchedObjects as? [Entity] else { return }
        let noteItems = noteEntities.map({ NoteItem(title: $0.name ?? "", text: $0.text ?? "", date: $0.date ?? "", id: $0.id ?? "", password: $0.password ?? "") })
        delegate?.notesRepository(self, didChangeNotes: noteItems)
    }
}
