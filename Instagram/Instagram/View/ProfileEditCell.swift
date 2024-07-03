//
//  ProfileEditCell.swift
//  Instagram
//
//  Created by mangdi on 7/3/24.
//

import UIKit

final class ProfileEditCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: UserCellViewModel?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(inputNameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        inputNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        inputNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        inputNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        inputNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func configureLabels(name: String, inputName: String) {
        nameLabel.text = name
        inputNameLabel.text = inputName
    }
}
