//
//  ViewController.swift
//  tkdemo01
//
//  Created by TOKUMITSU, Satoshi on 2017/01/11.
//  Copyright © 2017年 tokumi. All rights reserved.
//

import UIKit
import Accounts
import Social

class ViewController: UIViewController {
    //== 引き渡し変数
    var twAccount: ACAccount?

    @IBOutlet weak var lblTitle: UILabel!
    
    //== タイムライン表示
    @IBOutlet weak var btnTimeline: UIButton!
    @IBAction func actTimeline(_ sender: Any) {
        TKLog(mask: .Case01, "[\(#function):\(#line)] タイムライン表示するよ")
        let storyboard = UIStoryboard(name: "TKTimeline", bundle: Bundle.main)
        let nvc = storyboard.instantiateViewController(withIdentifier: "SBID_TKTimelineVC") as! TKTimelineVC
        if let _twAccount = self.twAccount {
            nvc.initWithID(twAccount: _twAccount)
        }
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TKLog(mask: .Case01, "[\(#function):\(#line)] ほげほげ")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getTwitterAccount() //Twitterアカウントの取得
    }
    
    
    func getTwitterAccount() {
        //== Twitterアカウントの取得
        btnTimeline.isEnabled = false
        
        let acs = ACAccountStore()
        let acType = acs.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        acs.requestAccessToAccounts(with: acType, options: nil) { (granted: Bool
            , error:Error?) in
            if error != nil {
                TKLog(mask: .Case01, "error! [(error.description)]")
                return
            }
            if !granted {
                let errmsg = "Twitter利用権限がない [\(granted)]"
                TKLog(mask: .Case01, errmsg)
                self.lblTitle.text = errmsg
                return
            }
            let accounts = acs.accounts(with: acType) as! [ACAccount]
            if accounts.count == 0 {
                let errmsg = "Twitterアカウントが設定されていない"
                TKLog(mask: .Case01, errmsg)
                self.lblTitle.text = errmsg
                return
            } else {
                //取得アカウント名の表示
                //（複数ある場合は一つ目のアカウントを利用　※選択できるようにすべき）
                self.twAccount = ACAccount()
                self.twAccount = accounts[0]//一つ目を利用
                self.btnTimeline.isEnabled = true
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

