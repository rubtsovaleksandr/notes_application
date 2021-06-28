//
//  Assembler.swift
//  NotesProject
//
//  Created by Максим Данько on 27.06.2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import Foundation

final class Assembler {
    
    static func createNoteListView() -> NotesListViewProtocol {
        let adapter = NotesListAdapter()
        let coreDataNotesRepository = CoreDataNotesRepository()
        let presenter: NotesListPresenterPtotocol = NotesListPresenter(adapter: adapter, notesRepository: coreDataNotesRepository)
        let viewController: NotesListViewProtocol = NotesListViewController(presenter: presenter)
        presenter.setView(viewController)
        return viewController
    }
    
    static func createNoteView(noteItem: NoteItem?) -> CreateNoteViewControllerProtocol {
        let coreDataNotesRepository = CoreDataNotesRepository()
        let presenter: CreateNotePresenterProtocol = CreateNotePresenter(notesRepository: coreDataNotesRepository, noteItem: noteItem)
        let createNoteViewController: CreateNoteViewControllerProtocol = CreateNoteViewController(presenter: presenter)
        presenter.setView(createNoteViewController)
        return createNoteViewController
    }
    
    static func createPasswordView(noteItem: NoteItem, mode: PasswordViewMode) -> PasswordViewProtocol {
        let coreDataNotesRepository = CoreDataNotesRepository()
        let presenter: PasswordViewPresenterProtocol = PasswordViewPresenter(notesRepository: coreDataNotesRepository, noteItem: noteItem, mode: mode)
        let passwordViewController: PasswordViewProtocol = PasswordViewController(presenter: presenter)
        presenter.setView(passwordViewController)
        return passwordViewController
    }
}
