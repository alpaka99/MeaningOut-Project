//
//  CodeBaseViewControllerBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

protocol BaseViewController: UIViewController {
    var baseView: BaseView { get }
    
    init(_ baseView: BaseView)

    func configureLayout()
    func configureUI()
    func configureData()
}

extension BaseViewController {
    internal func configureLayout() {
        
    }
    
    internal func configureUI() {
        
    }
    
    internal func configureData() {
        baseView.configureData()
    }
}
