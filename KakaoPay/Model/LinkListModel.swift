//
//  LinkListModel.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import Foundation

struct LinkListModel: Codable {
    let `self`: String
    let html: String
    let photos: String?
    let likes: String?
    let portfolio: String?
}
