//
//  NotificationCell.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wansToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost post: Post)
    func failedToViewPost(_ cell: NotificationCell)
    func cell(_ cell: NotificationCell, wantsToProfile user: User)
}

final class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: NotificationViewModel? {
        didSet { configureUI() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
        
        followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleProfileImageTapped() {
        guard let user = viewModel?.notification.user else { return }
        
        delegate?.cell(self, wantsToProfile: user)
    }
    
    @objc private func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.notification.isUserFollowed {
        case .loading:
            return
        case .follow:
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.uid)
        case .unfollow:
            delegate?.cell(self, wansToFollow: viewModel.notification.uid)
        }
    }
    
    @objc private func handlePostImageTapped() {
        guard let viewModel = viewModel,
              let post = viewModel.notification.post else {
            delegate?.failedToViewPost(self)
            return
        }
        delegate?.cell(self, wantsToViewPost: post)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        postImageView.isHidden = viewModel.shouldHidePostImage
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
}
