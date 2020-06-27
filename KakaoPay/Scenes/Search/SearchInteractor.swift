//
//  SearchInteractor.swift
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

protocol SearchBusinessLogic {
    func searchPhotoList(request: Search.Search.Request)
}

protocol SearchDataStore {
    //var name: String { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker = SearchWorker()
    //var name: String = ""
    
    // MARK: Do something
    // MARK: Do Connect
     func searchPhotoList(request: Search.Search.Request) {
        worker.searchPhotoList(model: request, completion: { success, model, error in
            if success, let item = model {
                let response = Search.Search.Response(total: item.total,
                                                      totalPages: item.totalPages,
                                                      results: item.results)
                self.presenter?.presentSearchPhotoList(response: response)
            } else {
                if let errorList = error?.errors {
                    self.presenter?.presentError(message: errorList)
                }
            }
        })
    }

}
