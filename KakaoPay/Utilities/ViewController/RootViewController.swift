//
//  RootViewController.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

// base RootViewController

import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController?
    var home: UINavigationController?
    var search: UINavigationController?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        homeView()
    }
    
    private func loadingIndicator() {
        
    }
    
    private func closeIndicator() {
        
    }
    
    public func homeView() {
        if let home = self.home {
            self.setNaviController(nc: home)
        } else {
            self.home = UINavigationController(rootViewController: HomeViewController())
            self.setNaviController(nc: self.home!)
        }
    }
    
    public func searchView() {
        if let search = self.search {
            self.setNaviController(nc: search)
        } else {
            self.search = UINavigationController(rootViewController: SearchViewController())
            self.setNaviController(nc: self.search!)
        }
    }
    
    private func setNaviController(nc: UINavigationController) {
        nc.view.backgroundColor = .white
        addChild(nc)
        nc.view.frame = view.bounds
        view.addSubview(nc.view)
        nc.didMove(toParent: self)
        current = nc
    }
}
