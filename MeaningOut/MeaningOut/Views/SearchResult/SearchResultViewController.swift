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
    
    private var likedItems: [LikedItems] = []
    
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
            self?.baseView.resultCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedItems = Array(RealmRepository.shared.readAll(of: LikedItems.self))
        baseView.resultCollectionView.reloadData()
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.resultCollectionView.delegate = self
        baseView.resultCollectionView.dataSource = self
        baseView.resultCollectionView.prefetchDataSource = self
        baseView.resultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
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
            self?.state.searchResult = naverShoppingResponse
            self?.navigationItem.title = searchText
            self?.baseView.resultCollectionView.reloadData()
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
            shoppingItem: shoppingItem
        )
        
        navigationController?.pushViewController(detailSearchViewController, animated: true)
    }
    
    private func addToLikedItems(_ shoppingItem: ShoppingItem) {
        let data = LikedItems(
            title: shoppingItem.title,
            mallName: shoppingItem.mallName,
            lprice: shoppingItem.lprice, image: shoppingItem.image,
            link: shoppingItem.link,
            productId: shoppingItem.productId
        )
        
        if RealmRepository.shared.readLikedItems(data) == nil {
            RealmRepository.shared.create(data)
        }
    }
    
    private func removeFromLikedItems(_ shoppingItem: ShoppingItem) {
        let data = LikedItems(
            title: shoppingItem.title,
            mallName: shoppingItem.mallName,
            lprice: shoppingItem.lprice,
            image: shoppingItem.image,
            link: shoppingItem.link,
            productId: shoppingItem.productId
        )
        
        if let likedItem = RealmRepository.shared.readLikedItems(data) {
            RealmRepository.shared.delete(likedItem) // 생성한 data 말고, realm에서 꺼내온값만 다시 넣어서 삭제할 수 있음
        }
    }
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        addToLikedItems(sender.tag)
        
        likedItems = Array(RealmRepository.shared.readAll(of: LikedItems.self))
        baseView.resultCollectionView.reloadData()
    }
    
    private func addToLikedItems(_ index: Int) {
        let item = state.searchResult.items[index]
        let data = LikedItems(
            title: item.title,
            mallName: item.mallName,
            lprice: item.lprice,
            image: item.image,
            link: item.link,
            productId: item.productId
        )
        
        if RealmRepository.shared.readLikedItems(data) != nil {
            removeFromLikedItems(index)
        } else {
            RealmRepository.shared.create(data)
        }
    }
    
    private func removeFromLikedItems(_ index: Int) {
        
        let item = state.searchResult.items[index]
        let data = LikedItems(
            title: item.title,
            mallName: item.mallName,
            lprice: item.lprice,
            image: item.image,
            link: item.link,
            productId: item.productId
        )
        if let target = RealmRepository.shared.readLikedItems(data) {
            RealmRepository.shared.delete(target)
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
        
        cell.configureData(data)
        if likedItems.contains(where: { $0.productId == data.productId }) {
            print("Liked!")
            cell.toggleIsLiked()
            cell.setAsLikeItem()
        }
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
//
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = state.searchResult.items[indexPath.row]
        
        let vc = DetailSearchViewController(baseView: DetailSearchView(), shoppingItem: data)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    internal func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let lastItem = indexPaths.last {
            if lastItem.row >= state.searchResult.items.count - 4 {
                prefetchSearchResult()
            }
        }
    }
}
