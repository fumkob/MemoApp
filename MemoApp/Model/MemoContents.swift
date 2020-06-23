//
//  MemoContents.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MemoContents {
    public let memo: String
    public let date: Date
    init(result: JSON) {
        guard let memo = result["memo"].string else {
            fatalError("memo is nil")
        }
        guard let date = result["created"].string else {
            fatalError("created is nil")
        }
        //Date変換
        guard let dateAfterFormatted = Date(fromISO8601: date) else {
            fatalError("date is nil")
        }
        
        self.memo = memo
        self.date = dateAfterFormatted
    }
}
