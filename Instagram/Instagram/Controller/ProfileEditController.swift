//
//  ProfileEditController.swift
//  Instagram
//
//  Created by mangdi on 7/3/24.
//

import UIKit

private let reuseIdentifier = "ProfileEditCell"

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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 40
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
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

extension ProfileEditController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileEditCell ?? ProfileEditCell()
        
        if indexPath == IndexPath(row: 0, section: 0) {
            cell.configureLabels(name: "Name", inputName: "asdf")
        } else if indexPath == IndexPath(row: 1, section: 0) {
            cell.configureLabels(name: "Username", inputName: "ffff")
        }
        
        return cell
    }
}
