//
//  RegisterAndLoginVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/5.
//

import UIKit

class RegisterAndLoginVC: UIViewController {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var loginInBtn: UIButton!
    @IBOutlet weak var registerAction: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
//      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//      self.navigationController?.navigationBar.barStyle = .blackOpaque
//      self.navigationController?.navigationBar.shadowImage = UIImage()
        registerView.isHidden = true
        loginView.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func loginInAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.lineView.center.x = self.loginInBtn.center.x
        }
        loginView.isHidden = false
        registerView.isHidden = true
    }
    
    @IBAction func registerActionfunc(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
           self.lineView.center.x = self.registerAction.center.x
        }
        loginView.isHidden = true
        registerView.isHidden = false
    }
    @IBAction func RegisterAction(_ sender: Any) {
        let chooseIdentityVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ChooseIdentityVCID")
        self.navigationController?.pushViewController(chooseIdentityVC, animated: true)
    }
    
    @IBAction func passengerLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
