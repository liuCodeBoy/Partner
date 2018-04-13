//
//  ProfileViewController.swift
//  Partner
//
//  Created by Weslie on 16/01/2018.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isInvestor = true
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var genderImg: UIImageView!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var loginOrRegisterBtn: UIButton!
    @IBOutlet weak var detialInfoView: UIView!
    @IBOutlet weak var dataIntegrityLbl: UILabel!
    @IBOutlet weak var dataIntegrityProgressWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var applyAuthBtn: UIButton!
    @IBOutlet weak var backImageHeightCons: NSLayoutConstraint!
    
    @IBAction func loginOrRegisterBtnClicked(_ sender: UIButton) {
        // login
          let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
//        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterAndLoginVCID")
        self.navigationController?.present(navRegistAndLoginVC, animated: true, completion: nil)
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
                case 1: verifyLbl.text = " 投资商 "; isInvestor = true
                case 2: verifyLbl.text = " 创业者 "; isInvestor = false
                case 3: verifyLbl.text = " 普通用户 "; isInvestor = false
                    
                default: break
                }
            }
            if let percent = viewModel?.percent {
                dataIntegrityLbl.text = "\(percent)%"
                let per = Double(truncating: percent) * 0.01
                dataIntegrityProgressWidthCons.constant = CGFloat(120 * (1 - per))
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
                    return
                }
                if result!["code"] as! Int == 200 {
                    let model = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
                    self?.viewModel = model
                } else {
                    self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!)))", completion: nil)
                }

            })
            loginOrRegisterBtn.isHidden = true
            detialInfoView.isHidden = false
        } else {
            // user hasn't loged in
            loginOrRegisterBtn.isHidden = false
            detialInfoView.isHidden = true
            avatar.image = #imageLiteral(resourceName: "profile_avatar_placeholder")
        }
    }

    @IBAction func clearCacheClicked(_ sender: UIButton) {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        let alert = UIAlertController(title: "提示", message: "是否清除缓存", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
            // 点击确定时开始删除
            for p in files!{
                // 拼接路径
                let path = cachePath!.appendingFormat("/\(p)")
                // 判断是否可以删除
                if(FileManager.default.fileExists(atPath: path)){
                    // 删除
                    try? FileManager.default.removeItem(atPath: path)
                }
            }
        }
        alert.addAction(alertConfirm)
        let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (cancle) -> Void in
            
        }
        alert.addAction(cancle)
        // 提示框弹出
        present(alert, animated: true) { () -> Void in
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ProfileApplyAuthSegue" {
            if let id = viewModel?.idenId {
                if id == 3 {
                    presentHintMessage(hintMessgae: "普通用户不能申请认证", completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if destnation is MyProjectViewController {
            let dest = destnation as! MyProjectViewController
            dest.isInvestor = self.isInvestor
        }
    }
    

}
