//
//  CodeBaseBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//
import UIKit

protocol BaseViewBuildable: UIView {
    var delegate: BaseViewBuildableDelegate? { get set }
    func configureHierarchy()
    func configureLayout()
    func configureUI()   
}

protocol BaseViewBuildableDelegate: AnyObject {
    func baseViewBuildableAction(_ type: BaseViewActionType)
}

enum BaseViewActionType {
    case test
}
