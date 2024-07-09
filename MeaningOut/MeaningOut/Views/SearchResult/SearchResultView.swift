//
//  SearchResultView.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class SearchResultView: BaseView {
    private let totalResultLabel = UILabel()
    private let sortOptions: [SortOptions] = SortOptions.allCases
    private var selectedButton = SortOptions.simularity
    private var imageCache: [String : UIImage] = [:]
    private var likedItems = RealmRepository.shared.readAll(of: LikedItems.self)
    
    private let simularityFilterButton = RoundCornerButton(
        type: .sort(.simularity),
        color: MOColors.moWhite.color
    )
    private let dateFilterButton = RoundCornerButton(
        type: .sort(.date),
        color: MOColors.moWhite.color
    )
    private let ascendingFilterButton = RoundCornerButton(
        type: .sort(.ascendingPrice),
        color: MOColors.moWhite.color
    )
    private let descendingFilterButton = RoundCornerButton(
        type: .sort(.descendingPrice),
        color: MOColors.moWhite.color
    )
    private lazy var buttons: [UIButton] = [
        simularityFilterButton,
        dateFilterButton,
        ascendingFilterButton,
        descendingFilterButton
    ]
    private lazy var horizontalButtonStack = UIStackView(arrangedSubviews: buttons)
    private(set) lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionView.createFlowLayout(
            numberOfRowsInLine: 2,
            spacing: 20
        )
    )
    
    private var searchResult: NaverShoppingResponse = NaverShoppingResponse.dummyNaverShoppingResponse() {
        didSet {
            searchResultChanged()
        }
    }
    
    private var userData = UserData(
        userName: String.emptyString,
        profileImage: ProfileImage.randomProfileImage,
        signUpDate: Date.now,
        likedItems: []
    )
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        MOImageManager.shared.removeCachedImage(objectName: getTypeName())
    }
    
    override internal func configureHierarchy() {
        self.addSubview(totalResultLabel)
        
        configureButtons()
        
        self.addSubview(horizontalButtonStack)
        self.addSubview(resultCollectionView)
    }
    
    override internal func configureLayout() {
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
    
    override internal func configureUI() {
        self.backgroundColor = .white
        
        totalResultLabel.textColor = MOColors.moOrange.color
        totalResultLabel.font = .systemFont(
            ofSize: 12,
            weight: .bold
        )
        
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.spacing = 8
        horizontalButtonStack.distribution = .fillProportionally
        
        resultCollectionView.showsVerticalScrollIndicator = false
        
    }
    
//    internal func configureData(_ state: any BaseViewControllerState) {
//        if let state = state as? SearchResultViewControllerState {
//            searchResult = state.searchResult
//            let userData = state.userData
//            self.userData = userData
//            configureUI()
//        }
//    }
    
    private func searchResultChanged() {
        totalResultLabel.text = "\(searchResult.total.formatted())" + SearchResult.totalResultLabelText
        resultCollectionView.reloadData()
    }
    
    private func configureButtons(_ filterOption: SortOptions = .simularity) {
        for option in sortOptions {
            switch option {
            case .simularity:
                setInitialButtonState(
                    simularityFilterButton,
                    option: option
                )
//                simularityFilterButton.delegate = self
            case .date:
                setInitialButtonState(
                    dateFilterButton,
                    option: option
                )
//                dateFilterButton.delegate = self
            case .ascendingPrice:
                setInitialButtonState(
                    ascendingFilterButton,
                    option: option
                )
//                ascendingFilterButton.delegate = self
            case .descendingPrice:
                setInitialButtonState(
                    descendingFilterButton,
                    option: option
                )
//                descendingFilterButton.delegate = self
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
    
    private func setInitialButtonState(_ button: RoundCornerButton, option: SortOptions) {
        button.tintColor = .black
        button.setBackgroundColor(with: MOColors.moWhite.color)
        button.setBorderLine(
            color: MOColors.moGray100.color,
            width: 1
        )
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 12)
        button.setStringAttribute(attributes)
        button.setTitle(
            option.buttonTitle,
            for: .normal
        )
    }
}

//extension SearchResultView: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return searchResult.items.count
//    }
//    
//    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: SearchResultCollectionViewCell.identifier,
//            for: indexPath
//        ) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
//        
//        let data = searchResult.items[indexPath.row]
//        
//        do {
//            try MOImageManager.shared.fetchImage(
//                objectName: getTypeName(),
//                urlString: data.image
//            ) { image in
//                cell.setImage(with: image)
//            }
//        } catch NetworkError.urlNotGenerated {
//            print("Check Image URL")
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        cell.configureData(data)
//        
//        let likedItem = LikedItems(
//            title: data.title,
//            mallName: data.mallName,
//            lprice: data.lprice,
//            image: data.image,
//            link: data.link,
//            productId: data.productId
//        )
//        
//        if RealmRepository.shared.readLikedItems(likedItem) != nil {
//            cell.toggleIsLiked()
//            cell.setAsLikeItem()
//        }
//        
//        cell.delegate = self
//        
//        return cell
//    }
//    
//    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = searchResult.items[indexPath.row]
//        delegate?.baseViewAction(.searchResultViewAction(.resultCellTapped(data)))
//    }
//    
//}




extension SearchResultView {
    internal func baseViewAction(_ type: BaseViewActionType) {
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
    
    private func likeShoppingItem(_ shoppingItem: ShoppingItem) {
//        delegate?.baseViewAction(.searchResultViewAction(.likeShoppingItem(shoppingItem)))
    }
    
    private func cancelLikeShoppingItem(_ shoppingItem: ShoppingItem) {
//        delegate?.baseViewAction(.searchResultViewAction(.cancelLikeShoppingItem(shoppingItem)))
    }
}

extension SearchResultView: RoundCornerButtonDelegate {
    internal func roundCornerButtonTapped(_ type: RoundCornerButtonType) {
        switch type {
        case .sort(let option):
            configureButtons(option)
//            delegate?.baseViewAction(.searchResultViewAction(.filterOptionButtonTapped(option)))
        default:
            break
        }
    }
}
