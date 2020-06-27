//
//  UrlListModel.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/27.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import Foundation

struct UrlListModel: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
