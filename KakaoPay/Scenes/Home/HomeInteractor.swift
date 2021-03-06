//
//  HomeInteractor.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright (c) 2020 Yong Seok Kim. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeBusinessLogic {
    func getPhotoList(request: Home.Search.Request)
}

protocol HomeDataStore {
  //var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
  var presenter: HomePresentationLogic?
  var worker: HomeWorker = HomeWorker()
  //var name: String = ""
  
    // MARK: Do something
    // MARK: Do Connect
    func getPhotoList(request: Home.Search.Request) {
        worker.getPhotoList(model: request, completion: { success, models, error in
            if success, let list = models {
                let response = Home.Search.Response(results: list)
                self.presenter?.presentPhotoList(response: response)
            } else {
                if let errorList = error?.errors {
                    self.presenter?.presentError(message: errorList)
                }
            }
        })
    }

}
