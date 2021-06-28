//
//  PasswordViewPresenter.swift
//  NotesProject
//
//  Created by Aleksandr on 24/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol PasswordViewPresenterProtocol: AnyObject {
    
    var view: PasswordViewProtocol? { get }
    
    var noteItem: NoteItem { get }
    
    var currentPassword: String { get set }
    
    func setView(_ view: PasswordViewProtocol)
        
    func savePassword()
        
    func deletePassword()
    
    func normNumbers()
    
    func validatePassword(_ password: String, nextChar char: String) -> Bool
    
    func prepareView()
    
    func pressGoButton()

}

enum PasswordViewMode {
    case check
    case manage
}

class PasswordViewPresenter: PasswordViewPresenterProtocol {
       
    weak var view: PasswordViewProtocol?
    
    var currentPassword: String = ""
    
    let noteItem: NoteItem
    let notesRepository: NotesRepositoryProtocol
    let mode: PasswordViewMode
    
    init(notesRepository: NotesRepositoryProtocol, noteItem: NoteItem, mode: PasswordViewMode) {
        self.notesRepository = notesRepository
        self.noteItem = noteItem
        self.mode = mode
    }
    
    func setView(_ view: PasswordViewProtocol) {
        self.view = view
    }
    
    func savePassword() {
        notesRepository.savePassword(id: noteItem.id, password: currentPassword)
    }
    
    func deletePassword() {
        notesRepository.deletePassword(id: noteItem.id)
    }
    
    func normNumbers() {
        if noteItem.hasPassword {
            view?.normNumbersGoButton()
        } else {
            view?.normNumbersSaveButton()
        }
    }
    
    
    func validatePassword(_ password: String, nextChar char: String) -> Bool {
        let maxNumbers = !char.isEmpty ? password.count + 1 : password.count - 1
        if maxNumbers < 4  {
            view?.fewNumbers()
        }
        if maxNumbers == 4 {
            normNumbers()
        }
        if maxNumbers > 4 {
            normNumbers()
            return false
        }
        return char == char.filter("0123456789".contains)
    }
    
    func prepareView() {
        switch mode {
        case .check:
            view?.showCheckPasswordView()
        case .manage:
            if noteItem.hasPassword {
                view?.showDeletePasswordView()
            } else {
                view?.showSavePasswordView()
            }
        }
    }
    
    func pressGoButton() {
        switch mode {
        case .check:
            if currentPassword == noteItem.password {
                view?.openCreateView()
            } else {
                view?.showPasswordError()
            }
        case .manage:
            if noteItem.hasPassword {
                if currentPassword == noteItem.password {
                    notesRepository.deletePassword(id: noteItem.id)
                    view?.closePasswordView()
                } else {
                    view?.showPasswordError()
                }
            }
        }
    }
        
}
