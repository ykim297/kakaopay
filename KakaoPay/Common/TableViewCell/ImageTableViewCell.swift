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
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 16.0)
        name.textColor = .white
        return name
    }()
    
    public static var identifier: String = "ImageTableViewCell"
    public var indexPath: IndexPath?    
    public var height: CGFloat = 0.0
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.photoImageView)
        self.contentView.addSubview(self.nameLabel)
        self.setAutoLayOut()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(name: String,
                      urls: UrlListModel) {

        self.nameLabel.text = name

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
            view.left.right.top.equalTo(self.contentView)
            view.bottom.equalTo(self.contentView).offset(-1.0)
            view.height.equalTo(self.height)
        }
        
        self.nameLabel.snp.makeConstraints { view -> Void in
            view.left.equalTo(self.contentView).offset(20.0)
            view.right.equalTo(self.contentView).offset(-20.0)
            view.bottom.equalTo(self.contentView).offset(-20.0)
            view.height.equalTo(19.0)
        }

    }
}

