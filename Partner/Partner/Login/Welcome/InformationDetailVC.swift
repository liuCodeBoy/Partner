//
//  InformationDetailVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/15.
//

import UIKit
import TZImagePickerController
class InformationDetailVC: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    var detailViewIsHidden : Bool = false
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var CompanyView: UIView!
    @IBOutlet weak var CommonUserView: UIView!
    @IBOutlet weak var genderbtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var jobNametextField: UITextField!
    @IBOutlet weak var communityIdLab: UITextField!
    var  communityID : Int?
    var  genderID    = 0
    
    //社区选择
    @IBOutlet weak var cityPickerView: UIPickerView!
    var  provinces =  [communityModel]() //展示省份
    var  cities =  [[communityModel]]()    //展示城市
    var  cityArr = [communityModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载城市数据
        loadData()
        CompanyView.isHidden = detailViewIsHidden
        //照片添加点击方法
        let imageTap = UITapGestureRecognizer.init(target: self, action: #selector(addPhotoClick))
        self.profileImageView.addGestureRecognizer(imageTap)
        self.setRoundRect(targets: [profileImageView])
        //指定委托
        self.cityPickerView.delegate = self;
        self.cityPickerView.dataSource = self;
    }
    //跳转控制器
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  nametextField.text != "请输入"  && genderbtn.titleLabel?.text != "请选择" else{
            self.presentHintMessage(hintMessgae: "请完善您的个人信息", completion: { (action) in
            })
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        NetWorkTool.shareInstance.perfectUserInfo(token: access_token, image: profileImageView.image, realName: nametextField.text!, gender: genderID, companyName: companyTextField.text, jobName: jobNametextField.text, communityId: communityID) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if result?["code"] as? Int == 200 {
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    return
                }
            }else{
                print(error)
            }
        }
    }
   
    //照片选择方
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showSexChoose(_ sender: Any) {
        let alert = UIAlertController(title: "请选择您的性别", message: "", preferredStyle: .actionSheet)
      
        let male = UIAlertAction(title: "男", style: .default, handler: { [weak self](action) in
            self?.genderbtn.setTitle("男", for: .normal)
            self?.genderID = 1
        })
        let female = UIAlertAction(title: "女", style: .default, handler: { [weak self](action) in
            self?.genderbtn.setTitle("女", for: .normal)
            self?.genderID = 2
        })
        let unknow = UIAlertAction(title: "保密", style: .default, handler: { [weak self](action) in
            self?.genderbtn.setTitle("保密", for: .normal)
            self?.genderID = 0
        })
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(unknow)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nametextField.resignFirstResponder()
        self.genderbtn.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
        self.companyTextField.resignFirstResponder()
        self.jobNametextField.resignFirstResponder()
        self.communityIdLab.resignFirstResponder()
        self.cityPickerView.isHidden = true
    }
    
    

}

//MARK: - 照片选择方法
extension InformationDetailVC : TZImagePickerControllerDelegate {
    @objc func addPhotoClick() -> () {
        weak var  weakself = self
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionPhoto = UIAlertAction.init(title: "选择上传照片", style: .default) { (UIAlertAction) -> Void in
            weakself?.showLocalPhotoGallery()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionPhoto)
        weakself?.present(alert, animated: true, completion: nil)
}

    private func showLocalPhotoGallery(){
        weak var  weakself = self
        
        let  pushNumber = 1
        let  imagePickerVc = TZImagePickerController.init(maxImagesCount: pushNumber, delegate: self as TZImagePickerControllerDelegate)
        
        imagePickerVc?.didFinishPickingPhotosWithInfosHandle = {(photosArr , assets ,isSelectOriginalPhoto ,infos) in
            for i in  0..<photosArr!.count {
                weakself?.profileImageView?.image = photosArr?[i]
            }
            
        }
        
        self.present(imagePickerVc!, animated: true, completion: nil)
        
   }
}

  //MARK: - 城市选择
extension InformationDetailVC : UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBAction func showCityChoose(_ sender: Any) {
        
        self.cityArr = self.cities[0]
        self.cityPickerView.selectedRow(inComponent: 0)
        self.cityPickerView.reloadComponent(1)
        //弹出城市选择界面
        self.cityPickerView.isHidden = false
        
    }
    
    //加载数据
    func loadData(){
        //保存身份选择
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        //请求数据
        NetWorkTool.shareInstance.getCommunityCityList(token: access_token) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if result?["code"] as? Int == 200 {
                    let   provincesArr = result?["result"] as? NSArray
                    for   province  in  provincesArr! {
                    let   provinceDict  = province  as? NSDictionary
                    let   rotationModel = communityModel.mj_object(withKeyValues: provinceDict)
                    self?.provinces.append(rotationModel!)
                    if let  cityArr =  provinceDict!["commList"] as? [NSDictionary]{
                        var  tempArr = [communityModel]()
                        for  city  in cityArr{
                            let   cityModel = communityModel.mj_object(withKeyValues: city)
                            tempArr.append(cityModel!)
                        }
                        self?.cities.append(tempArr)
                      }
                    }
                    self?.cityPickerView.reloadAllComponents()
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var  rows = 0;
        switch (component) {
        case 0:
            rows = self.provinces.count;//根据plist文件中的数据返回rows
            break;
        case 1:
            rows = self.cityArr.count;
            break;
        default:
            break;
        }
        return rows;
     
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        switch (component) {
        case 0:
            title = self.provinces[row].name!
            break;
        case 1:
            title = self.cityArr[row].name!
            break;
        default:
            break;
        }
        return title;
    }
    //选中时回调的委托方法，在此方法中实现省份和城市间的联动
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard cityArr.count > 0 else {
            return
        }
        switch (component) {
        case 0://选中省份表盘时，根据row的值改变城市数组，刷新城市数组，实现联动
            self.cityArr = self.cities[row]
            self.cityPickerView.reloadComponent(1)
        break;
        case 1:
            self.communityIdLab.text = self.cityArr[row].name
            self.communityID = self.cityArr[row].id as! Int
            break;
        default:
            break;
        }
    }

}
