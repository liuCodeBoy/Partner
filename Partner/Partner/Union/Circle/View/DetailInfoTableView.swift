//
//  DetailInfoTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/24.
//

import UIKit
import NoticeBar
class DetailInfoTableView : UITableView,UITableViewDelegate,UITableViewDataSource{
    var topDetailModel : CicrleDetailModel?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var  sectionRowNumber : Int?
        if section == 0 {
            sectionRowNumber = 1
        }
        return sectionRowNumber!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.dequeueReusableCell(withIdentifier: "CircleDetailTopCellID", for: indexPath) as! CircleDetailTopCell
         cell.detailModel = topDetailModel
         return  cell
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rowHeight = UITableViewAutomaticDimension
        self.bounces = false
        self.estimatedRowHeight = 200
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    

}


class  CircleDetailTopCell : UITableViewCell{
    @IBOutlet weak var circleNameLab: UILabel!
    @IBOutlet weak var communityLab: UILabel!
    @IBOutlet weak var detailTextLab: UILabel!
    @IBOutlet weak var circleAddBtn: UIButton!
    
    @IBOutlet weak var maskButtonCons: NSLayoutConstraint!
    var  detailModel : CicrleDetailModel? {
        didSet{
            self.circleNameLab.text = detailModel?.circleName
            if let  number = detailModel?.membNum {
             self.communityLab.text  = "\(number)名成员"
             let status = detailModel?.status
                switch Int(status!) {
                case 0:
                    self.circleAddBtn.titleLabel?.text = "提交申请"
                    circleAddBtn.isHidden = false
                    break
                case 1 :
                    self.circleAddBtn.titleLabel?.text = "审核中"
                    circleAddBtn.isHidden = false
                    break
                case 3 :
                    self.circleAddBtn.titleLabel?.text = "再次申请"
                    circleAddBtn.isHidden = false
                    break
                default:
                    circleAddBtn.isHidden = true
                    break
                }
            }
            if let desString = (detailModel?.desc) as? String {
                self.detailTextLab.text = "简介： "  + desString
            }

        }
    }
    
    @IBAction func applyJoinClick(_ sender: UIButton) {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        var color = UIColor.red
        var showInfo = ""
        if let circleID = detailModel?.circleId{
            NetWorkTool.shareInstance.applyJoin(token: access_token, id: Int(truncating: circleID), finished: { (result, error) in
                if  result?["code"] as? Int == 200  {
                    guard   result != nil else{
                        return
                    }
                    color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                    showInfo = "申请中"
                    sender.setTitle(showInfo, for: .normal)
                }else{
                    showInfo =  result!["msg"] as! String
                }
          
                let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 1.5, completed: nil)
            })
        }
       
    }
    
    
}
