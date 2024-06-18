//
//  CommentInputAccessoryView.swift
//  Instagram
//
//  Created by mangdi on 6/18/24.
//

import UIKit

final class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    private let commentTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter comment.."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 실험
//        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: 8).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func didTapPostButton() {
        
    }
}
