//
//  BaseView.swift
//  MeaningOut
//
//  Created by user on 7/9/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureUI() { 
        self.backgroundColor = MOColors.moWhite.color
    }
}
