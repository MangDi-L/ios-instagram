//
//  UploadPostController.swift
//  Instagram
//
//  Created by mangdi on 6/12/24.
//

import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
    func controllerDidCanceledUploadingPost()
}

enum UploadPostType {
    case upload
    case modify
}

final class UploadPostController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    var type: UploadPostType = .upload
    var post: Post?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "venom-7")
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter caption.."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeholderShouldCenter = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancelByUpload() {
        delegate?.controllerDidCanceledUploadingPost()
        dismiss(animated: true)
    }
    @objc private func didTapCancelByModify() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShare() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to upload post \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    @objc private func didTapModify() {
        guard var post = post,
              let caption = captionTextView.text else { return }
        
        post.caption = caption
        showLoader(true)
        
        PostService.modifyPost(post: post) { error in
            self.showLoader(false)
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Helpers
    
    private func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        switch type {
        case .upload:
            navigationItem.title = "Upload Post"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelByUpload))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapShare))
        case .modify:
            navigationItem.title = "Modify Post"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelByModify))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Modify", style: .done, target: self, action: #selector(didTapModify))
            
            guard let post = post else { return }
            
            photoImageView.sd_setImage(with: URL(string: post.imageUrl))
            captionTextView.becomeFirstResponder()
            captionTextView.text = post.caption
            captionTextView.placeholderLabel.isHidden = true
            let count = post.caption.count
            characterCountLabel.text = "\(count) / 100"
        }
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 200, width: 200)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        // 오류 유발하는 코드 (원인을 모르겠음)
//        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leadingAnchor, right: view.rightAnchor, paddingTop: 16,
//                                    paddingLeft: 12, paddingRight: -12, height: 64)
        
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            captionTextView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
            captionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            captionTextView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor,
                                   paddingBottom: -8, paddingRight: 12)
    }
}

// MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count) / 100"
    }
}
