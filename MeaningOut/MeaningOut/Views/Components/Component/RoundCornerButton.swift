//
//  RoundCornerButton.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class RoundCornerButton: UIButton {
    private let type: RoundCornerButtonType
    private let title: String?
    private let image: UIImage?
    private let color: UIColor
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    internal func configureUI() {
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = color
        config.cornerStyle = .capsule
        
        switch type {
        case .plain:
            if let title = title {
                let attributeContainer = AttributeContainer()
                config.attributedTitle = AttributedString(
                    title,
                    attributes: attributeContainer
                )
            }
        case .image:
            config.image = image
        case .sort(let filterOption):
            break
        }
        
        self.configuration = config
        self.tintColor = .white
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    internal func setBorderLine(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    internal func setStringAttribute(_ attributes: AttributeContainer) {
        if let title = self.title {
            var config = self.configuration
            config?.attributedTitle = AttributedString(
                title,
                attributes: attributes
            )
            
            self.configuration = config
        }
    }
    
    internal func setAsFilterOption() {
        self.tintColor = .white
        setBackgroundColor(with: MOColors.moGray100.color)
    }
    
    internal func setBackgroundColor(with color: UIColor) {
        var config = self.configuration
        config?.background.backgroundColor = color
        self.configuration = config
    }
}
