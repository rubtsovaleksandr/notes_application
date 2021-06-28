//
//  CreateNoteController.swift
//  NotesProject
//
//  Created by Aleksandr on 03/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol CreateNoteViewControllerProtocol: AnyObject, Presentable {
    
    var presenter: CreateNotePresenterProtocol { get }
    
    func activateRightBarButtonItem()
    
    func deactivateRightBarButtonItem()
    
}

final class CreateNoteViewController: UIViewController, CreateNoteViewControllerProtocol {
    
    let presenter: CreateNotePresenterProtocol

    private let titleTextField = UITextField()
    private let textView = UITextView()
    private let deleteToolbar = UIToolbar()
    
    private var isSetDeleteToolbar = false
    
    init(presenter: CreateNotePresenterProtocol) {
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
        setupDeleteToolbar()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isSetDeleteToolbar {
            isSetDeleteToolbar = true
            deleteToolbar.frame = CGRect(x: view.bounds.width - 100, y: view.bounds.height - 100, width: 60, height: 50)
            self.titleTextField.becomeFirstResponder()
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        titleTextField.placeholder = "Название заметки"
        titleTextField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleTextField.addTarget(self, action: #selector(editingChangedTitleNote), for: .editingChanged)
        titleTextField.adjustsFontSizeToFitWidth = true
        titleTextField.minimumFontSize = 14
        titleTextField.text = presenter.title
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.delegate = self
        textView.text = presenter.text
    }
    
    func setupDeleteToolbar() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashClick))
        view.addSubview(deleteToolbar)
        deleteToolbar.backgroundColor = .white
        deleteToolbar.isHidden = true
        deleteToolbar.setItems([trashButton], animated: true)
        if presenter.needShowDeleteToolbar { deleteToolbar.isHidden = false }
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressLeftBarButtonItem))
    }
    
    @objc
    func trashClick() {
        presenter.deleteNotes()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func pressLeftBarButtonItem() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc
    func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let valueRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: valueRect.cgRectValue.height, right: 0)
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: valueRect.cgRectValue.height, right: 0)
        if let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int, let animationCurve = UIView.AnimationCurve(rawValue: keyboardAnimationCurve)  {
            let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: animationCurve) {
                self.deleteToolbar.frame = CGRect(x: self.view.bounds.width - 100, y: self.view.bounds.height - 100 - valueRect.cgRectValue.height, width: 60, height: 50)
            }
            animator.startAnimation()
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        textView.contentInset = .zero
        textView.scrollIndicatorInsets = .zero
        guard let userInfo = notification.userInfo else { return }
        if let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int, let animationCurve = UIView.AnimationCurve(rawValue: keyboardAnimationCurve)  {
            let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: animationCurve) {
                self.deleteToolbar.frame = CGRect(x: self.view.bounds.width - 100, y: self.view.bounds.height - 100, width: 60, height: 50)
            }
            animator.startAnimation()
        }
    }
    
    @objc
    func editingChangedTitleNote() {
        presenter.title = titleTextField.text ?? ""
        presenter.validate()
    }
    
    func activateRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButton))
    }
    
    func deactivateRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: nil, action: nil)
    }
    
}

extension CreateNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        presenter.text = textView.text ?? ""
        presenter.validate()
    }
    
    @objc
    func saveButton() {
        presenter.pressSaveButton()
        navigationController?.popToRootViewController(animated: true)
    }
}
