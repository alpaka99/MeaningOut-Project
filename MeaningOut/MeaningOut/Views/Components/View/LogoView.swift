//
//  LogoView.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

import SnapKit

final class LogoView: UIView, BaseViewBuildable {
    
    let type: LogoViewType
    let logoTitle = UILabel()
    let logoImage = UIImageView()
    let userNameLabel = UILabel()
    let startButton = RoundCornerButton(
        type: .plain,
        title: "시작하기",
        color: MOColors.moOrange.color
    )
    
    weak var delegate: BaseViewDelegate?
    
    init(type: LogoViewType) {
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = MOColors.moWhite.color
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureHierarchy() {
        self.addSubview(logoTitle)
        self.addSubview(logoImage)
        self.addSubview(userNameLabel)
        self.addSubview(startButton)
    }
    
    internal func configureLayout() {
        logoTitle.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        logoImage.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
            $0.width.equalTo(self.snp.width)
                .multipliedBy(0.8)
            $0.height.equalTo(logoImage.snp.width)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom)
                .offset(16)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
            $0.height.equalTo(44)
        }
    }
    
    internal func configureUI() {
        self.backgroundColor = MOColors.moWhite.color
        
        logoTitle.font = .systemFont(ofSize: 48, weight: .heavy)
        logoTitle.textAlignment = .center
        
        logoTitle.textColor = MOColors.moOrange.color
        logoTitle.text = "MeaningOut"
        
        logoImage.image = UIImage(named: "launch")
        logoImage.contentMode = .scaleAspectFill
        
        userNameLabel.text = "고석환"
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        userNameLabel.textColor = MOColors.moOrange.color
        
        startButton.delegate = self
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = MOColors.moOrange.color
        
        switch type {
        case .launching:
            self.startButton.isHidden = true
        case .onBoarding:
            self.userNameLabel.isHidden = true
        }
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        
    }
}


enum LogoViewType {
    case launching
    case onBoarding
}

extension LogoView: RoundCornerButtonDelegate {
    func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        delegate?.baseViewAction(.logoViewAction(.startButtonTapped))
    }
}
