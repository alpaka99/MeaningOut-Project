//
//  BaseTableViewCell.swift
//  MeaningOut
//
//  Created by user on 7/9/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureHierarchy() { }
        
        func configureLayout() { }
        
        func configureUI() { }
}
