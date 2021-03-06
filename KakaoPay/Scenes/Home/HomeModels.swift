//
//  HomeModels.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright (c) 2020 Yong Seok Kim. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Home {
    enum Search {
            struct Request{
                let page: String
                let per_page: String
                let order_by: String
            }
            struct Response: Codable {
                let results: [PhotoModel]
            }
            struct ViewModel {
                var lists: [PhotoModel]
                var urls: [String]
                var pageCount: Int = 0
            }
    }
}
