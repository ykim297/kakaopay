//
//  String+.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import UIKit

extension String {
    
    func extractClassName() -> String {
        guard let fileName = components(separatedBy: "/").last,
            let className = fileName.components(separatedBy: ".").first else {
            return "No FilePath"
        }

        return className
    }
    
}
