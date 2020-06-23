//
//  AlertExtension.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/24.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

import UIKit

extension UIAlertController {
    static func okAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
