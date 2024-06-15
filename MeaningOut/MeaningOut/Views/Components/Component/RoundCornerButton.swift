//
//  RoundCornerButton.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class RoundCornerButton: UIButton {
    let type: RoundCornerButtonType
    let title: String?
    let image: UIImage?
    let color: UIColor
    
    weak var delegate: RoundCornerButtonDelegate?
    
    init(
        type: RoundCornerButtonType,
        title: String? = nil,
        image: UIImage? = nil,
        color: UIColor
    ) {
        self.type = type
        self.title = title
        self.image = image
        self.color = color
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = color
        config.cornerStyle = .capsule
        
        switch type {
        case .plain:
            config.title = title
        case .image:
            config.image = image
        }
        
        self.configuration = config
        self.tintColor = .white
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc func buttonTapped() {
        delegate?.roundCornerButtonTapped()
    }
}

enum RoundCornerButtonType {
    case plain
    case image
}


protocol RoundCornerButtonDelegate: AnyObject {
    func roundCornerButtonTapped()
}
