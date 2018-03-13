//
//  GetProvideVC.swift
//  Partner
//
//  Created by Weslie on 13/03/2018.
//

import UIKit

class GetProvideVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var describLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var provideID : Int?
    var showTypeName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTextView.delegate = self
        typeLab.text = showTypeName
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.describLab.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.detailTextView.resignFirstResponder()
    }
    
    @IBAction func phoneCallAction(_ sender: Any) {
        
        let urlString = "tel://123456"
        makePhoneCall(with: urlString)
    }
    
    @IBAction func dismissaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}




extension  UINavigationController : UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //同时禁用系统原先的侧滑返回功能
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
}
