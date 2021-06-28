//
//  NotesListPresenter.swift
//  NotesProject
//
//  Created by Aleksandr on 20/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol NotesListPresenterPtotocol: AnyObject {
    
    var view: NotesListViewProtocol? { get } // Объяви переменную view тип которой будет NotesListProtocol. Свойство только для чтения
    
    var hasItems: Bool { get }
    
    func setView(_ view: NotesListViewProtocol)
    
    func setCollectionView(_ collectionView: UICollectionView)
    
    func fetchNotes() // Получение заметок

}

class NotesListPresenter: NotesListPresenterPtotocol {
    
    weak var view: NotesListViewProtocol?
    
    let adapter: NotesListAdapterDataSourceProtocol
    let notesRepository: NotesRepositoryProtocol
    
    init(adapter: NotesListAdapterDataSourceProtocol, notesRepository: NotesRepositoryProtocol) {
        self.adapter = adapter
        self.notesRepository = notesRepository
        self.adapter.delegate = self
        self.notesRepository.delegate = self
    }
    
    func setView(_ view: NotesListViewProtocol) {
        self.view = view
    }
    
    func setCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = adapter
        collectionView.delegate = adapter // Нашем делегатом будет являться адаптер
        collectionView.register(NotesCell.self, forCellWithReuseIdentifier: String(describing: NotesCell.self))
        adapter.collectionView = collectionView
    }
    
    func fetchNotes() {
        view?.showActivityIndicator()
        notesRepository.fetchNotes(completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.view?.hideActivityIndicator()
            switch result {
            case .success(let notesItems):
                self.adapter.items = notesItems
                if notesItems.isEmpty {
                    self.view?.showEmptyView()
                } else {
                    self.view?.showList()
                }
            case .failure(let error):
                switch error {
                case .unableParseData: self.view?.showError()
                case .unableLoadData: self.view?.showError()
                }
            }
        })
    }
    
    var hasItems: Bool {
        return !adapter.items.isEmpty
    }
}

extension NotesListPresenter: NotesListAdapterDelegate {

    func notesListAdapter(_ adapter: NotesListAdapterProtocol, didSelectNote item: NoteItem) {
        if item.password.isEmpty {
            view?.openNoteDetailView(with: item)
        } else {
            view?.openPasswordView(noteItem: item, passwordButtonOn: false)
        }
    }
    
    func notesListAdapter(_ adapter: NotesListAdapterProtocol, didPressPasswordButtonOn item: NoteItem) {
        view?.openPasswordView(noteItem: item, passwordButtonOn: true)
    }
}

extension NotesListPresenter: NotesRepositoryDelegate {
    func notesRepository(_ repository: NotesRepositoryProtocol, didChangeNotes items: [NoteItem]) {
        
        if adapter.items.isEmpty && !items.isEmpty {
            view?.showList()
        }
        
        if !adapter.items.isEmpty && items.isEmpty {
            view?.showEmptyView()
        }
        adapter.updateItems(items)
    }
}
