//
//  VisitorsReservationViewController.swift
//  Partner
//
//  Created by Weslie on 18/01/2018.
//

import UIKit

class VisitorsReservationViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var reserveForVisit: ShadowButton!
    @IBOutlet weak var reserveForInspect: ShadowButton!
    @IBOutlet weak var infoScrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var communityLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
    @IBOutlet weak var nameInputLbl: UILabel!
    @IBOutlet weak var phoneInputLbl: UILabel!
    @IBOutlet weak var companyNameInputLbl: UILabel!
    @IBOutlet weak var communityInputLbl: UILabel!
    @IBOutlet weak var timeInputLbl: UILabel!
    @IBOutlet weak var numberInputLbl: UILabel!
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    
    @IBAction func reserveForVisitClicked(_ sender: ShadowButton) {
        // switch selected status
        sender.setSelected()
        reserveForInspect.reverseSelected()
        // change label text
        communityLbl.text   = "预约社区  市->社区"
        timeLbl.text        = "预约时间"
        numberLbl.text      = "到访人数"
    }
    @IBAction func reserveForInspectClicked(_ sender: ShadowButton) {
        // switch selected status
        sender.setSelected()
        reserveForVisit.reverseSelected()
        // change label text
        communityLbl.text   = "参观社区  市->社区"
        timeLbl.text        = "参观时间"
        numberLbl.text      = "参观人数"
    }
    
    @IBAction func selectCommunityClicked(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("PartnerPickerView", owner: nil, options: nil)?.first as! PartnerPickerView
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        // TODO:- post request
        
        // pop vc
        presentConfirmationAlert(hint: "确认提交") { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoScrollView.delegate = self
        messageTV.delegate = self
        
        observeKeyboard()
    }
    
    func observeKeyboard() {
        // observe keyboard appearance and dismiss
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        //1. covert notification to dictionary
        let dict = notification.userInfo
        //2. get the frame of keyboard
//        let keyboardFrame = (dict?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //3. get animation duration
        let duration = (dict?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //4. get offset value
        let offsetY: CGFloat = 258
        //4. make screen offset
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.infoScrollView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
//            self.infoScrollView.contentOffset = CGPoint(x: 0, y: -offsetY)
        }, completion: nil)

    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let dict = notification.userInfo
        let duration = (dict?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.infoScrollView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        messageTV.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        messageTV.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
