//
//  ProfileTextInputTableViewBodyCell.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class ProfileTextInputTableViewBodyCell: UITableViewCell, UITextViewDelegate {
    
    typealias presentBlock = (() -> Void)?
    var presentAlert: presentBlock = nil

    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextView.delegate = self
    }
    
    var inputString: String? {
        didSet {
            let charCount = Int(inputTextView.text.count)
            inputLimitLbl.text = "\(charCount)/300"
            if charCount > 300 {
                // notify vc to present alert with block
                presentAlert!()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
        // MARK:- make the table view offset
        keyboardWillShow(from: self.superview!)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTextView.text
    }
    
}
