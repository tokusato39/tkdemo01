//
//  TKConsts.swift
//  tkdemo01
//
//  Created by TOKUMITSU, Satoshi on 2017/01/11.
//  Copyright © 2017年 tokumi. All rights reserved.
//

import Foundation
import UIKit

//=== デバグ用ログの表示抑止制御
enum TKLog_Mask: Int {
    case Never      //ログを常に出力させない。基本的に利用しないこと
    case Always     //ログを常に出力させる。基本的に利用しないこと
    //必要に応じて以下の定義を増やして、ログの表示抑止制御をおこなう
    case Case01
}
func TKLog(mask: TKLog_Mask = .Never, _ message: @autoclosure () -> String) {
    #if DEBUG
        var isShow: Bool = false
        switch mask {
        case .Always: isShow = true
            //===以下、trueにすると表示されます
        case .Case01:   isShow = false

        default: break
        }
        if isShow {
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss.SSS"
            let formattedDate = formatter.string(from: date as Date)
            print("\(formattedDate):\(message())")
        }
    #endif
}
//===シミュレータでカメラ起動するとクラッシュするので、それを避けるためにシミュレータを判別する
#if DEBUG
#if (arch(i386) || arch(x86_64)) && os(iOS)
let DEVICE_IS_SIMULATOR = true
    #else
let DEVICE_IS_SIMULATOR = false
#endif
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
#endif

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
public class TKButton: UIButton {
    //== アニメーションフィードバック
    let animation = CAAnimation()
    var animationEnabled: Bool = true
    var onAnimationCompleted: (() -> Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isExclusiveTouch = true
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isExclusiveTouch = true
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if animationEnabled {
            animateTargetView(view: self)
        } else {
            //アニメーション実施しない場合には、完了時処理を実施しておく
            self.onAnimationCompleted?()
        }
    }
    func animateTargetView(view: UIView) {
        animateTargetViews(views: [view])
    }
    func animateTargetViews(views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            for view in views {
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }, completion: { finished in
            self.onAnimationCompleted?()
        })
    }
}
