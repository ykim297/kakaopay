//
//  SearchView.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/27.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import UIKit

enum SearchType: Int {
    case home
    case search
}

class SearchView: UIView {
    let height: CGFloat = 45.0
    let searchBar: UISearchBar = UISearchBar()

    var type: SearchType = .home
    
    init(type: SearchType) {
        super.init(frame: .zero)
        self.type = type
        self.searchBar.placeholder = "Search Photos"
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = type == .home ? false : true
        self.searchBar.isUserInteractionEnabled = type == .home ? false : true
        
        self.addSubview(self.searchBar)
        self.backgroundColor = .clear
        self.searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        
        if type == .search {
            self.searchBar.becomeFirstResponder()
        }
        self.setAutoLayOut()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchView {
    private func setAutoLayOut() {
        self.searchBar.snp.makeConstraints { view -> Void in
            view.left.equalTo(self.snp.left).offset(20.0)
            view.right.equalTo(self.snp.right).offset(-20.0)
            view.top.equalTo(self.snp.top).offset(12.5)
            view.bottom.equalTo(self.snp.bottom).offset(-12.5)
        }
        
        if self.type == .search {
            
        }
    }
}

extension SearchView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        if #available(iOS 13.0, *) {
            SceneDelegate.shared.rootViewController.homeView()
        } else {
            AppDelegate.shared.rootViewController.homeView()
        }
    }
}

