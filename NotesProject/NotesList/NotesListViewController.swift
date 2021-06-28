//
//  NotesListViewController.swift
//  NotesProject
//
//  Created by Aleksandr on 03/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol NotesListViewProtocol: AnyObject, Presentable {
    
    var presenter: NotesListPresenterPtotocol { get } // Объяви переменную presenter тип которой будет NOtesListPresenterProtocol. Get - свойство только для чтения
    
    func showEmptyView() // Показать пустое/начальное вью
    
    func showList() // Показать список ячеек
    
    func showError() // Показать ошибки
    
    func showActivityIndicator() // Показать индикатор загрузки
    
    func hideActivityIndicator() // Убрать индикатор загрузки
    
    func openNoteDetailView(with noteItem: NoteItem) // Навигация
    
    func openPasswordView(noteItem: NoteItem, passwordButtonOn: Bool)
    
}

final class NotesListViewController: UIViewController, NotesListViewProtocol {
        
    let presenter: NotesListPresenterPtotocol
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emptyView = NotesListEmptyView()
    
    init(presenter: NotesListPresenterPtotocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        
        presenter.setCollectionView(collectionView)
        presenter.fetchNotes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !presenter.hasItems { navigationController?.setNavigationBarHidden(true, animated: false) }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        emptyView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        emptyView.onPressButton = { [weak self] in self?.runCreateNoteView() }
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Заметки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(runCreateNoteView))
    }
    
    @objc
    func runCreateNoteView() {
        let createNoteViewController = Assembler.createNoteView(noteItem: nil)
        navigationController?.pushViewController(createNoteViewController.toPresent, animated: true)
    }

    //MARK: -Actions NotesListViewProtocol
    
    func showEmptyView() {
        emptyView.isHidden = false
        collectionView.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showList() {
        emptyView.isHidden = true
        collectionView.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func showError() {
        
    }
    
    func showActivityIndicator() {
        
    }
    
    func hideActivityIndicator() {
        
    }
    
    func openNoteDetailView(with noteItem: NoteItem) {
        let createNoteViewController = Assembler.createNoteView(noteItem: noteItem)
        navigationController?.pushViewController(createNoteViewController.toPresent, animated: true)
    }
    
    func openPasswordView(noteItem: NoteItem, passwordButtonOn: Bool) {
        let mode: PasswordViewMode = passwordButtonOn ? .manage : .check
        let passwordViewController = Assembler.createPasswordView(noteItem: noteItem, mode: mode)
        navigationController?.pushViewController(passwordViewController.toPresent, animated: true)
    }
    
}


