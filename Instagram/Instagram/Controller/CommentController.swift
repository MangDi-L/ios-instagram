//
//  CommentController.swift
//  Instagram
//
//  Created by mangdi on 6/18/24.
//

import UIKit

private let reuseIdentifier = "CommentCell"

final class CommentController: UICollectionViewController {
    
    // MARK: - Properties
    
    private lazy var commtentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let view = CommentInputAccessoryView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    
    // 실험
//    override var inputAccessoryView: UIView? {
//        get { return commtentInputView }
//    }
    
    // 실험
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Comments"
        self.collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
