//
//  Constants.swift
//  MeaningOut
//
//  Created by user on 6/13/24.
//

import UIKit

enum MOColors: CaseIterable {
    case moOrange
    case moBlack
    case moGray100
    case moGray200
    case moGray300
    case moWhite
    
    
    var color: UIColor {
        switch self {
        case .moOrange:
            return UIColor.hexToColor("#EF8947") ?? .clear
        case .moBlack:
            return UIColor.hexToColor("#000000") ?? .clear
        case .moGray100:
            return UIColor.hexToColor("#4C4C4C") ?? .clear
        case .moGray200:
            return UIColor.hexToColor("#828282") ?? .clear
        case .moGray300:
            return UIColor.hexToColor("#CDCDCD") ?? .clear
        case .moWhite:
            return UIColor.hexToColor("#FFFFFF") ?? .clear
        }
    }
}


struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}


enum ProfileImage: String, CaseIterable, Codable {
    case profile_0
    case profile_1
    case profile_2
    case profile_3
    case profile_4
    case profile_5
    case profile_6
    case profile_7
    case profile_8
    case profile_9
    case profile_10
    case profile_11
    
    static var randomProfileImage: ProfileImage {
        if let randomProfileImage = Self.allCases.randomElement() {
            return randomProfileImage
        }
        return .profile_0
    }
}


enum SortOptions: String, CaseIterable {
    case simularity = "sim"
    case date = "date"
    case ascendingPrice = "asc"
    case descendingPrice = "dsc"
    
    var buttonTitle: String {
        switch self {
        case .simularity:
            return "정확도"
        case .date:
            return "날짜순"
        case .ascendingPrice:
            return "가격높은순"
        case .descendingPrice:
            return "가격낮은순"
        }
    }
}

enum SettingOptions: CaseIterable {
    case liked
    case qna
    case oneOnOneQuestion
    case notification
    case quit
    
    var trailingImageName: String? {
        switch self {
        case .liked:
            return "like_selected"
        default:
            return nil
        }
    }
    
    var leadingTitle: String? {
        switch self {
        case .liked:
            return "나의 장바구니 목록"
        case .qna:
            return "자주 묻는 질문"
        case .oneOnOneQuestion:
            return "1:1 문의"
        case .notification:
            return "알림 설정"
        case .quit:
            return "탈퇴하기"
        }
    }
    
    func getTrailingText(_ count: Int) -> String? {
        switch self {
        case .liked:
            return "\(count)개의 상품"
        default:
            return nil
        }
    }
}


struct JSONHelper {
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
}
