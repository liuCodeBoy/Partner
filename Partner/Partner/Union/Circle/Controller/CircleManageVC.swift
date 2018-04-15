//
//  CircleManageVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/24.
//

import UIKit
import ImagePicker
import Lightbox
class CircleManageVC: UIViewController,ImagePickerDelegate{
    var  circleDetailSeague : UIStoryboardSegue?
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var CircleNameText: UILabel!
    @IBOutlet weak var circleInfoLab: UILabel!
    @IBAction func dismissSelfVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailInfoVC()
    }
    
    @IBAction func chooseCircleImage(_ sender: Any) {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func dissolveCircle(_ sender: Any) {
    self.presentAlert(title: "确认解散当前圈子", hint: "", confirmTitle: "确认", cancelTitle: "取消", confirmation: { [weak self](action) in
        //解散圈子
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self?.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        let  sourceVC = self?.circleDetailSeague?.source as! CircleDetailVC
        NetWorkTool.shareInstance.dissolveCircle(token: access_token, id: sourceVC.circleId) { (result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return}
                self?.presentHintMessage(hintMessgae: "解散成功", completion: { (action) in
                     NotificationCenter.default.post(name: NSNotification.Name.init("Refresh"), object: nil)
                    let index =  (self?.navigationController?.viewControllers.index(of: self!))! - 2
                    self?.navigationController?.popToViewController((self?.navigationController?.viewControllers[index])!, animated: true)
                })
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }}, cancel: nil)
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CircleNameEditVCID" {
              let  tempVC  = segue.destination as! CircleNameEditVC
              tempVC.circlenameSegue = segue
              let  sourceVC = circleDetailSeague?.source as! CircleDetailVC
              tempVC.circleId = sourceVC.circleId
        }else if segue.identifier == "CircleMemberListVCID"{
             let  tempVC  = segue.destination as! CircleMemberListVC
              tempVC.circleMemberSegue = segue
             let  sourceVC = circleDetailSeague?.source as! CircleDetailVC
              tempVC.circleId = sourceVC.circleId
        }else if segue.identifier == "EditCircleInfoVCID"{
              let  tempVC  = segue.destination as! EditCircleInfoVC
             tempVC.circlenameSegue = segue
             let  sourceVC = circleDetailSeague?.source as! CircleDetailVC
             tempVC.circleId = sourceVC.circleId
        }
    }
    
    func loadDetailInfoVC() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        let  sourceVC = circleDetailSeague?.source as! CircleDetailVC
        NetWorkTool.shareInstance.getCircleSetInfo(token: access_token, id: sourceVC.circleId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dict  =   result!["result"] as? NSDictionary{
                if  let detailModel = CircleSettingInfoModel.mj_object(withKeyValues: dict){
                   self?.circleImageView.sd_setImage(with: URL.init(string: detailModel.imgUrl!), placeholderImage:nil)
                    if let number = detailModel.membNum{
                        self?.numberText.text = "\(String(describing: number))"
                    }
                   self?.circleInfoLab.text = detailModel.circleDesc
                   self?.CircleNameText.text = detailModel.circleName
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
  }
}


extension CircleManageVC {
    // MARK: - ImagePickerDelegate
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        imagePicker.dismiss(animated: true) {
            weak var  weakself = self
            for tempImage  in images{
                weakself?.circleImageView.image = tempImage
                //修改用户头像
                let  sourceVC = weakself?.circleDetailSeague?.source as! CircleDetailVC
                guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                    self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
                    return
                }
                //修改圈名称
                NetWorkTool.shareInstance.updateSocialCircle(token: access_token, circleId: sourceVC.circleId, type: 2, circleName: nil , image: tempImage, desc: nil) { [weak self](result, error) in
                    if  result?["code"] as? Int == 200  {
                        guard   result != nil else{
                            return
                        }
                      sourceVC.CircleDetImag.image = tempImage
                    }else{
                        let  errorShow  =  result!["msg"] as! String
                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    }
                }
              }
            }
        }
 }
