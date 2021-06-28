//
//  NotesListEmptyView.swift
//  NotesProject
//
//  Created by Максим Данько on 27.06.2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

final class NotesListEmptyView: UIView {
    
    var onPressButton: (() -> Void)?
    
    private let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 1
        button.layer.shadowColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        button.setTitle("СОЗДАТЬ ЗАМЕТКУ...", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 23, weight: .bold)
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc
    private func pressButton() {
        onPressButton?()
    }
    
}
