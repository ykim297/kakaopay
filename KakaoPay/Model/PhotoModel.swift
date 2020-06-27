//
//  PhotoModel.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let created_at: String?
    let updated_at: String?
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let liked_by_user: Bool?
    let description: String?
    let user: UserModel
    let current_user_collections: [CurrentUserCollectionModel]?
    let urls: UrlListModel
    let links: LinkListModel
    
}
