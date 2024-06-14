//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit
import SnapKit

class MOBaseViewController: UIViewController, BaseViewController {
    var baseView: BaseView
    
    required init(_ baseView: BaseView) {
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    
    func configureUI() {
        
    }
    
    func configureData() {
        
    }
    
    func configureLayout() {
        
    }
}

