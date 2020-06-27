//
//  ImageTableViewCell.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/27.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import UIKit
import Nuke

class ImageTableViewCell: UITableViewCell, Reusable {
    private let photoImageView: UIImageView = UIImageView()
    public static var identifier: String = "ImageTableViewCell"
    public var indexPath: IndexPath?    
    public var height: CGFloat = 0.0
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.photoImageView)
        self.setAutoLayOut()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(urls: UrlListModel, width: Int, height: Int) {
        self.photoImageView.snp.updateConstraints { view -> Void in
            view.height.equalTo(self.height)
        }

        if let imageUrl = URL(string: urls.thumb) {
            self.photoImageView.contentMode = .scaleAspectFill
            Nuke.loadImage(with: imageUrl, into: self.photoImageView) { _ in
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
}

extension ImageTableViewCell {
    private func setAutoLayOut() {
        self.photoImageView.snp.makeConstraints { view -> Void in
            view.left.right.top.bottom.equalTo(self.contentView)
            view.height.equalTo(self.height)
        }
    }
}

