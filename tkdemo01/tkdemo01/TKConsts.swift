//
//  TKConsts.swift
//  tkdemo01
//
//  Created by TOKUMITSU, Satoshi on 2017/01/11.
//  Copyright © 2017年 tokumi. All rights reserved.
//

import Foundation



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
