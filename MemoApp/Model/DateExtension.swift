//
//  DateExtension.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/24.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

extension Date {
    private struct Const {
        static let ISO8601Formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateFormatter
        }()
        
        static let japaneseStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
            return formatter
        }()
    }
    init?(fromISO8601 string: String) {
        guard let date = Const.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    func japaneseStyleDate() -> String {
        return Const.japaneseStyle.string(from: self)
    }
}
