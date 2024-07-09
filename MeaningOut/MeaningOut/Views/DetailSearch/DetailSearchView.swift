//
//  DetailSearchView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit
import WebKit

import SnapKit

final class DetailSearchView: BaseView {
    private(set) var webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func configureHierarchy() {
        self.addSubview(webView)
    }
    
    override internal func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override internal func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
    }
}
