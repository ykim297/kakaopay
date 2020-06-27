//
//  UserModel.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let username: String
    let name: String
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let total_likes: Int?
    let total_photos: Int?
    let total_collections: Int?
    let instagram_username: String?
    let twitter_username: String?
    let profile_image: ProfileImageListModel?
    let links: LinkListModel
}
