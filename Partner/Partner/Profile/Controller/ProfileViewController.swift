//
//  ProfileViewController.swift
//  Partner
//
//  Created by Weslie on 16/01/2018.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var genderImg: UIImageView!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var loginOrRegisterBtn: UIButton!
    @IBOutlet weak var detialInfoView: UIView!
    @IBOutlet weak var dataIntegrityLbl: UILabel!
    @IBOutlet weak var dataIntegrityProgressWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var officeOrderLbl: UILabel!
    @IBOutlet weak var meetingRoomOrderLbl: UILabel!
    @IBOutlet weak var stationOrderLbl: UILabel!
    
    @IBOutlet weak var backImageHeightCons: NSLayoutConstraint!
    
    @IBAction func backToProfile(_ sender: UIStoryboardSegue) { }
    
    @IBAction func loginOrRegisterBtnClicked(_ sender: UIButton) {
        // login
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterAndLoginVCID")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let img = viewModel?.userImgUrl {
                avatar.sd_setImage(with: URL.init(string: img), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.userName {
                nickNameLbl.text = name
            }
            if let gender = viewModel?.gender {
                if gender == 1 {
                    genderImg.image = #imageLiteral(resourceName: "male")
                } else {
                    genderImg.image = #imageLiteral(resourceName: "female")
                }
            } else {
                genderImg.isHidden = true
            }
            if let id = viewModel?.idenId {
                switch id {
                case 1: verifyLbl.text = " 投资商 "
                case 2: verifyLbl.text = " 创业者 "
                case 3: verifyLbl.text = " 普通用户 "
                default: break
                }
            }
            if let percent = viewModel?.percent {
                dataIntegrityLbl.text = "\(percent)%"
                let per = Double(truncating: percent) * 0.01
                dataIntegrityProgressWidthCons.constant = CGFloat(120 * (1 - per))
            }
            if let count = viewModel?.officecubicleNum {
                officeOrderLbl.text = "\(count)"
            }
            if let count = viewModel?.boardroomNum {
                meetingRoomOrderLbl.text = "\(count)"
            }
            if let count = viewModel?.fieldNum {
                stationOrderLbl.text = "\(count)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            backImageHeightCons.constant += 24
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = false
        
        // MARK:- judege the login status
        if let access_token = UserDefaults.standard.string(forKey: "token") {
            // user has loged in
            print("access_token: \(access_token)")
            NetWorkTool.shareInstance.getMyPageInfo(token: access_token, finished: { [weak self](result, error) in
                if error != nil {
                    self?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                    print(error as AnyObject)
                }
                if result!["code"] as! Int == 200 {
                    let model = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
                    self?.viewModel = model
                } else {
                    self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"])), reason: \(String(describing: result!["msg"])))", completion: nil)
                }

            })
            loginOrRegisterBtn.isHidden = true
            detialInfoView.isHidden = false
        } else {
            // user hasn't loged in
            loginOrRegisterBtn.isHidden = false
            detialInfoView.isHidden = true
        }
    }



}
