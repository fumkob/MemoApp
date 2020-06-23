//
//  ViewModel.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ViewModel {
    //アラート場合分け
    public enum AlertType: Int {
        case postSucceeded
        case postFailed
        case getFailed
    }
    
    private let apiClient: APIClient
    //ActivityIndicator状態用
    private let indicatorStatusEvent = BehaviorSubject<Bool>(value: false)
    public var indicatorStatus: Driver<Bool> { return indicatorStatusEvent.asDriver(onErrorDriveWith: .empty()) }
    //サーバーから取得したデータ格納用
    private let contentsEvent = PublishSubject<[MemoContents]>()
    public var contents: Driver<[MemoContents]> { return contentsEvent.asDriver(onErrorDriveWith: .empty()) }
    //アラート用
    private let alertsEvent = PublishSubject<Int>()
    public var alerts: Driver<Int> { return alertsEvent.asDriver(onErrorDriveWith: .empty()) }
    
    private let disposeBag = DisposeBag()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    //投稿処理
    public func postMemo(memo: String) {
        guard let url = URL(string: "http://localhost:3000/post/") else {
            fatalError("url is nill")
        }
        //indicator開始
        indicatorStatusEvent.onNext(true)
        //サーバーへ投稿
        apiClient.postData(url: url, memo: memo)
            .subscribe(onSuccess: { [weak self] result in
                print(result)
                self?.alertsEvent.onNext(AlertType.postSucceeded.rawValue)
            }, onError: {[weak self] error in
                print(error)
                self?.alertsEvent.onNext(AlertType.postFailed.rawValue)
            })
            .disposed(by: disposeBag)
        //indicator終了
        indicatorStatusEvent.onNext(false)
    }
    //読み込み処理
    public func loadMemo() {
        guard let url = URL(string: "http://localhost:3000/get/") else {
            fatalError("url is nill")
        }
        //indicator開始
        indicatorStatusEvent.onNext(true)
        //サーバーから読み込み
        apiClient.getData(url: url)
            .subscribe(onSuccess: { [weak self] result in
                self?.contentsEvent.onNext(result)
            }, onError: { [weak self] error in
                print(error)
                self?.alertsEvent.onNext(AlertType.getFailed.rawValue)
            })
            .disposed(by: disposeBag)
        //indicator終了
        indicatorStatusEvent.onNext(false)
    }
}
