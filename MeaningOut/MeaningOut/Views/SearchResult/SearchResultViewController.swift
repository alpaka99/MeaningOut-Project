//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import Alamofire

final class SearchResultViewController: BaseViewController<SearchResultView> {
    internal struct State {
        var searchResult: NaverShoppingResponse
        var userData: UserData
        var keyword: String
        var sortOption: SortOptions
    }
    
    internal var state: State = State(
        searchResult: NaverShoppingResponse.dummyNaverShoppingResponse(),
        userData: UserData.dummyUserData(),
        keyword: String.emptyString,
        sortOption: SortOptions.simularity
    )
    
    private var searchText: String
    
    init(baseView: SearchResultView, searchText: String) {
        self.searchText = searchText
        super.init(baseView: baseView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchData(_:)),
            name: Notification.Name("NaverAPIComplete"),
            object: nil
        )
    }
    
    @objc
    func fetchData(_ notification: NSNotification) {
        guard let data = notification.object as? Data, let decodedData = try? JSONHelper.jsonDecoder.decode(NaverShoppingResponse.self, from: data) else {
            print("decoding failed")
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.state.searchResult.items.append(contentsOf:  decodedData.items)
            self?.state.searchResult.start = decodedData.start
            self?.state.searchResult.total = decodedData.total
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            setStateWithUserData(userData)
        }
    }
    
    internal func fetchSearchResult(
        _ searchText: String,
        sortOptions: SortOptions
    ) {
        state.keyword = searchText
        NaverAPIManager.shared.fetchNaverShoppingResponse(
            .naverShopping(searchText, 1, sortOptions),
            as: NaverShoppingResponse.self
        ) { [weak self] naverShoppingResponse in
            print(#function)
            self?.state.searchResult = naverShoppingResponse
            self?.navigationItem.title = searchText
        }
    }
    
    private func prefetchSearchResult() {
        let nextPage = state.searchResult.start + PageNationConstants.pageAmount
        print(#function, nextPage, state.searchResult.total)
        if nextPage <= state.searchResult.total {
            print(#function, nextPage)
            NaverAPIManager.shared.fetchNaverShoppingResponse(
                .naverShopping(
                    state.keyword,
                    nextPage,
                    state.sortOption
                ),
                as: NaverShoppingResponse.self
            ) { [weak self] naverShoppingResponse in
                if (self?.state.searchResult.start ?? 1) + PageNationConstants.pageAmount <= naverShoppingResponse.start {
                        self?.state.searchResult.items.append(contentsOf: naverShoppingResponse.items)
                        self?.state.searchResult.start = naverShoppingResponse.start
                    }
            }
        }
    }
    
    private func setStateWithUserData(_ userData: UserData) {
        self.state.userData = userData
    }
}


extension SearchResultViewController {
    internal func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .searchResultViewAction(let detailAction):
            switch detailAction {
            case .resultCellTapped(let shoppingItem):
                moveToDetailSearchViewController(shoppingItem)
            case .likeShoppingItem(let shoppingItem):
                addToLikedItems(shoppingItem)
            case .cancelLikeShoppingItem(let shoppingItem):
                removeFromLikedItems(shoppingItem)
            case .prefetchItems:
                prefetchSearchResult()
            case .filterOptionButtonTapped(let sortOption):
                fetchSearchResult(
                    state.keyword,
                    sortOptions: sortOption
                )
            }
        default:
            break
        }
    }
    
    private func moveToDetailSearchViewController(_ shoppingItem: ShoppingItem) {
        let detailSearchViewController = DetailSearchViewController(
            baseView: DetailSearchView(),
            shoppingItem: shoppingItem,
            userData: state.userData
        )
        
        navigationController?.pushViewController(detailSearchViewController, animated: true)
    }
    
    private func addToLikedItems(_ shoppingItem: ShoppingItem) {
        if state.userData.likedItems.contains(where: { $0.productId == shoppingItem.productId }) == false {
            state.userData.likedItems.append(shoppingItem)
            syncData()
        }
    }
    
    private func removeFromLikedItems(_ shoppingItem: ShoppingItem) {
        for i in 0..<state.userData.likedItems.count {
            let likedItem = state.userData.likedItems[i]
            if likedItem.productId == shoppingItem.productId {
                state.userData.likedItems.remove(at: i)
                syncData()
                return
            }
        }
    }
    
    private func syncData() {
        let newUserData = state.userData
        
        if let syncedData = UserDefaults.standard.syncData(newUserData) {
            setStateWithUserData(syncedData)
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func createFlowLayout(numberOfRowsInLine: CGFloat, spacing: CGFloat) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        
        let lengthOfALine = ScreenSize.width - (spacing * CGFloat(2 + numberOfRowsInLine - 1))
        let length = lengthOfALine / numberOfRowsInLine
        
        flowLayout.itemSize = CGSize(
            width: length,
            height: length * 2.0
        )
        
        return flowLayout
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.searchResult.items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        let data = state.searchResult.items[indexPath.row]
        
        do {
            try MOImageManager.shared.fetchImage(
                objectName: getTypeName(),
                urlString: data.image
            ) { image in
                cell.setImage(with: image)
            }
        } catch NetworkError.urlNotGenerated {
            print("Check Image URL")
        } catch {
            print(error.localizedDescription)
        }
        
//        cell.configureData(data)
//        if userData.likedItems.contains(where: { $0.productId == data.productId }) {
//            cell.toggleIsLiked()
//            cell.setAsLikeItem()
//        }
        
//        cell.delegate = self
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = state.searchResult.items[indexPath.row]
//        delegate?.baseViewAction(.searchResultViewAction(.resultCellTapped(data)))
    }
    
}
