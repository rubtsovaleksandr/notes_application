//
//  CreateNotePresenter.swift
//  NotesProject
//
//  Created by Aleksandr on 23/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol CreateNotePresenterProtocol: AnyObject {
    
    var view: CreateNoteViewControllerProtocol? { get }
    
    var title: String { get set }
    
    var text: String { get set }
    
    var needShowDeleteToolbar: Bool { get }
    
    func setView(_ view: CreateNoteViewControllerProtocol)
    
    func pressSaveButton()
    
    func deleteNotes()
    
    func validate()
    
}

final class CreateNotePresenter: CreateNotePresenterProtocol {
    
    weak var view: CreateNoteViewControllerProtocol?
    
    let notesRepository: NotesRepositoryProtocol
    let noteItem: NoteItem?
    
    var title: String
    var text: String
    
    init(notesRepository: NotesRepositoryProtocol, noteItem: NoteItem?) {
        self.notesRepository = notesRepository
        self.noteItem = noteItem
        self.title = noteItem?.title ?? ""
        self.text = noteItem?.text ?? ""
    }
    
    func setView(_ view: CreateNoteViewControllerProtocol) {
        self.view = view
    }
    
    func deleteNotes() {
        guard let id = noteItem?.id else { return }
        notesRepository.deleteNote(by: id)
    }
    
    func validate() {
        if title.isEmpty || text.isEmpty {
            view?.deactivateRightBarButtonItem()
        } else {
            view?.activateRightBarButtonItem()
        }
    }
    
    func pressSaveButton() {
        if let noteItem = noteItem {
            notesRepository.editNote(by: noteItem.id, title: title, text: text)
        } else {
            notesRepository.saveNote(with: title, text: text)
        }
    }
    
    var needShowDeleteToolbar: Bool {
        return noteItem != nil
    }
}
