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
    let sortOptions: [SortOptions] = SortOptions.allCases
    var selectedButton = SortOptions.simularity
    
    
    lazy var simularityFilterButton = RoundCornerButton(
        type: .sort(.simularity),
        color: MOColors.moWhite.color
    )
    lazy var dateFilterButton = RoundCornerButton(
        type: .sort(.date),
        color: MOColors.moWhite.color
    )
    lazy var ascendingFilterButton = RoundCornerButton(
        type: .sort(.ascendingPrice),
        color: MOColors.moWhite.color
    )
    lazy var descendingFilterButton = RoundCornerButton(
        type: .sort(.descendingPrice),
        color: MOColors.moWhite.color
    )
    lazy var buttons: [UIButton] = [
        simularityFilterButton,
        dateFilterButton,
        ascendingFilterButton,
        descendingFilterButton
    ]
    lazy var horizontalButtonStack = UIStackView(arrangedSubviews: buttons)
    lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout(numberOfRowsInLine: 2, spacing: 20)
    )
    
    var searchResult: NaverShoppingResponse = NaverShoppingResponse(start: 1, total: 0, items: []) {
        didSet {
            searchResultChanged()
        }
    }
    
    var userData = UserData(
        userName: "",
        profileImage: ProfileImage.randomProfileImage,
        signUpDate: Date.now,
        likedItems: []
    )
    
    var delegate: BaseViewDelegate?
    
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
        
        configureButtons()
        
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
        resultCollectionView.showsVerticalScrollIndicator = false
    }
    
    func configureData(_ state: any BaseViewControllerState) {
        if let state = state as? SearchResultViewControllerState {
            searchResult = state.searchResult
            let userData = state.userData
            self.userData = userData
            configureUI()
        }
    }
    
    func searchResultChanged() {
        totalResultLabel.text = "\(searchResult.total.formatted())개의 검색결과"
        resultCollectionView.reloadData()
    }
    
    func configureButtons(_ filterOption: SortOptions = .simularity) {
        for option in sortOptions {
            switch option {
            case .simularity:
                setInitialButtonState(simularityFilterButton, option: option)
                simularityFilterButton.delegate = self
            case .date:
                setInitialButtonState(dateFilterButton, option: option)
                dateFilterButton.delegate = self
            case .ascendingPrice:
                setInitialButtonState(ascendingFilterButton, option: option)
                ascendingFilterButton.delegate = self
            case .descendingPrice:
                setInitialButtonState(descendingFilterButton, option: option)
                descendingFilterButton.delegate = self
            }
        }
        
        switch filterOption {
        case .simularity:
            simularityFilterButton.setAsFilterOption()
        case .date:
            dateFilterButton.setAsFilterOption()
        case .ascendingPrice:
            ascendingFilterButton.setAsFilterOption()
        case .descendingPrice:
            descendingFilterButton.setAsFilterOption()
        }
        
        horizontalButtonStack.arrangedSubviews.forEach { subView in
            horizontalButtonStack.removeArrangedSubview(subView)
        }
        
        buttons = [
            simularityFilterButton,
            dateFilterButton,
            ascendingFilterButton,
            descendingFilterButton
        ]
        
        buttons.forEach { button in
            horizontalButtonStack.addArrangedSubview(button)
        }
    }
    
    func setInitialButtonState(_ button: RoundCornerButton, option: SortOptions) {
        button.tintColor = .black
        button.setBackgroundColor(with: MOColors.moWhite.color)
        button.setBorderLine(color: MOColors.moGray100.color, width: 1)
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 12)
        button.setStringAttribute(attributes)
        button.setTitle(
            option.buttonTitle,
            for: .normal
        )
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
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        let data = searchResult.items[indexPath.row]
        cell.configureData(data)
        if userData.likedItems.contains(where: { $0.productId == data.productId }) {
            cell.isLiked = true
            cell.setAsLikeItem()
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = searchResult.items[indexPath.row]
        
        delegate?.baseViewAction(.searchResultViewAction(.resultCellTapped(data)))
    }
    
}

extension SearchResultView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let lastItem = indexPaths.last {
            if lastItem.row >= searchResult.items.count - 6 {
                delegate?.baseViewAction(.searchResultViewAction(.prefetchItems))
            }
        }
    }
}


extension SearchResultView: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .searchCollectionViewCellAction(let detailAction):
            switch detailAction {
            case .likeShoppingItem(let shoppingItem):
                likeShoppingItem(shoppingItem)
            case .cancelLikeShoppingItem(let shoppingItem):
                cancelLikeShoppingItem(shoppingItem)
            }
        default:
            break
        }
    }
    
    func likeShoppingItem(_ shoppingItem: ShoppingItem) {
        delegate?.baseViewAction(.searchResultViewAction(.likeShoppingItem(shoppingItem)))
    }
    
    func cancelLikeShoppingItem(_ shoppingItem: ShoppingItem) {
        delegate?.baseViewAction(.searchResultViewAction(.cancelLikeShoppingItem(shoppingItem)))
    }
}


extension SearchResultView: RoundCornerButtonDelegate {
    func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        switch type {
        case .sort(let option):
            configureButtons(option)
            delegate?.baseViewAction(.searchResultViewAction(.filterOptionButtonTapped(option)))
        default:
            break
        }
    }
}
