//
//  NotesListAdapter.swift
//  NotesProject
//
//  Created by Aleksandr on 19/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

typealias NotesListAdapterDataSourceProtocol = NotesListAdapterProtocol & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

protocol NotesListAdapterDelegate: AnyObject {
    
    func notesListAdapter(_ adapter: NotesListAdapterProtocol, didPressPasswordButtonOn item: NoteItem)
    
    func notesListAdapter(_ adapter: NotesListAdapterProtocol, didSelectNote item: NoteItem)
    
}

protocol NotesListAdapterProtocol: AnyObject {
    
    var collectionView: UICollectionView? { get set } // Свойство для чтения и замены
    
    var delegate: NotesListAdapterDelegate? { get set }
    
    var items: [NoteItem] { get set }
    
    func updateItems(_ items: [NoteItem]) // Обновить items
}

final class NotesListAdapter: NSObject, NotesListAdapterDataSourceProtocol {
    
    weak var collectionView: UICollectionView?
    
    weak var delegate: NotesListAdapterDelegate?
    
    var items: [NoteItem] = []
    
    func updateItems(_ items: [NoteItem]) {
        self.items = items
        collectionView?.reloadData() // Обновить данные коллекции
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NotesCell.self), for: indexPath) as! NotesCell
        cell.item = NotesCellItem(name: item.title, text: item.text, date: item.date)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.notesListAdapter(self, didSelectNote: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NotesListAdapter: NotesCellDelegate {
    func notesCellDidPressPasswordButton(_ cell: NotesCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        let item = items[indexPath.row]
        delegate?.notesListAdapter(self, didPressPasswordButtonOn: item)
    }
}
