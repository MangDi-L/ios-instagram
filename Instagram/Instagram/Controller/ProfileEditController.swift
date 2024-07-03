//
//  ProfileEditController.swift
//  Instagram
//
//  Created by mangdi on 7/3/24.
//

import UIKit
import YPImagePicker

private let reuseIdentifier = "ProfileEditCell"

protocol ProfileEditControllerDelegate: AnyObject {
    func profileImageChanged(user: User)
}

final class ProfileEditController: UIViewController {

    // MARK: - Properties
    
    var user: User? {
        didSet {
            cellCounts = 2
            profileImageView.sd_setImage(with: URL(string: user?.profileImageUrl ?? ""))
        }
    }
    
    var delegate: ProfileEditControllerDelegate?
    var cellCounts: Int = 0
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var profileImageChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
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
    
    @objc private func handleEdit() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
        
        didFinishPickingMedia(picker)
    }
    
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
    
    private func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            if cancelled {
                self.dismiss(animated: true)
                return
            }
            
            // 자연스런 화면이동을 위해 animated는 false로 설정
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image,
                      let user = self.user else { return }
                
                self.showLoader(true)
                
                UserService.updateUserProfileImage(user: user, image: selectedImage) { user in
                    self.showLoader(false)
                    self.profileImageView.image = selectedImage
                    self.delegate?.profileImageChanged(user: user)
                }
            }
        }
    }
}

extension ProfileEditController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCounts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProfileEditCell ?? ProfileEditCell()
        
        guard let user = user else { return ProfileEditCell() }
        
        if indexPath == IndexPath(row: 0, section: 0) {
            cell.configureLabels(name: "Name", inputName: user.fullname)
        } else if indexPath == IndexPath(row: 1, section: 0) {
            cell.configureLabels(name: "Username", inputName: user.username)
        }
        
        return cell
    }
}

//extension ProfileEditController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//}
