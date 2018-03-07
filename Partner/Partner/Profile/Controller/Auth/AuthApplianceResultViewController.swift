//
//  AuthApplianceResultViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit

class AuthApplianceResultViewController: UIViewController {
    
    var viewModel: AuthInfoModel? {
        didSet {
            // MARK:- assign value to the label etc.
            if let imgUrl = viewModel?.imgUrl {
                invAvatarImg.sd_setImage(with: URL.init(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_big"), options: .continueInBackground, completed: nil)
            }
            if let nameCardUrl = viewModel?.nameCardUrl {
                invCardImg.sd_setImage(with: URL.init(string: nameCardUrl), placeholderImage: #imageLiteral(resourceName: "profile_my_project_business_card_big"), options: .continueInBackground, completed: nil)
            }
            if let inveRound = viewModel?.inveRound {
                invRoundLbl.text = inveRound
            }
            if let realName = viewModel?.realName {
                invRealNameLbl.text = realName
            }
            if let inveIndentity = viewModel?.inveIndentity {
                if inveIndentity.hasPrefix("机构") {
                    invIdentityBtn.setTitle("机构", for: .normal)
                } else if inveIndentity.hasPrefix("个人") {
                    invIdentityBtn.setTitle("个人", for: .normal)
                }
            }
            if let industryList = viewModel?.industryList {
                var count = 0
                var title = [String]()
                for dict in industryList {
                    let name = dict["name"]
                    title.append(name as! String)
                    count += 1
                }
                // set label title
                for i in 0..<count {
                    invIndustryLbl[i].text = title[i]
                }
                // hide unused label
                for j in count..<9 {
                    invIndustryLbl[j].isHidden = true
                }
            }
            if let phone = viewModel?.phone {
                invPhoneNumLbl.text = phone
            }
            if let mail = viewModel?.mail {
                invEmailLbl.text = mail
            }
            if let instName = viewModel?.instName {
                invAgencyNameLbl.text = instName
            }
            if let instJobName = viewModel?.instJobName {
                invAgencyJobLbl.text = instJobName
            }
            if let auth = viewModel?.auth {
                // 0未认证 1认证中 2通过 3不通过
                switch auth {
                case 0:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("未认证", for: .normal)
                case 1:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("审核中", for: .normal)
                case 2:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("通过", for: .normal)
                    inReviewBtn.setTitleColor(#colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1), for: .normal)
                case 3:
                    inReviewView.isHidden = true
                    rejectedView.isHidden = false
                default: break
                }
            }
            if let time = viewModel?.inTime {
                invAgencyOnWorkTimeLbl.text = time
            }
        }
    }
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var inReviewView: UIView!
    @IBOutlet weak var inReviewBtn: ShadowButton!
    @IBOutlet weak var rejectedView: UIView!
    
    
    // invest auth
    @IBOutlet weak var investAuth               : ShadowButton!
    @IBOutlet weak var investAuthScrollView     : UIScrollView!
    @IBOutlet weak var invAvatarImg             : RoundRectImage!
    @IBOutlet weak var invCardImg               : RoundRectImage!
    @IBOutlet weak var invRealNameLbl           : UILabel!
    @IBOutlet weak var invPhoneNumLbl           : UILabel!
    @IBOutlet weak var invEmailLbl              : UILabel!
    @IBOutlet var invIndustryLbl                : [StrokeLabel]!
    
    @IBOutlet weak var invRoundLbl              : UILabel!
    @IBOutlet weak var invIdentityBtn           : UIButton!
    @IBOutlet weak var invAgencyView            : UIView!
    @IBOutlet weak var invAgencyNameLbl         : UILabel!
    @IBOutlet weak var invAgencyJobLbl          : UILabel!
    @IBOutlet weak var invAgencyOnWorkTimeLbl   : UILabel!
    
    // enterprise auth
    @IBOutlet weak var enterpriseAuth           : ShadowButton!
    @IBOutlet weak var enterpriseAuthScrollView : UIScrollView!
    @IBOutlet weak var entLicenseImg            : RoundRectImage!
    @IBOutlet weak var entLogoImg               : RoundRectImage!
    @IBOutlet weak var entNameLbl               : UILabel!
    @IBOutlet weak var entRealNameLbl           : UILabel!
    @IBOutlet weak var entPhoneLbl              : UILabel!
    @IBOutlet weak var entMailLbl               : UILabel!
    @IBOutlet weak var entIntroLbl              : UILabel!
    @IBOutlet weak var entCreditCodeLbl         : UILabel!
    @IBOutlet weak var entLegalLbl              : UILabel!
    @IBOutlet weak var entLocationLbl           : UILabel!
    @IBOutlet weak var entDetialAddressLbl      : UILabel!
    
    @IBAction func investAuthClicked(_ sender: ShadowButton) {
        investAuth.setSelected()
        enterpriseAuth.reverseSelected()
        investAuthScrollView.isHidden = false
        enterpriseAuthScrollView.isHidden = true
    }
    
    @IBAction func enterpriseAuthClicked(_ sender: ShadowButton) {
        investAuth.reverseSelected()
        enterpriseAuth.setSelected()
        investAuthScrollView.isHidden = true
        enterpriseAuthScrollView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAuthInfoAndSaveToModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loadAuthInfoAndSaveToModel() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        NetWorkTool.shareInstance.getAuthInfo(token: access_token!, type: 1) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save info to the model
                let resultDict = result!["result"] as! [String : AnyObject]
                weakSelf?.viewModel = AuthInfoModel.mj_object(withKeyValues: resultDict)
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "AuthReSubmitSegue":
            let dest = segue.destination as! AuthApplyUploadViewController
            dest.isResumbit = true
            dest.authID = viewModel?.inveAuthId as? Int
        default: break
        }
    }

}
