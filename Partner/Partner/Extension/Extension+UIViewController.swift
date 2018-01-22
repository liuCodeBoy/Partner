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
    
    // MARK:- set nav bar title
    func setNavBarTitle(title navTitle: String) {
        let titleLbl = UILabel()
        titleLbl.text = navTitle
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        self.navigationItem.titleView = titleLbl
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
    
    func setNavBarBackBtn() {
      
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "left_arrow"), style: .done, target: self, action: #selector(popopop))
        self.navigationItem.setLeftBarButton(back, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func popopop() {
        self.navigationController?.popViewController(animated: true)
    }


}
