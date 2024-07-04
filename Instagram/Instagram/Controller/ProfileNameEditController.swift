//
//  ProfileNameEditController.swift
//  Instagram
//
//  Created by mangdi on 7/4/24.
//

import UIKit

enum ProfileNameType {
    case name
    case username
}

final class ProfileNameEditController: UIViewController {
    
    // MARK: - Properties
    
    var profileNameType: ProfileNameType = .name
    var name: String = ""
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBackward))
        return barButtonItem
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Completion", style: .done, target: self, action: #selector(handleCompletion))
        barButtonItem.tintColor = .systemBlue
        return barButtonItem
    }()
    
    private lazy var nameTextFieldView: UIView = {
        let textFieldView = UIView()
        textFieldView.backgroundColor = .systemBackground
        textFieldView.layer.borderColor = UIColor.black.cgColor
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.cornerRadius = 10
        textFieldView.clipsToBounds = true
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(nameTextField)
        textFieldView.addSubview(nameInfoLabel)
        textFieldView.addSubview(nameResetButton)
        return textFieldView
    }()
    
    private let nameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.height = 40
        textField.backgroundColor = .systemBackground
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .namePhonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var nameResetButton: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @objc private func handleBackward() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleCompletion() {
        
    }
    
    @objc private func handleReset() {
        nameTextField.text = ""
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        switch profileNameType {
        case .name:
            navigationItem.title = "Name"
            nameInfoLabel.text = "Name"
        case .username:
            navigationItem.title = "UserName"
            nameInfoLabel.text = "UserName"
        }
        
        nameTextField.text = name
        
        view.addSubview(nameTextFieldView)
        
        nameTextFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        nameTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        nameTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        nameTextFieldView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameInfoLabel.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor, constant: 16).isActive = true
        nameInfoLabel.topAnchor.constraint(equalTo: nameTextFieldView.topAnchor, constant: 8).isActive = true
        
        nameResetButton.trailingAnchor.constraint(equalTo: nameTextFieldView.trailingAnchor, constant: -16).isActive = true
        nameResetButton.centerYAnchor.constraint(equalTo: nameTextFieldView.centerYAnchor).isActive = true
        nameResetButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        nameResetButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameInfoLabel.bottomAnchor, constant: 0).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor, constant: 16).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: nameResetButton.leadingAnchor, constant: -8).isActive = true
    }
}
