//
//  HomeViewController.swift
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
import RxCocoa
import RxSwift
import SnapKit
import Nuke
import BFRImageViewer

protocol HomeDisplayLogic: class {
    func display(model: Home.Search.Response)
    func displayError(message: [String])
}

class HomeViewController: BaseViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    fileprivate var disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.register(cellType: ImageTableViewCell.self)
        tableView.contentInsetAdjustmentBehavior = .never

        return tableView
    }()
    
    let photos: BehaviorRelay<[PhotoModel]> = BehaviorRelay(value: [])
    var itemList: Home.Search.ViewModel?
    var isConnecting: Bool = false
    var imageSlideVC: BFRImageViewController?
    let searchBar: SearchView = SearchView(type: .home)
    let tableViewHeader: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.width, height: 300.0))
    let backGroundImageView: UIImageView = UIImageView()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                selector: #selector(dismissFromSlideImageView),
                name: NSNotification.Name(rawValue: NOTE_VC_SHOULD_CANCEL_CUSTOM_TRANSITION),
                object: nil)
                
        self.requestData()
        self.setComponents()
        self.setSearchBar()
        self.setTableViewCell()
        self.setImageCache()
    }
    
    // MARK: Do request Data
    
    func requestData(pageNumber: Int = 1) {
        self.isConnecting = true
        let request = Home.Search.Request(page: String(pageNumber),
                                          per_page: "20",
                                          order_by: "lastest")
        
        interactor?.getPhotoList(request: request)
    }
                
    func display(model: Home.Search.Response) {
        var urls: [String] = []
        for url in model.results {
            urls.append(url.urls.regular)
        }

        if let imageUrl = URL(string: urls.last ?? "") {
            self.backGroundImageView.contentMode = .scaleAspectFill
            Nuke.loadImage(with: imageUrl, into: self.backGroundImageView) { _ in
//                self.view.setNeedsLayout()
//                self.layoutIfNeeded()
            }
        }
        
        if itemList == nil {
            itemList = Home.Search.ViewModel(lists: model.results, urls:urls, pageCount: 1)
            
        } else {
            itemList?.lists.append(contentsOf: model.results)
            itemList?.urls.append(contentsOf: urls)
            itemList?.pageCount += 1
        }
        
        self.photos.accept(self.itemList!.lists)
        self.tableView.reloadData()
        self.isConnecting = false
    }
    
    func displayError(message: [String]) {
        var msg: String = String()
        for text in message {
            msg.append(contentsOf: "\(text)\n")
        }
        alert("Error", message: msg)
    }
    
    private func setImageCache() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        let pipeLine = ImagePipeline {
            let imageCache = try! DataCache(name: "com.fairPoint.kakaoPay.dataCache")
            imageCache.sizeLimit = 200 * 1024 * 1024
            $0.dataCache = imageCache
        }
        
        ImagePipeline.shared = pipeLine
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTE_VC_SHOULD_CANCEL_CUSTOM_TRANSITION), object: nil)
    }
}

extension HomeViewController {
    private func setComponents() {
        //todo: like unsplash app, put animation on searchBar and tableViewHeader
        tableViewHeader.backgroundColor = .clear
        self.tableView.tableHeaderView = tableViewHeader
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)

        self.searchBar.searchBar.resignFirstResponder()
        self.view.addSubview(self.backGroundImageView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.searchBar)
        self.setAutolayOut()
    }
    
    private func setAutolayOut() {
        self.backGroundImageView.snp.makeConstraints { view -> Void in
            view.left.right.equalTo(self.view)
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            view.height.equalTo(300.0)
        }

        self.searchBar.snp.makeConstraints { view -> Void in
            view.left.right.equalTo(self.view)
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(120.0)
            view.height.equalTo(60.0)
        }
        
        self.tableView.snp.makeConstraints { view -> Void in
            view.left.right.equalTo(self.view)
            view.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
}

// Event
extension HomeViewController {
    @objc func dismissFromSlideImageView(){
        let row = self.imageSlideVC?.currentIndex ?? 0
        let indexPath = IndexPath(item: row, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
}


// RxSearchBar
extension HomeViewController {
    private func setSearchBar() {
        let tapGesture = UITapGestureRecognizer()
        self.searchBar.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { recognizer in
            if #available(iOS 13.0, *) {
                SceneDelegate.shared.rootViewController.searchView()
            } else {
                AppDelegate.shared.rootViewController.searchView()
            }
        }).disposed(by: disposeBag)
    }
}

// RxTableView
extension HomeViewController {
    private func setTableViewCell() {
        self.setTableViewDataSource()
        self.setTableViewSelection()
    }
    
    private func setTableViewDataSource() {        
        photos.asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let list = self.itemList else {
                    return UITableViewCell()
                }
                
                let indexPath = IndexPath(item: row, section: 0)
                let cell = self.tableView.dequeueReusableCell(for: indexPath,
                                                              cellType: ImageTableViewCell.self)
                let item: PhotoModel = list.lists[indexPath.row]
                cell.height = CGFloat((item.height * Int(UIScreen.width))/item.width)
                cell.setup(name: item.user.name, urls: item.urls)
                return cell
        }
        .disposed(by: disposeBag)

    }
    
    private func setTableViewSelection() {
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard let list = self.itemList else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)
                self.imageSlideVC = nil
                self.imageSlideVC = BFRImageViewController(imageSource: list.urls)
                self.imageSlideVC!.startingIndex = indexPath.row
                self.present(self.imageSlideVC!, animated: true, completion: nil)
                                
            }).disposed(by: self.disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = self.itemList else {
            return 0
        }
        return list.lists.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let list = self.itemList else {
            return
        }
        let loadIndex = list.lists.count - 5
        if indexPath.row > loadIndex && self.isConnecting == false {            
            self.requestData(pageNumber: self.itemList!.pageCount + 1)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 120) {
            self.searchBar.snp.updateConstraints { view -> Void in
                view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }
        } else {
            self.searchBar.snp.updateConstraints { view -> Void in
                view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(120.0 - scrollView.contentOffset.y)
            }
        }
    }
}

