//
//  TVCell_Twitter.swift
//  tkdemo01
//
//  Created by TOKUMITSU, Satoshi on 2017/01/12.
//  Copyright © 2017年 tokumi. All rights reserved.
//

import UIKit


//保持させたい情報（必要なもののみ抜粋）
class objTweet: NSObject {
    var id: Int = 0
    var username: String = "nobody"
    var date: String = "yyyy/mm/dd"
    var tweet: String = "つぶやき内容"
}

class TVCell_Twitter: UITableViewCell {
    var num: Int = 0
    var modelTweet: objTweet?    //保持させたい情報
    
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTweet: UILabel!
    
    func initCell(num: Int, tweet: objTweet) {
        self.num = num
        self.modelTweet = objTweet()
        self.modelTweet = tweet
    }
    func dispCell() {
        if let _model = self.modelTweet {
            self.lblID.text = "#\(_model.id)"
            self.lblDate.text = _model.date
            self.lblUserName.text = _model.username
            self.lblTweet.text = _model.tweet
        }
        if (self.num % 2) == 0 {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.lightGray
        }
    }
    //セルのサイズを計算する
    class func getCellSize(tweet: objTweet) -> CGSize {
        let devSize = UIScreen.main.bounds.size
        let cellWidth: CGFloat = devSize.width
        let areaWidth = cellWidth - CGFloat(4+4)   //つぶやき左右の余白
        var cellHeight: CGFloat = 0
        cellHeight += CGFloat(12)    //上端〜つぶやき開始まで
        cellHeight += getCommentTextHeight(messageWidth: areaWidth, message: tweet.tweet) //表示文字列による高さ計算
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    class func getCommentTextHeight(messageWidth: CGFloat, message: String) -> CGFloat {
        let messageLabel = UILabel()
        messageLabel.frame = CGRect.zero
        messageLabel.font = UIFont.systemFont(ofSize: 14.0)//デザイン指定値
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        let szFitSize = messageLabel.sizeThatFits(CGSize(width: messageWidth, height: CGFloat.greatestFiniteMagnitude))
        let areaHeight = ceil(szFitSize.height)//切り上げ
        return areaHeight
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
