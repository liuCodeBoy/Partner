//
//  CriclePicktrueView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/2.
//

import UIKit
import MJRefresh
//定义提示闭包
typealias showInfoType = (String) -> ()
//弹出控制器闭包
typealias showVCType = (Int) -> ()
typealias postISCreateType = (Int) -> ()
class CriclePicktrueView: UICollectionView {
    var   showInfoTypeClouse : showInfoType?
    var   showVCClouse       : showVCType?
    var   postiSCreateClouse : postISCreateType?
    var   modelArr        = [CircleModel]()
    var   othersModelArr  = [CircleModel]()
    var   pageNum         = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate   = self
        
        loadRefreshComponet(tableView: self)
        setdeafultStatus()
        getSelfCircleInfo()
        getOtherCircleInfo()
    }
    
    
    //设置初始状态
    func setdeafultStatus(){
        self.modelArr.removeAll()
        self.othersModelArr.removeAll()
         pageNum  = 1
         nextPage = 1
    }
    
    
    //发送请求
    func getSelfCircleInfo(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        NetWorkTool.shareInstance.getMyCircleList(token: access_token) {[weak self](info, error) in
        if error == nil {
              // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    if  let  dictARR = info?["result"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = CircleModel.mj_object(withKeyValues: dict)
                            self?.modelArr.append(model!)
                        }
                        self?.mj_header.endRefreshing()
                        self?.reloadData()
                    }
                } else {
                    if self?.showInfoTypeClouse != nil {
                        let  errorShow  =  info!["msg"] as! String
                        self?.showInfoTypeClouse!(errorShow)
                    }
                    
              }
            }
        }
    }
    
    //其他圈子
    func  getOtherCircleInfo(){
        if  self.nextPage == 0 {
            self.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        
        NetWorkTool.shareInstance.getOtherCircleList(token: access_token, pageNum: pageNum, pageSize: 10) { [weak self](info, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    guard let resultArray = info else{
                        return
                    }
                    let dict  =   resultArray["result"] as? NSDictionary
                    if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                    {
                        if statusViewModel.nextPage == 0 {
                            self?.nextPage = 0
                        }else{
                            self?.nextPage = statusViewModel.nextPage as! Int
                        }
                        self?.pageNum += 1
                    }
                    
                    if  let  dictARR = info?["result"]!["list"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = CircleModel.mj_object(withKeyValues: dict)
                            self?.othersModelArr.append(model!)
                            
                        }
                        self?.mj_header.endRefreshing()
                        self?.reloadData()
                    }
                } else {
                    if self?.showInfoTypeClouse != nil {
                        let  errorShow  =  info!["msg"] as! String
                        self?.showInfoTypeClouse!(errorShow)
                    }
                }
            }
        }
      
    }
    
}



//初始化加载控件
extension  CriclePicktrueView {
    func loadRefreshComponet(tableView : UICollectionView) -> () {
        //默认下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    @objc func refresh() -> () {
        self.othersModelArr.removeAll()
        setdeafultStatus()
        getSelfCircleInfo()
        getOtherCircleInfo()
    }
    @objc func  endrefresh() -> (){
        getOtherCircleInfo()
        
    }
    
   
    
}






extension CriclePicktrueView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var  count = 0
        if section == 0 {
            count = (modelArr.count) + 1
        }else{
            count = othersModelArr.count
        }
        return count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  2
    }
    
    
    //分区的header与footer
     func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        
        //分区头
        if kind == UICollectionElementKindSectionHeader{
          
                reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "headerView", for: indexPath)
                //设置头部标题
                let label = reusableview.viewWithTag(1111) as! UILabel
                if indexPath.section == 0 {
                    label.text = "我的合伙圈"
                }else{
                    label.text = "其他社圈"
                }
        }else if kind == UICollectionElementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "footerView", for: indexPath)
        }
        return reusableview
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CriclePicCellID", for: indexPath) as! CriclePicktrueCell
        
        if indexPath.section == 0 && indexPath.row <= modelArr.count - 1{
            let model =  modelArr[indexPath.row]
            cell.cellModel = model
        }
        if indexPath.section == 0  && indexPath.row == (self.modelArr.count){
             cell.addView.isHidden = false
        }else{
             cell.addView.isHidden = true
        }
        
        if indexPath.section ==  1 && othersModelArr.count > 0 {
            cell.cellModel = othersModelArr[indexPath.row]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == self.modelArr.count {
            //CreateCricleVCID
            if self.showVCClouse != nil{
                self.showVCClouse!(0)
            }
        }else{
            if self.showVCClouse != nil && indexPath.section == 0 && self.postiSCreateClouse != nil{
                if self.modelArr.count > 0 {
                let model = self.modelArr[indexPath.row]
                self.postiSCreateClouse!(model.create as! Int)
                self.showVCClouse!(model.circleId as! Int)
                }
            }else if self.showVCClouse != nil && indexPath.section == 1  && self.postiSCreateClouse != nil{
                guard  self.othersModelArr.count > 0 else{
                    return
                }
                let model = self.othersModelArr[indexPath.row]
                self.postiSCreateClouse!(2)
                self.showVCClouse!(model.circleId as! Int)
            }
        }
    }
}
    
    
    



class CriclePicktrueCell : UICollectionViewCell {
    @IBOutlet weak var CircleName: UILabel!
    @IBOutlet weak var member1Imag: UIImageView!
    @IBOutlet weak var member3Image: UIImageView!
    @IBOutlet weak var member2Image: UIImageView!
    @IBOutlet weak var CircleGrounpNum: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var addView: UIView!
    var  cellModel : CircleModel?{
        didSet{
            if  let  tempName = cellModel?.circleName{
                CircleName.text = tempName
            }
            
            if let   mainBacImg = cellModel?.imgUrl{
                showImageView.sd_setImage(with: URL.init(string: mainBacImg), placeholderImage: nil)
            }
            if let   numLab = cellModel?.membNum{
                CircleGrounpNum.text = "\(numLab)名成员"
            }
            if let imageStrArr = cellModel?.membImgUrls{
                for i  in 0..<imageStrArr.count {
                    switch i {
                    case 0:
                        member1Imag.sd_setImage(with: URL.init(string: imageStrArr[0]), placeholderImage: nil)
                        member2Image.isHidden = true
                        member3Image.isHidden = true
                    case 1:
                        member2Image.sd_setImage(with: URL.init(string: imageStrArr[1]), placeholderImage: nil)
                        member2Image.isHidden = false
                        member3Image.isHidden = true
                    case 2:
                        member3Image.sd_setImage(with: URL.init(string: imageStrArr[2]), placeholderImage: nil)
                        member2Image.isHidden = false
                        member3Image.isHidden = false
                    default: break
                        
                    }
                }
            }
        }
    }
}
//    @IBOutlet weak var pictureCellView: UIImageView!

