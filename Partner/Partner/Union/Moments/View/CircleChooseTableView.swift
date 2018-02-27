//
//  CircleChooseTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/6.
//

import UIKit

class CircleChooseTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var  userModelArr = [MyCircleEntityModel]() {
        didSet {
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModelArr.count
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let  model = userModelArr[indexPath.row]
//        print(model.selected)
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "CircleChooseTableViewCellID", for: indexPath) as! CircleChooseTableViewCell
        if  userModelArr.count > 0 {
          let  model = userModelArr[indexPath.row]
          cell.model = model
        }
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate   = self
        self.dataSource = self
        getMyCircleEntityList()
    }
    
    //请求网络
    func getMyCircleEntityList(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        NetWorkTool.shareInstance.getMyCircleEntityList(token: access_token) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for dict in dictArr{
                        if  let statusViewModel = MyCircleEntityModel.mj_object(withKeyValues: dict){
                            self?.userModelArr.append(statusViewModel)
                        }
                    }
                    self?.reloadData()
            }else{
               
            }
        }
    }
  }
}



class   CircleChooseTableViewCell : UITableViewCell{
    @IBOutlet weak var circleName: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    var  model = MyCircleEntityModel() {
        didSet {
            self.circleName.text = model.name! as String
            
        }
    }
    
    
    @IBAction func chooseBtnClick(_ sender: Any) {
        self.chooseBtn.isSelected =  !self.chooseBtn.isSelected
        if chooseBtn.isSelected {
            model.selected = 1
        }else{
            model.selected = 0
        }
        
    }
    
}
