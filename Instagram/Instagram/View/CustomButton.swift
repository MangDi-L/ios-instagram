//
//  CustomButton.swift
//  Instagram
//
//  Created by mangdi on 5/30/24.
//

import UIKit

final class CustomButton: UIButton {
    init(buttonName: String) {
        super.init(frame: .zero)
        
        setTitle(buttonName, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        layer.cornerRadius = 5
        setHeight(50)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
