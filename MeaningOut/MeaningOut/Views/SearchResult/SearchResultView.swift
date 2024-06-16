//
//  SearchResultView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class SearchResultView: UIView, BaseViewBuildable {
    let totalResultLabel = UILabel()
    let filterOptions: [FilterOption] = FilterOption.allCases
    var selectedButton = FilterOption.simularity
    let horizontalButtonStack = UIStackView()
    lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout(numberOfRowsInLine: 2, spacing: 20)
    )
    var searchResult: [ShoppingItem] = [] {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    
    var delegate: BaseViewBuildableDelegate?
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(totalResultLabel)
        
        filterOptions.forEach { option in
            let roundCornerButton = RoundCornerButton(
                type: .plain,
                title: option.buttonTitle,
                color: .white
            )
            roundCornerButton.tintColor = .black
            roundCornerButton.setBorderLine(color: MOColors.moGray100.color, width: 1)
            var attributes = AttributeContainer()
            attributes.font = UIFont.boldSystemFont(ofSize: 12)
            roundCornerButton.setStringAttribute(attributes)
            
            horizontalButtonStack.addArrangedSubview(roundCornerButton)
        }
        
        self.addSubview(horizontalButtonStack)
        self.addSubview(resultCollectionView)
    }
    
    func configureLayout() {
        totalResultLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
                .inset(16)
        }
        
        horizontalButtonStack.snp.makeConstraints {
            $0.top.equalTo(totalResultLabel.snp.bottom)
                .offset(16)
            $0.leading.equalTo(totalResultLabel.snp.leading)
        }
        
        resultCollectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalButtonStack.snp.bottom)
                .offset(16)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .white
        
        totalResultLabel.textColor = MOColors.moOrange.color
        totalResultLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.spacing = 8
        horizontalButtonStack.distribution = .fillProportionally
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    func configureData(_ data: NaverShoppingResponse) {
        totalResultLabel.text = "\(data.total.formatted())개의 검색 결과"
        searchResult = data.items
    }
    
}

extension SearchResultView: UICollectionViewDelegate, UICollectionViewDataSource {
    func createFlowLayout(numberOfRowsInLine: CGFloat, spacing: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let lengthOfALine = ScreenSize.width - (spacing * CGFloat(2 + numberOfRowsInLine - 1))
        let length = lengthOfALine / numberOfRowsInLine
        
        flowLayout.itemSize = CGSize(width: length, height: 300)
        
        return flowLayout
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        let data = searchResult[indexPath.row]
        cell.configureData(data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchResult[indexPath.row]
        
        //MARK: send data up to ViewController
        
        
    }
    
}

extension SearchResultView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let lastItem = indexPaths.last {
            if lastItem.row >= searchResult.count - 6 {
                // MARK: Prefetch Data from ViewController
//                delegate.prefetch()
            }
        }
    }
}
