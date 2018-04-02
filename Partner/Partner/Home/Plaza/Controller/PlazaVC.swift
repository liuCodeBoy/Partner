//
//  PlazaVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/6.
//

import UIKit
typealias SliderType = (Int) -> ()
class PlazaVC: UIViewController {
    var loopView: LoopView!
    @IBOutlet weak var imageHeadView: UIView!
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
    //hotProject
    @IBOutlet weak var hotProjectImg1: RoundRectImage!
    @IBOutlet weak var hotProjectImg2: RoundRectImage!
    @IBOutlet weak var hotProjectImg3: RoundRectImage!
    
    //information
    @IBOutlet weak var informationLab1: UILabel!
    @IBOutlet weak var informationImg1: RoundRectImage!
    @IBOutlet weak var informationImg2: RoundRectImage!
    @IBOutlet weak var informationLab2: UILabel!
    @IBOutlet weak var informationImg3: RoundRectImage!
    @IBOutlet weak var informationLab3: UILabel!
    var   typeListModelArr = [TypeListModel]()
    var   projectListModelArr = [ProjectListModel]()
    
    var hotModelArr = [HotInvestorListModel]()
    //定义滑动闭包
    var  sliderClouse : SliderType?
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopImageView()
        // 获取最热投资人
        getHotInvestorList()
        getProjectList()
        getTypeList()
        
        if access_token == nil {
            let RegisterAndLoginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterAndLoginVCID") as!RegisterAndLoginVC
            RegisterAndLoginVC.isloaded = false
            let  navRegistAndLoginVC = UINavigationController.init(rootViewController: RegisterAndLoginVC)
            self.present(navRegistAndLoginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func infoShowMore(_ sender: Any) {
        if self.sliderClouse != nil {
            sliderClouse!(0)
        }
    }
    
    @IBAction func showHotInvestorVC(_ sender: Any) {
        //ServiceFindProjectViewControllerID
        let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "InvestorListVCID") as! InvestorListVC
        self.navigationController?.pushViewController(destVC, animated: true)
       }
    
    @IBAction func showInvestor(_ sender: Any) {
        let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceFindProjectViewControllerID") as! ServiceFindProjectViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    //addTopImageView
    func addTopImageView(){
        var URLArr = [URL]()
        NetWorkTool.shareInstance.getCarouselList { [weak self](result, error) in
            if error == nil {
                if  result?["code"] as? Int == 200  {
                    guard   result != nil else{
                        return
                    }
                let urlStrArr = result!["result"] as? [String]
                    for childStr in urlStrArr!{
                        let url = URL.init(string: childStr)
                        URLArr.append(url!)
                    }
                self?.loopView = LoopView.init(images: URLArr , frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 160), isAutoScroll: true)
                    self?.imageHeadView.addSubview((self?.loopView)!)
                }
            }
        }
     
    }
   
}

extension PlazaVC {
    
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
                self?.hotVoteChildView1.isHidden = true
                self?.hotVoteChildView2.isHidden = true
                self?.hotVoteChildView3.isHidden = true

                
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                            self?.hotModelArr.append(statusViewModel)
                            if i == 0 {
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg1.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                }
                                self?.hotName1.text = statusViewModel.userName
                                self?.roundName1.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor))
                                self?.hotVoteChildView1.addGestureRecognizer(gesture)
                                self?.hotVoteChildView1.isHidden = false
                            }else if  i == 1{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg2.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                }
                                self?.hotName2.text = statusViewModel.userName
                                self?.roundName2.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor2))
                                self?.hotVoteChildView2.addGestureRecognizer(gesture)
                                self?.hotVoteChildView2.isHidden = false

                            }else if i == 2{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg3.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                }
                                self?.hotName3.text = statusViewModel.userName
                                self?.roundName3.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushHotInvestor3))
                                self?.hotVoteChildView3.addGestureRecognizer(gesture)
                                self?.hotVoteChildView3.isHidden = false

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
    
    
    //项目列表（project/getProjectList）
    func  getProjectList(){
        
        hotProjectImg1.isHidden = true
        hotProjectImg2.isHidden = true
        hotProjectImg3.isHidden = true

        
        NetWorkTool.shareInstance.getProjectList(token: UserDefaults.standard.string(forKey: "token"), order: 1, type: nil, id: nil, fuzzy: nil, pageNum: 1) { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"]!["list"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = ProjectListModel.mj_object(withKeyValues: dictArr[i]){
                            
                            if i == 0 {
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg1.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushProject))
                                    self?.hotProjectImg1.addGestureRecognizer(gesture)
                                    self?.hotProjectImg1.isHidden = false

                                }
                            }else if  i == 1{
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg2.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushProject2))
                                    self?.hotProjectImg2.addGestureRecognizer(gesture)
                                    self?.hotProjectImg2.isHidden = false
                                }
                            }else if i == 2{
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg3.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.pushProject3))
                                    self?.hotProjectImg3.addGestureRecognizer(gesture)
                                    self?.hotProjectImg3.isHidden = false

                                }
                            }
                            self?.projectListModelArr.append(statusViewModel)
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
    
   @objc  func pushProject() -> () {
        let statusViewModel = projectListModelArr[0]
       let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
        destVC.projID = statusViewModel.projectId as? Int
        self.navigationController?.pushViewController(destVC, animated: true)
    
    }
    
    @objc  func pushProject2() -> () {
        let statusViewModel = projectListModelArr[1]
        let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
        destVC.projID = statusViewModel.projectId as? Int
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @objc  func pushProject3() -> () {
        
        let statusViewModel = projectListModelArr[2]
        let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
        destVC.projID = statusViewModel.projectId as? Int
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    //资讯类型列表（info/type/list）
    @objc func getTypeList(){
//        TypeListModel
        NetWorkTool.shareInstance.getTypeList {[weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = TypeListModel.mj_object(withKeyValues: dictArr[i]){
                            self?.typeListModelArr.append(statusViewModel)
                            if i == 0 {
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg1.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    self?.informationLab1.text = statusViewModel.typeName
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.tapInfo1))
                                    self?.informationImg1.addGestureRecognizer(gesture)
                                }
                            }else if  i == 1{
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg2.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.tapInfo2))
                                    self?.informationImg2.addGestureRecognizer(gesture)
                                }
                                self?.informationLab2.text = statusViewModel.typeName
                            }else if i == 2{
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg3.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.tapInfo3))
                                    self?.informationImg3.addGestureRecognizer(gesture)
                                }
                                self?.informationLab3.text = statusViewModel.typeName
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
}



extension PlazaVC {
    @objc  func tapInfo1(){
        if let  id = self.typeListModelArr[0].typeId  {
            if self.sliderClouse != nil {
                sliderClouse!(Int(truncating: id))
            }
        }
    }
    
    @objc  func tapInfo2(){
        if let  id = self.typeListModelArr[1].typeId  {
            if self.sliderClouse != nil {
                sliderClouse!(Int(truncating: id))
            }
        }
    }
    
    
    @objc  func tapInfo3(){
        if let  id = self.typeListModelArr[2].typeId  {
            if self.sliderClouse != nil {
                sliderClouse!(Int(truncating: id))
            }
        }
    }
    
    
}
