//
//  DeliverResultVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/30.
//

import UIKit

class DeliverResultVC: UIViewController {
    var userId :Int?
    @IBOutlet weak var roundName1: UILabel!
    @IBOutlet weak var hotImg1: RoundRectImage!
    @IBOutlet weak var hotName1: UILabel!
    @IBOutlet weak var roundName2: UILabel!
    @IBOutlet weak var hotImg2: RoundRectImage!
    @IBOutlet weak var hotName2: UILabel!
    @IBOutlet weak var hotImg3: RoundRectImage!
    @IBOutlet weak var hotName3: UILabel!
    @IBOutlet weak var roundName3: UILabel!
    
    @IBOutlet weak var hotVoteChildView1: ShadowView!
    @IBOutlet weak var hotVoteChildView2: ShadowView!
    @IBOutlet weak var hotVoteChildView3: ShadowView!
    
    var hotModelArr = [HotInvestorListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取最热投资人
        getHotInvestorList()
        // Do any additional setup after loading the view.
    }
    @IBAction func popVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deliverVC(_ sender: Any) {
     
        let  uid = UserDefaults.standard.integer(forKey: "uid")
        if self.userId == uid {
                let  showProviderVC = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "MyHomePageViewControllerID") as! MyHomePageViewController
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }else{
                let  showProviderVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
                showProviderVC.id = self.userId
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }
    }
    
    @IBAction func getMore(_ sender: Any) {
        let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "InvestorListVCID") as! InvestorListVC
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    //getHotInvestorList
    func  getHotInvestorList(){
        NetWorkTool.shareInstance.getHotInvestorList { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                            self?.hotModelArr.append(statusViewModel)
                            if i == 0 {
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg1.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName1.text = statusViewModel.userName
                                self?.roundName1.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor))
                                self?.hotVoteChildView1.addGestureRecognizer(gesture)
                            }else if  i == 1{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg2.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName2.text = statusViewModel.userName
                                self?.roundName2.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor2))
                                self?.hotVoteChildView2.addGestureRecognizer(gesture)
                            }else if i == 2{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg3.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName3.text = statusViewModel.userName
                                self?.roundName3.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor3))
                                self?.hotVoteChildView3.addGestureRecognizer(gesture)
                            }
                            
                        }
                    }
                    if dictArr.count == 0 {
                        self?.presentHintMessage(hintMessgae: "未查找到数据", completion: nil)
                    }
                }
                
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
            
        }
    
    }
    
    
    @objc  func pushHotInvestor(){
        
        if hotModelArr.count > 0 {
            let model = hotModelArr[0]
            let  uid = UserDefaults.standard.integer(forKey: "uid")
            if model.uid as? Int == uid {
                let  showProviderVC = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "MyHomePageViewControllerID") as! MyHomePageViewController
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }else{
                let  showProviderVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
                showProviderVC.id = model.uid as? Int
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }
        }
        
    }
    
    @objc  func pushHotInvestor2(){
        if hotModelArr.count > 0 {
            let model = hotModelArr[1]
            let  uid = UserDefaults.standard.integer(forKey: "uid")
            if model.uid as? Int == uid {
                let  showProviderVC = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "MyHomePageViewControllerID") as! MyHomePageViewController
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }else{
                let  showProviderVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
                showProviderVC.id = model.uid as? Int
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }
        }
    }
    
    @objc  func pushHotInvestor3(){
        if hotModelArr.count > 0 {
            let model = hotModelArr[2]
            let  uid = UserDefaults.standard.integer(forKey: "uid")
            if model.uid as? Int == uid {
                let  showProviderVC = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "MyHomePageViewControllerID") as! MyHomePageViewController
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }else{
                let  showProviderVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
                showProviderVC.id = model.uid as? Int
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }
        }
    }
 
}
