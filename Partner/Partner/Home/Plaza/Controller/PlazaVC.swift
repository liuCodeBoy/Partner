//
//  PlazaVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/6.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopImageView()
        // 获取最热投资人
        getHotInvestorList()
        getProjectList()
        getTypeList()
    }
    
    
    
    
    
    //addTopImageView
    func addTopImageView(){
        let URLArr = [URL(string: "http://ow1i9ri5b.bkt.clouddn.com/Screen%20Shot%202017-10-21%20at%205.35.48%20PM.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/%E8%BD%AE%E6%92%AD%E5%9B%BE2.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/%E8%BD%AE%E6%92%AD%E5%9B%BE.png")]
        loopView = LoopView.init(images: URLArr as! [URL], frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 160), isAutoScroll: true)
        self.imageHeadView.addSubview(loopView)
    }
   
}

extension PlazaVC {
    
    //getHotInvestorList
    func  getHotInvestorList(){
        NetWorkTool.shareInstance.getHotInvestorList { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                            if i == 0 {
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg1.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName1.text = statusViewModel.userName
                                self?.roundName1.text = statusViewModel.roundName
                            }else if  i == 1{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg2.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName2.text = statusViewModel.userName
                                self?.roundName2.text = statusViewModel.roundName
                            }else if i == 2{
                                if let url = statusViewModel.userImgUrl {
                                    self?.hotImg3.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.hotName3.text = statusViewModel.userName
                                self?.roundName3.text = statusViewModel.roundName
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
    
    
    //项目列表（project/getProjectList）
    func  getProjectList(){
        NetWorkTool.shareInstance.getProjectList(token: UserDefaults.standard.string(forKey: "token"), order: 1, type: nil, id: nil, fuzzy: nil, pageNum: 1) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"]!["list"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = ProjectListModel.mj_object(withKeyValues: dictArr[i]){
                            if i == 0 {
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg1.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                            }else if  i == 1{
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg2.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                            }else if i == 2{
                                if let url = statusViewModel.logoUrl {
                                    self?.hotProjectImg3.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
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
    
    
    //资讯类型列表（info/type/list）
    func getTypeList(){
//        TypeListModel
        NetWorkTool.shareInstance.getTypeList {[weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = TypeListModel.mj_object(withKeyValues: dictArr[i]){
                            if i == 0 {
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg1.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                   self?.informationLab1.text = statusViewModel.typeName
                                }
                            }else if  i == 1{
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg2.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.informationLab2.text = statusViewModel.typeName
                            }else if i == 2{
                                if let url = statusViewModel.imgUrl {
                                    self?.informationImg3.setImageWith(URL.init(string: url)!, placeholderImage: nil)
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
