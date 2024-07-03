//
//  ProfileEditController.swift
//  Instagram
//
//  Created by mangdi on 7/3/24.
//

import UIKit

final class ProfileEditController: UIViewController {

    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let profileImageChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Edit Profile"
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        profileImageView.centerX(inView: view)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        view.addSubview(profileImageChangeButton)
        profileImageChangeButton.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        profileImageChangeButton.centerX(inView: view)
        
        view.addSubview(tableView)
        tableView.anchor(top: profileImageChangeButton.bottomAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 16)
    }
}
