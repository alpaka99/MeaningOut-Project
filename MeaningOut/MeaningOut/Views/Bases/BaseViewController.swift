//
//  CodeBaseViewControllerBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

class BaseViewController<T: BaseView>: UIViewController {
    
    var baseView: T
    
    init(baseView: T) {
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    func configureNavigationItem() { }
    
    func configureDelegate() { }
}
