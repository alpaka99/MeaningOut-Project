//
//  DetailSearchView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit
import WebKit

import SnapKit

final class DetailSearchView: UIView, BaseViewBuildable {
    let webView = WKWebView()
    
    weak var delegate: BaseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(webView)
    }
    
    func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
    }
    
    func configureData(_ data: ShoppingItem) {
        
        if let url = URL(string: data.link), let request = try? URLRequest(url: url, method: .get) {
            webView.load(request)
        }
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? DetailSearchViewControllerState {
            print(#function)
            if let url = URL(string: state.shoppingItem.link) {
                webView.load(URLRequest(url: url))
            }
        }
    }
}
