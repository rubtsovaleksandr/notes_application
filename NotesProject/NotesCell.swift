//
//  NotesCell.swift
//  NotesProject
//
//  Created by Aleksandr on 03/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol NotesCellDelegate: AnyObject {
    func notesCellDidPressPasswordButton(_ cell: NotesCell)
}

struct NotesCellItem {
    let name: String
    let text: String
    let date: String
}

final class NotesCell: UICollectionViewCell {
    
    var item: NotesCellItem? {
        didSet {
            nameCell.text = item?.name
            contentCell.text = item?.text
            dateCell.text = item?.date
        }
    }
    
    weak var delegate: NotesCellDelegate?
    
    private let nameCell = UILabel()
    private let contentCell = UILabel()
    private let dateCell = UILabel()
    private let passButton = UIButton(type: .infoDark)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)

        contentView.addSubview(nameCell)
        nameCell.translatesAutoresizingMaskIntoConstraints = false
        nameCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        nameCell.text = ""
        nameCell.textAlignment = .left
        nameCell.textColor = .black
        nameCell.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        contentView.addSubview(dateCell)
        dateCell.translatesAutoresizingMaskIntoConstraints = false
        dateCell.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        dateCell.topAnchor.constraint(equalTo: nameCell.bottomAnchor, constant: 10).isActive = true
        dateCell.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateCell.text = ""
        dateCell.textColor = .black
        dateCell.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        contentView.addSubview(contentCell)
        contentCell.translatesAutoresizingMaskIntoConstraints = false
        contentCell.leftAnchor.constraint(equalTo: dateCell.rightAnchor, constant: 10).isActive = true
        contentCell.topAnchor.constraint(equalTo: nameCell.bottomAnchor, constant: 10).isActive = true
        contentCell.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        contentCell.text = ""
        contentCell.textColor = .gray
        contentCell.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubview(passButton)
        passButton.translatesAutoresizingMaskIntoConstraints = false
        passButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        passButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        passButton.tintColor = .black
        passButton.addTarget(self, action: #selector(passButtonTouchUpInside), for: .touchUpInside)
    }
    
    @objc
    func passButtonTouchUpInside() {
        delegate?.notesCellDidPressPasswordButton(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
