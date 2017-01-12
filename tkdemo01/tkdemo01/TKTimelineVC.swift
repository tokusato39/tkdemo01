//
//  TKTimelineVC.swift
//  tkdemo01
//
//  Created by TOKUMITSU, Satoshi on 2017/01/11.
//  Copyright © 2017年 tokumi. All rights reserved.
//

import UIKit
import Accounts
import Social

class TKTimelineVC: UIViewController {
    //== 引き渡し変数
    var twID: ACAccount?
    
    var arrDispData = [objTweet]()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var waitVW: UIView!
    @IBOutlet weak var loadingVW: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TKLog(mask: .Always, "[\(#function):\(#line)] タイムラインVC表示")
        
        // テーブルビュー
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 表示セルの準備
        self.tableView.register(UINib(nibName: "TVCell_Twitter",  bundle: nil), forCellReuseIdentifier: "TVCell_Twitter")

    }
    
    //TwitterIDを設定して初期化しておく
    func initWithID(twAccount: ACAccount?) {
        TKLog(mask: .Always, "[\(#function):\(#line)] TwitterID[\(twAccount?.username)]を設定して初期化する")
        if let _twAccount = twAccount {
            self.twID = _twAccount
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TKLog(mask: .Always, "[\(#function):\(#line)] viewDidAppear")
        //指定タイムラインを取得する
        if let _twID = self.twID {
            self.lblTitle.text = "\(_twID)のタイムライン"
            self.getTimeline()
        }
    }
    func showLoadingView(isLoading: Bool) {
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            if isLoading {
                self.waitVW.isHidden = false
                self.loadingVW.startAnimating()
            } else {
                self.waitVW.isHidden = true
                self.loadingVW.stopAnimating()
            }
        }
    }
    func getTimeline() {
        TKLog(mask: .Always, "[\(#function):\(#line)] [\(self.twID)]タイムライン取得")
        self.showLoadingView(isLoading: true)

        let urlTwTl = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json?count=100")//最新100件固定
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                                requestMethod: .GET,
                                url: urlTwTl as URL!,
                                parameters: nil)
        request?.account = self.twID
        
        request?.perform { (data, response, error) -> Void in
            if error != nil {
                TKLog(mask: .Always, "[\(#function):\(#line)] [\(self.twID)]タイムライン取得 エラー")
                self.showLoadingView(isLoading: false)
            } else {
                do {
                    TKLog(mask: .Always, "[\(#function):\(#line)] [\(self.twID)]タイムライン取得 成功")
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    self.arrDispData.removeAll()//保持データを全削除
                    for tweet in result as! [AnyObject] {
                        //データ保持させる
                        let model = objTweet()
                        let _id = tweet["id"] as! Int
                        let _name = tweet["screen_name"] as? String ?? ""
                        let _date = tweet["created_at"] as? String ?? ""
                        let _text = tweet["text"] as? String ?? ""
                        model.id = _id
                        model.username = _name
                        model.date = _date
                        model.tweet = _text
                        self.arrDispData.append(model)

                    }
                    let mainQueue = DispatchQueue.main
                    mainQueue.async {
                        self.tableView.reloadData()
                        self.showLoadingView(isLoading: false)
                    }
                }  catch let error as NSError {
                    TKLog(mask: .Always, "[\(#function):\(#line)] タイムライン取得  パースエラー[\(error.description)]")
                    self.showLoadingView(isLoading: false)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension TKTimelineVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDispData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.arrDispData[indexPath.row]
        let size = TVCell_Twitter.getCellSize(tweet: model)
        return size.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let twCell: TVCell_Twitter = tableView.dequeueReusableCell(withIdentifier: "TVCell_Twitter", for: indexPath) as! TVCell_Twitter

        let model = self.arrDispData[indexPath.row]
        twCell.initCell(num: indexPath.row, tweet: model)
        twCell.dispCell()
        
        return twCell
    }
    
}
