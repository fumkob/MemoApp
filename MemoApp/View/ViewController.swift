//
//  ViewController.swift
//  MemoApp
//
//  Created by Fumiaki Kobayashi on 2020/06/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var postButton: CustomButton!
    @IBOutlet weak var loadButton: CustomButton!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        indicatorSetting()
        alertSetting()
        postButtonTapped()
        loadButtonTapped()
        self.postTextField.delegate = self
    }
    
    private func viewSetup() {
        self.viewModel = ViewModel(apiClient: APIClient())
        memoLabel.text = ""
        dateLabel.text = ""
    }
    //インジゲータ設定
    private func indicatorSetting() {
        //読み込み用インジケーター表示
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        //非表示設定
        activityIndicator.hidesWhenStopped = true
        //viewに追加
        self.view.addSubview(activityIndicator)
        //表示設定;indicatorStatusのBool値によってactivityIndicatorと各ボタンのenable状態を決める
        let indicatorStatus = self.viewModel.indicatorStatus
        indicatorStatus
            .drive(onNext: {[weak self] in
                ($0 ? self?.activityIndicator.startAnimating : self?.activityIndicator.stopAnimating)?()
                self?.postButton.isEnabled = !$0
                self?.postButton.backgroundColor = $0 ? .systemGray5 : .none
                self?.loadButton.isEnabled = !$0
                self?.loadButton.backgroundColor = $0 ? .systemGray5 : .none
                })
            .disposed(by: disposeBag)
    }
    //投稿orエラー時アラート設定
    private func alertSetting() {
        viewModel.alerts
            .drive(onNext: {[weak self] alertType in
                switch alertType {
                case .memoSaved :
                    let alert = UIAlertController.okAlert(title: "Post Succeeded", message: "やったね")
                    self?.present(alert, animated: true, completion: nil)
                case .postError :
                    let alert = UIAlertController.okAlert(title: "Post Failed", message: "Please try again")
                    self?.present(alert, animated: true, completion: nil)
                case .getError :
                    let alert = UIAlertController.okAlert(title: "Load Failed", message: "Please try again")
                    self?.present(alert, animated: true, completion: nil)                }
            })
            .disposed(by: disposeBag)
    }
    //投稿ボタン押下
    private func postButtonTapped() {
        postButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.postTextField.endEditing(true)
                guard let memo = self?.postTextField.text else {
                    fatalError("memo is nil")}
                //何も書かれていない場合はサーバーに送信しない
                if memo.isEmpty {
                    let alert = UIAlertController.okAlert(title: "No Text", message: "Please input some text")
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.viewModel.postMemo(memo: memo)
                }
        })
        .disposed(by: disposeBag)
    }
    //読み込みボタン押下
    public func loadButtonTapped() {
        loadButton.rx.tap
            .subscribe(onNext: {[unowned self] in
                self.viewModel.loadMemo()
                let contents = self.viewModel.contents
                contents
                    .drive(onNext: {[unowned self] value in
                        self.memoLabel.text = value[0].memo
                        self.dateLabel.text = value[0].date.japaneseStyleDate()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    //キーボード閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
