//
//  NotesRepositoryProtocol.swift
//  NotesProject
//
//  Created by Aleksandr on 22/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import Foundation

enum NotesRepositoryFetchNotesError: Error {
    case unableLoadData
    case unableParseData
}

protocol NotesRepositoryDelegate: AnyObject {
    
    func notesRepository(_ repository: NotesRepositoryProtocol, didChangeNotes items: [NoteItem])
    
}

protocol NotesRepositoryProtocol: AnyObject  {
    
    var delegate: NotesRepositoryDelegate? { get set }
    
    func fetchNotes(completionHandler: @escaping ([NoteItem]?, NotesRepositoryFetchNotesError?) -> Void)
    
    func fetchNotes(completionHandler: @escaping (Result<[NoteItem], NotesRepositoryFetchNotesError>) -> Void)
    
    func saveNote(with title: String, text: String)
    
    func editNote(by id: String, title: String, text: String)
    
    func deleteNote(by id: String)
    
    func savePassword(id: String, password: String)
    
    func deletePassword(id: String)
}
