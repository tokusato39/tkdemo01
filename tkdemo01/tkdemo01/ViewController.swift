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
    @IBOutlet weak var btnTimeline: TKButton!
    @IBAction func actTimeline(_ sender: TKButton) {
        TKLog(mask: .Case01, "[\(#function):\(#line)] タイムライン表示するよ")
        sender.onAnimationCompleted = { () -> Void in
            let storyboard = UIStoryboard(name: "TKTimeline", bundle: Bundle.main)
            let nvc = storyboard.instantiateViewController(withIdentifier: "SBID_TKTimelineVC") as! TKTimelineVC
            if let _twAccount = self.twAccount {
                nvc.initWithID(twAccount: _twAccount)
            }
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    //== 画像設定
    @IBOutlet weak var btnImage: TKButton!
    @IBAction func actImage(_ sender: TKButton) {
        TKLog(mask: .Case01, "[\(#function):\(#line)] 画像設定するよ")
        sender.onAnimationCompleted = { () -> Void in
            //===シミュレータ時の機能抑止
            if Platform.isSimulator {
                let actionSheetController = UIAlertController(title: "画像設定", message: "カメラ機能はシミュレータでは使えません", preferredStyle: .actionSheet)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                actionSheetController.addAction(cancelAction)
                self.present(actionSheetController, animated: true, completion: nil)
                return
            }
            //===カメラと既存画像を選ばせる
            let actionSheetController = UIAlertController(title: "画像設定", message: "読み込む画像ソースを選択してください", preferredStyle: .actionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(UIAlertAction(title: "写真を撮る" , style: .default) { action -> Void in
                let vc = UIImagePickerController()
                vc.sourceType = UIImagePickerControllerSourceType.camera
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            })
            actionSheetController.addAction(UIAlertAction(title: "既存の画像を選択" , style: .default) { action -> Void in
                let vc = UIImagePickerController()
                vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            })
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var ivwImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TKLog(mask: .Case01, "[\(#function):\(#line)] ほげほげ")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //== 初期化しておく
        btnTimeline.isEnabled = false
        btnTimeline.backgroundColor = UIColor(rgb: 0x88ffff)
        btnTimeline.animationEnabled = false
        btnImage.isEnabled = true
        btnImage.backgroundColor = UIColor(rgb: 0xff8800, alpha: 0.6)
        btnImage.animationEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getTwitterAccount() //Twitterアカウントの取得
    }
    func getTwitterAccount() {
        //== Twitterアカウントの取得
        let acs = ACAccountStore()
        let acType = acs.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        acs.requestAccessToAccounts(with: acType, options: nil) { (granted: Bool, error:Error?) in
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
                //取得アカウント名の保持
                //（複数ある場合は一つ目のアカウントを利用　※選択できるようにすべき）
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
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //キャンセル時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //画像指定時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.ivwImage.image = image
            }
        })
    }
}

