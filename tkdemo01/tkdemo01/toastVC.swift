//
//  toastVC.swift
//  GSNativeIos
//
//  Created by edtech-24 on 2016/09/05.
//  Copyright © 2016年 sprix. All rights reserved.
//

import UIKit

class toastVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actClose(sender: AnyObject) {
        self.doClose()
    }
    
    class func show() {
        let frame = UIScreen.main.bounds
        let frame2 = frame.offsetBy(dx: 0, dy: 0)
        let window = UIWindow(frame: frame2)
        let _storyboard = UIStoryboard(name: "toastVC", bundle: Bundle.main)
        let nvc = _storyboard.instantiateViewController(withIdentifier: "SbID_toastVC") as! toastVC
        window.rootViewController = nvc
        window.backgroundColor = UIColor.darkGray
        window.windowLevel = UIWindowLevelNormal + 5
        window.makeKeyAndVisible()
        window.alpha = 0.0
        window.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.transition(with: window, duration: 0.6, options: UIViewAnimationOptions.curveEaseInOut
            , animations: { 
                window.alpha = 1.0
                window.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished: Bool) in
        }
    }
    func doClose() {
//        UIView.transitionWithView(UIWindow, duration: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            let view = window.rootViewController!.view
//            for v in view.subviews {
//                v.transform = CGAffineTransformMakeScale(0.3, 0.3)
//            }
//            window.alpha = 0.0
//        }) { (finished: Bool) in
//            window.rootViewController!.view.removeFromSuperview()
//            window.rootViewController = nil
//            ShareStatusManager.sharedInstance.overWindow = nil
//            if let nextWindow = ShareStatusManager.sharedInstance.prevWindow as UIWindow? {
//                nextWindow.makeKeyAndVisible()
//                if let navCtrhVC = nextWindow.rootViewController {
//                    for vc in navCtrhVC.childViewControllers {
//                        if let _vc = vc as? TLTopViewController {
//                            _vc.performSegueWithIdentifier("DebugMenuVC", sender: nil) //そして、本来のDebugVCへの遷移を実行
//                            return
//                        }
//                    }
//                }
//            }
//        }
    }

}
//-(void)doClose
//    {
//        UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window);
//        
//        [UIView transitionWithView:window
//            duration:.3
//            options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
//            animations:^{
//            UIView *view = window.rootViewController.view;
//            
//            for (UIView *v in view.subviews) {
//            v.transform = CGAffineTransformMakeScale(.8, .8);
//            }
//            
//            window.alpha = 0;
//            }
//            completion:^(BOOL finished) {
//            
//            [window.rootViewController.view removeFromSuperview];
//            window.rootViewController = nil;
//            
//            // 上乗せしたウィンドウを破棄
//            objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//            
//            // メインウィンドウをキーウィンドウにする
//            UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
//            [nextWindow makeKeyAndVisible];
//            }];
//}

//+(void)show
//    {
//        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        window.alpha = 0.;
//        window.transform = CGAffineTransformMakeScale(1.1, 1.1);
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dialog" bundle:nil];
//        window.rootViewController = [storyboard instantiateInitialViewController];
//        window.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
//        window.windowLevel = UIWindowLevelNormal + 5; // テキトーにちょっと高い
//        
//        [window makeKeyAndVisible];
//        
//        // ウィンドウのオーナーとしてアプリ自身に括りつけとく
//        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        [UIView transitionWithView:window duration:.2 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
//        window.alpha = 1.;
//        window.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//        
//        }];
//}
