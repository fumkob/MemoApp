# MemoApp
[![Build Status](https://travis-ci.org/fumkob/MemoApp.svg?branch=master)](https://travis-ci.org/fumkob/MemoApp)
## アプリ仕様
### 基本的なこと
- 一行のメモを書き、投稿ボタンを押すことでサーバーに記録する
- 投稿が保存された旨をユーザーに伝える
- サーバーに記録されるメモは、Stringと時間の情報が含まれている
- 読み込みボタンを押すと、サーバーに記録されたメモを表示する
- 一連のデータの受け渡しはAPIを使いJSON形式で行う
### その他注記
- iPhoneアプリ側はMVVMで記述する
- サーバー側はNode js + express + MySQLを使用する

## 操作画面イメージ
<img src="https://raw.githubusercontent.com/fumkob/MemoApp/image/scr1.png" width="700">

## 構成
<img src="https://raw.githubusercontent.com/fumkob/MemoApp/image/scr2.png" width="1000">
