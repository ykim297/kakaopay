//
//  CurrentUserCollectionModel.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/27.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import Foundation

struct CurrentUserCollectionModel: Codable {
    let id: Int
    let title: String
    let published_at: String
    let last_collected_at: String
    let updated_at: String
    let cover_photo: String?
    let user: String?
}
