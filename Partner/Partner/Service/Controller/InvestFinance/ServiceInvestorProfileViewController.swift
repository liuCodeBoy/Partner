//
//  MyHomePageViewController.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit
import NoticeBar

class ServiceInvestorProfileViewController: UIViewController {
    
    var id: Int?
    var singleProjId: Int?
    var isSingle = false
    
    @IBOutlet weak var avatar: RoundRectImage!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let url = viewModel?.userImgUrl {
                avatar.sd_setImage(with: URL.init(string: url), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.userName {
                nickNameLbl.text = name
            }
            if let job = viewModel?.userJob {
                jobLbl.text = job
            }
        }
    }
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerImgHCons: NSLayoutConstraint!
    @IBOutlet weak var headerInfoTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var basicInfoContainerView: UIView!
    @IBOutlet weak var experienceContainerView: UIView!
    
    @IBOutlet weak var basicInfoBtn: ShadowButton!
    @IBOutlet weak var experienceBtn: ShadowButton!
    @IBAction func basicInfoBtnClicked(_ sender: ShadowButton) {
        basicInfoBtn.setSelected()
        experienceBtn.reverseSelected()
        basicInfoContainerView.isHidden = false
        experienceContainerView.isHidden = true
    }
    @IBAction func experienceBtnClicked(_ sender: ShadowButton) {
        basicInfoBtn.reverseSelected()
        experienceBtn.setSelected()
        basicInfoContainerView.isHidden = true
        experienceContainerView.isHidden = false
    }
    
    @IBAction func backToHomePage(_ sender: UIStoryboardSegue) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingTheUser(_ sender: UIButton) {
        let alert = UIAlertController(title: "请选择操作类型", message: "", preferredStyle: .actionSheet)
        let ignoreAction = UIAlertAction(title: "屏蔽", style: .destructive) { [weak self](action) in
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
            if let id = self?.id{
                self?.momentIgnore(access_token: access_token, id: id)
            }
        }
        let reportAction = UIAlertAction(title: "举报", style: .destructive) { [weak self](action) in
            if let id = self?.id {
                let reportVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleReportVCID") as! CircleReportVC
                reportVC.userID = id
                self?.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(ignoreAction)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - 屏蔽该用户
    func momentIgnore(access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.ignoreUser(token: access_token, userId: id) { (result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "屏蔽成功"
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getUserHomePageInfo(token: access_token!, userId: id!) { [weak self](result, error) in
            if error != nil {
                self?.presentConfirmationAlert(hint: "\(String(describing: error))", completion: nil)
            }
            if result!["code"] as! Int == 200 {
                self?.viewModel = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
            } else {
                self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!)))", completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            headerImgHCons.constant += 24
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SIBasicInfoSegue" {
            let dest = segue.destination as! ServiceInvestorBasicInfomationContainerViewController
            dest.id = self.id
            dest.isSingle = self.isSingle
            dest.segue = segue
        } else if segue.identifier == "SIExperienceSegue" {
            let dest = segue.destination as! ServiceInvestorExperienceContainerViewController
            dest.id = self.id
            dest.segue = segue
        }
    }
    
}



