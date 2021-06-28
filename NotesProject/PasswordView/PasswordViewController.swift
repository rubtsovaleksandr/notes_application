//
//  PasswordViewController.swift
//  NotesProject
//
//  Created by Aleksandr on 14/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol PasswordViewProtocol: AnyObject, Presentable {
    
    var presenter: PasswordViewPresenterProtocol { get }
        
    func showSavePasswordView()
    
    func showCheckPasswordView()
    
    func showDeletePasswordView()
    
    func fewNumbers()
    
    func normNumbersGoButton()
    
    func normNumbersSaveButton()
    
    func closePasswordView()
    
    func showPasswordError()
    
    func openCreateView()

}

final class PasswordViewController: UIViewController, PasswordViewProtocol {
    
    
    var presenter: PasswordViewPresenterProtocol
    
    
    let textField = UITextField()
    let goButton = UIButton()
    let saveButton = UIButton()
    let titleLabel = UILabel()
    let errorLabel = UILabel()
    
    init(presenter: PasswordViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.prepareView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textField.textAlignment = .center
        textField.contentVerticalAlignment = .center
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        textField.returnKeyType = UIReturnKeyType.next
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant:-30).isActive = true
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        
        view.addSubview(goButton)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 10).isActive = true
        goButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        goButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        goButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        goButton.setTitle("GO", for: .normal)
        goButton.setTitleColor(.black, for: .normal)
        goButton.layer.borderWidth = 1
        goButton.layer.borderColor = UIColor.black.cgColor
        goButton.layer.cornerRadius = 5
        goButton.isHidden = true
        goButton.addTarget(self, action: #selector(goButtonTouchUpInside), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        saveButton.isHidden = true
        saveButton.addTarget(self, action: #selector(saveButtonTouchUpInside), for: .touchUpInside)
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.text = "НЕВЕРНЫЙ ПАРОЛЬ"
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        errorLabel.isHidden = true
    }
    
    func showSavePasswordView() {
        textField.placeholder = "Создайте пароль"
        titleLabel.text = "Создание пароля заметки"
        goButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    func showCheckPasswordView() {
        textField.placeholder = "Введите пароль"
        titleLabel.text = "Проверка пароля заметки"
        saveButton.isHidden = true
    }
    
    func showDeletePasswordView() {
        textField.placeholder = "Введите пароль"
        titleLabel.text = "Удаление пароля заметки"
        saveButton.isHidden = true
    }
    
    @objc
    func textFieldEditingChanged() {
        presenter.currentPassword = textField.text ?? ""
    }
    
    @objc
    func goButtonTouchUpInside() {
        presenter.pressGoButton()
    }
    
    @objc
    func saveButtonTouchUpInside() {
        presenter.savePassword()
        closePasswordView()
    }
    
    func fewNumbers() {
        goButton.isHidden = true
        saveButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    func normNumbersGoButton() {
        goButton.isHidden = false
        saveButton.isHidden = true
    }
    
    func normNumbersSaveButton() {
        goButton.isHidden = true
        saveButton.isHidden = false
    }
    
    func closePasswordView() {
        navigationController?.popViewController(animated: true)
    }
    
    func showPasswordError() {
        errorLabel.isHidden = false
    }
    
    func openCreateView() {
        let createNoteController = Assembler.createNoteView(noteItem: presenter.noteItem)
        navigationController?.pushViewController(createNoteController.toPresent, animated: true)
    }
}

extension PasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        return presenter.validatePassword(text, nextChar: string)
    }
    
}
