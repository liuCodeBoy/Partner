//
//  Extension+UIView.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK:- set round rect of a UIView
    func setRoundRect(targets: [UIView]) {
        for target in targets {
            target.layer.cornerRadius = target.frame.height / 2
            target.layer.masksToBounds = true
        }
    }
    
    // MARK:- convenience alert with hint message and completion
    func presentHintMessage(hintMessgae: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "提示", message: hintMessgae, preferredStyle: .alert)
        let ok = UIAlertAction(title: "好的", style: .default, handler: completion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- confirmation alert
    func presentConfirmationAlert(hint hintMessgae: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "提示", message: hintMessgae, preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default, handler: completion)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- completion alert
    func presentAlert(title alertTitle: String, hint hintMessgae: String, confirmTitle ok: String, cancelTitle cancel: String, confirmation confirmCompletion: ((UIAlertAction) -> Void)?, cancel cancelCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: alertTitle, message: hintMessgae, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default, handler: confirmCompletion)
        let cancel = UIAlertAction(title: cancel, style: .cancel, handler: cancelCompletion)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- make a phone call
    func makePhoneCall(with number: String) {
        let alert = UIAlertController(title: number, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "呼叫", style: .default) { (_) in
            UIApplication.shared.openURL(URL.init(string: "tel://\(number)")!)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // add observer in the view controller to change frame
    func notificationAddKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.init(keyboardShowNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.init(keyboardHideNotification), object: nil)
    }
    
    func keyboardWillShow(from aView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(keyboardShowNotification), object: aView)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let transformView = notification.object as! UIView
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            transformView.transform = CGAffineTransform(translationX: 0, y: -258)
        }, completion: nil)
    }
    
    func keyboardWillHide(from aView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(keyboardHideNotification), object: aView)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let transformView = notification.object as! UIView
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            transformView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    //设置选择样式
    @objc func changeBtnStaus(button : UIButton) -> () {
        if button.isSelected {
            button.isSelected = false
            button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1), for: .normal)
        }else{
            button.isSelected = true
            button.backgroundColor = #colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    //改变按钮边框
    func changeBorder(btn : UIButton){
        let  border = CAShapeLayer.init()
        //虚线的颜色
        border.strokeColor = #colorLiteral(red: 0.7063220143, green: 0.8319012523, blue: 0.9218811393, alpha: 1)
        //填充的颜色
        border.fillColor = UIColor.clear.cgColor
        let path = UIBezierPath.init(roundedRect: btn.bounds, cornerRadius: 17)
        //设置路径
        border.path = path.cgPath;
        border.frame = btn.bounds;
        //虚线的宽度
        border.lineWidth = 1.0;
        //虚线的间隔
        border.lineDashPattern = [4, 2]
        btn.layer.addSublayer(border)
        
    }

}

extension UIView {
    
    func keyboardWillShow(from aView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(keyboardShowNotification), object: aView)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let transformView = notification.object as! UIView
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            transformView.transform = CGAffineTransform(translationX: 0, y: -258)
        }, completion: nil)
    }
    
    func keyboardWillHide(from aView: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name.init(keyboardHideNotification), object: aView)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let transformView = notification.object as! UIView
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            transformView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
}
