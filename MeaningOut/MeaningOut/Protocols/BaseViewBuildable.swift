//
//  CodeBaseBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//
import UIKit

protocol BaseViewBuildable: UIView {
    init()
    func configureHierarchy()
    func configureLayout()
    func configureUI()   
    func configureData()
}

extension BaseViewBuildable {
    init() {
        self.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureData()
    }
}
