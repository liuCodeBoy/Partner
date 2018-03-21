//
//  ServiceMainFounderListTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceMainFounderListTableViewCell: UITableViewCell {
    @IBOutlet weak var image1: RoundRectImage!
    @IBOutlet weak var nickName1: UILabel!
    @IBOutlet weak var detailLab1: UILabel!
    @IBOutlet weak var kindType1: StrokeLabel!
    @IBOutlet weak var kindType2: StrokeLabel!
    
    @IBOutlet weak var shadow1: ShadowView!
    @IBOutlet weak var shadow2: ShadowView!
    @IBOutlet weak var shadow3: ShadowView!
    
    @IBOutlet weak var image2: RoundRectImage!
    @IBOutlet weak var nickName2: UILabel!
    @IBOutlet weak var detailLab2: UILabel!
    @IBOutlet weak var kind2Type1: StrokeLabel!
    @IBOutlet weak var kind2Type2: StrokeLabel!
    
    @IBOutlet weak var image3: RoundRectImage!
    @IBOutlet weak var nickName3: UILabel!
    @IBOutlet weak var detailLab3: UILabel!
    @IBOutlet weak var kind3Type1: StrokeLabel!
    @IBOutlet weak var kind3Type2: StrokeLabel!
    var modelArr = [HotInvestorListModel]()
    var pushVC : postISCreateType?
    
    
    @objc func button1Click(_ sender: Any) {
        if modelArr.count > 0 {
            let model = modelArr[0]
            if self.pushVC != nil {
                pushVC!(model.uid as! Int)
            }
        }
        
    }
    
    @objc func button2Click(_ sender: Any) {
    
        if modelArr.count > 0 {
            let model = modelArr[1]
            if self.pushVC != nil {
                pushVC!(model.uid as! Int)
            }
        }
    }
    
    @objc func button3(_ sender: Any) {
        if modelArr.count > 0 {
            let model = modelArr[2]
            if self.pushVC != nil {
                pushVC!(model.uid as! Int)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getHotInvestorList()
    }
}

extension ServiceMainFounderListTableViewCell {

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
                            self?.modelArr.append(statusViewModel)
                            if i == 0 {
                                if let url = statusViewModel.userImgUrl {
                                    self?.image1.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.nickName1.text = statusViewModel.userName
                                self?.detailLab1.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.button1Click(_:)))
                                self?.shadow1.addGestureRecognizer(gesture)
                                if let dictArr = statusViewModel.industryList {
                                    if dictArr.count >= 1 {
                                    if let dictStr = dictArr[0]["induName"]{
                                        self?.kindType1.isHidden = false
                                        self?.kindType1.text = dictStr as? String
                                    }
                                 }
                                    if dictArr.count >= 2{
                                        if let dictStr = dictArr[1]["induName"]{
                                            self?.kindType2.isHidden = false
                                            self?.kindType2.text = dictStr as? String
                                        }
                                    }else{
                                        self?.kindType2.isHidden = true

                                    }
                                }
                                
                            }else if  i == 1{
                                if let url = statusViewModel.userImgUrl {
                                    self?.image2.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.nickName2.text = statusViewModel.userName
                                self?.detailLab2.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.button2Click(_:)))
                                self?.shadow2.addGestureRecognizer(gesture)
                                if let dictArr = statusViewModel.industryList {
                                    if dictArr.count >= 1 {
                                        if let dictStr = dictArr[0]["induName"]{
                                            self?.kind2Type1.isHidden = false
                                            self?.kind2Type1.text = dictStr as? String
                                        }
                                    }
                                    if dictArr.count >= 2{
                                        if let dictStr = dictArr[1]["induName"]{
                                            self?.kind2Type2.isHidden = false
                                            self?.kind2Type2.text = dictStr as? String
                                        }
                                    }else{
                                        self?.kind2Type2.isHidden = true
                                        
                                    }
                                }
                            }else if i == 2{
                                if let url = statusViewModel.userImgUrl {
                                    self?.image3.setImageWith(URL.init(string: url)!, placeholderImage: nil)
                                }
                                self?.nickName3.text = statusViewModel.userName
                                self?.detailLab3.text = statusViewModel.roundName
                                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self?.button3(_:)))
                                self?.shadow3.addGestureRecognizer(gesture)
                                if let dictArr = statusViewModel.industryList {
                                    if dictArr.count >= 1 {
                                        if let dictStr = dictArr[0]["induName"]{
                                            self?.kind3Type1.isHidden = false
                                            self?.kind3Type1.text = dictStr as? String
                                        }
                                    }
                                    if dictArr.count >= 2{
                                        if let dictStr = dictArr[1]["induName"]{
                                            self?.kind3Type2.isHidden = false
                                            self?.kind3Type2.text = dictStr as? String
                                        }
                                    }else{
                                        self?.kind3Type2.isHidden = true
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            }else{
               // let  errorShow  =  result!["msg"] as! String
            }
            
        }
    }
    
    
    
    
}

