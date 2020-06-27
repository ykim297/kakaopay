//
//  NetworkManager.swift
//  KakaoPay
//
//  Created by Yong Seok Kim on 2020/06/26.
//  Copyright © 2020 Yong Seok Kim. All rights reserved.
//

import UIKit
import Alamofire

struct AlamofireManager {
    static var shared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}

struct AlamofireHeaders {
    static func createHeader() -> [String: String] {
        var dic: [String: String] = Dictionary()
        dic["Authorization"] = "Client-ID FS5WBVkEHM9RcupQlKsDavHRYfLRKEBMQwjrxkH6ZXE"
        return dic
    }
}

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class NetworkManager {
    static var downloadFiles: [Any] = [Any]()
    static var isDownloading: Bool = false

    class func responseLog(response: DataResponse<Any>) {
        Log.trace("Response Log:  Begin ============================== ")
        if let request = response.request {
            Log.trace("Request: \(request)")
        }
        if let respond = response.response {
            Log.trace("Respond: \(respond)")
        }
        if let result = response.result.value as? [String: Any] {
            Log.trace("Result: \(result)")
        }
        Log.trace("Response Log:  End ================================= ")
    }

    class func request(
        method: HTTPMethod,
        url: String,
        param: [String: Any]?,
        completion: @escaping (Data, Bool) -> Void
    ) {
        if !Connectivity.isConnectedToInternet {
            Log.warning("Yes! internet is not available.")
            return
        }

        activityIndicator(show: true)

        if AlamofireManager.shared.session.configuration.timeoutIntervalForRequest != 20 {
            let alamofire = Alamofire.SessionManager.default
            alamofire.session.configuration.timeoutIntervalForRequest = 20
            AlamofireManager.shared = alamofire
        }

        var encodingType: ParameterEncoding

        if method == .put || method == .post {
            encodingType = JSONEncoding.default
        } else {
            encodingType = URLEncoding.queryString
        }

        if let p = param { Log.info("param: \(p)") }

        AlamofireManager.shared.request(
            url,
            method: method,
            parameters: param,
            encoding: encodingType,
            headers: AlamofireHeaders.createHeader()
        ).validate().responseJSON {
            response in
            self.activityIndicator(show: false)
            self.responseLog(response: response)

            var success: Bool
            switch response.result {
            case .success:
                success = true
            case let .failure(error):
                success = false
                switch error as? AFError {
                case let .some(.invalidURL(url)):
                    Log.error("\(url)")
                case let .some(.parameterEncodingFailed(reason)):
                    Log.error("\(reason)")
                case let .some(.multipartEncodingFailed(reason)):
                    Log.error("\(reason)")
                case let .some(.responseValidationFailed(reason)):
                    Log.error("\(reason)")
                case let .some(.responseSerializationFailed(reason)):
                    Log.error("\(reason)")
                case .none:
                    break
                }
            }

            if let data = response.data {
                completion(data, success)
            }
        }
    }
    

    class func activityIndicator(show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }
}

// 네트 관련 함수
extension NetworkManager {
    // 서버와 통신을 전부다 끊는다.
    class func cancellAll() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, uploadData, downloadData in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }

    // 섹션을 전부다 멈춘다.
    class func stopAllSessions() {
        AlamofireManager.shared.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        AlamofireManager.shared.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }

    // 특정 통신을 캔슬한다. (현재 string으로 하는데, 태그로 해야하나?)
    class func cancel(url: String) {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, _, _ in
            sessionDataTask.forEach {
                if $0.originalRequest?.url?.absoluteString == url {
                    $0.cancel()
                }
            }
        }
    }

    class func cancelTask() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { sessionDataTask, _, _ in
            sessionDataTask.forEach { $0.cancel() }
        }
    }

    class func cancelDownload() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { _, _, downloadData in
            downloadData.forEach { $0.cancel() }
        }
    }

    class func cancelUpload() {
        AlamofireManager.shared.session.getTasksWithCompletionHandler { _, uploadData, _ in
            uploadData.forEach { $0.cancel() }
        }
    }
}
