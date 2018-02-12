//
//  LimitTextView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/9.
//

import UIKit
class LimitTextView: UIView ,UITextViewDelegate{
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    var   limitNum = 0
    //声明弹框按钮
    var   showInFoClouse :  showInfoType?

    var feedbackString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/\(limitNum)"
            if charCount > limitNum {
                if self.showInFoClouse != nil {
                    self.showInFoClouse!("字符不能超过\(limitNum)字")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         inputTF.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTF.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedbackString = inputTF.text
    }

}
