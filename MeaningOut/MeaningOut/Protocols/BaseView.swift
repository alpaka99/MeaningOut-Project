//
//  CodeBaseBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//
import UIKit

protocol BaseView: UIView {
    init()
    func configureHierarchy()
    func configureLayout()
    func configureUI()   
    func configureData()
}

extension BaseView {
    init() {
        self.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureData()
    }
}
