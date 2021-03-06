//
//  SearchRouter.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/27.
//  Copyright (c) 2020 Yong Seok Kim. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol SearchRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SearchDataPassing {
  var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing {
  weak var viewController: SearchViewController?
  var dataStore: SearchDataStore?    
  // MARK: Navigation
  
  //func navigateToSomewhere(source: SearchViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: SearchDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
