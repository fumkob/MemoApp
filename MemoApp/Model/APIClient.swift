//
//  APIClient.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

public class APIClient {
    
    enum APIError: Error {
        case postToServer
        case getFromServer
    }
    
    let alamofire = AF
    public func getData(url: URL) -> Single<[MemoContents]> {
        return .create {observer in
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 5.0
            
            self.alamofire.request(url).validate().responseJSON { response in
                switch response.result {
                //成功
                case .success (let value):
                    observer(.success(self.parseData(value: value)))
                //失敗
                case .failure:
                    observer(.error(APIError.getFromServer))
                }
            }
            return Disposables.create()
        }
    }
    
    public func postData(url: URL, memo: String) -> Single<Any> {
        return .create {observer in
            let headers: HTTPHeaders = ["Contenttype" : "application/json"]
            let parameters: [String: Any] = ["memo": memo]
            
            self.alamofire.request(url, method: .post, parameters: parameters, headers: headers) { urlRequest in
                urlRequest.timeoutInterval = 5
            }
            .responseJSON { response in
                switch response.result {
                //成功
                case .success(let value) :
                    observer(.success(value))
                //失敗
                case .failure:
                    observer(.error(APIError.postToServer))
                }
            }
            return Disposables.create()
        }
    }
    
    private func parseData(value: Any) -> [MemoContents] {
        let jsonData = JSON(value)
        return jsonData.map({MemoContents(result: $0.1)})
    }
}
