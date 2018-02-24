//
//  DetailInfoTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/24.
//

import UIKit

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
                    maskButtonCons.constant =  30
                    break
                case 1 :
                    self.circleAddBtn.titleLabel?.text = "审核中"
                    maskButtonCons.constant =  30
                    break
                case 3 :
                    self.circleAddBtn.titleLabel?.text = "再次申请"
                    maskButtonCons.constant =  30
                    break
                default:
                    maskButtonCons.constant =  0
                    break
                }
            }
            
            self.detailTextLab.text = ""
        }
    }
    
    
    
}
