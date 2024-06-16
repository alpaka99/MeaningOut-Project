//
//  CodeBaseViewControllerBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

protocol BaseViewController: UIViewController {
    var baseView: BaseViewBuildable { get }
    
    init(_ baseView: BaseViewBuildable)

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
        
    }
}

protocol BaseViewControllerState {
    
}

protocol CommunicatableBaseViewController: MOBaseViewController {
    associatedtype State: BaseViewControllerState
    var state: State { get }
    func configureData(_ data: State)
}

extension CommunicatableBaseViewController {
    func configureData(_ data: State) {
        baseView.configureData(state)
    }
}
