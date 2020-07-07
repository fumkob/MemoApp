//
//  MemoAppTests.swift
//  MemoAppTests
//
//  Created by Fumiaki Kobayashi on 2020/06/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest
@testable import MemoApp
import RxSwift
import RxCocoa

class MemoAppTests: XCTestCase {
    
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostMemo() {
        let apiClient: APIClient = APIClientMockFactory.emptyGetDataClient()
        let viewModel = ViewModel(apiClient: apiClient)
        viewModel.alerts.drive(onNext: {
            switch $0 {
            case .getError: XCTFail("Get Error")
            case .memoSaved: XCTFail("Saved???")
            case .postError: XCTFail("Post Error")
            }
        })
        .disposed(by: disposeBag)
    }
}

//class APIClientMock: APIClient {
//    override func getData(url: URL) -> Single<[MemoContents]> {
//        return .just([])
//    }
//}

class APIClientMockFactory {
    
    class APIClientMock: APIClient {
        override func getData(url: URL) -> Single<[MemoContents]> {
            return .just([])
        }
    }

    static func emptyGetDataClient() -> APIClient {
        return APIClientMock()
    }
}
