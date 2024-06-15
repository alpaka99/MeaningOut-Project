//
//  CodeBaseBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//
import UIKit

protocol BaseViewBuildable: UIView {
    func configureHierarchy()
    func configureLayout()
    func configureUI()   
    func configureData()
}
