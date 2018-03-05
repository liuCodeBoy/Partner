//
//  AuthApplyUploadViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit
import ImagePicker
import Lightbox

class AuthApplyUploadViewController: UIViewController, ImagePickerDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // invest auth
    @IBOutlet weak var investAuth               : ShadowButton!
    @IBOutlet weak var investAuthScrollView     : UIScrollView!
    @IBOutlet weak var invAvatarImg             : RoundRectImage!
    @IBOutlet weak var invAvatarImgBtn          : ShadowButton!
    @IBOutlet weak var invCardImg               : RoundRectImage!
    @IBOutlet weak var invCardImgBtn            : ShadowButton!
    @IBOutlet weak var invRealNameLbl           : UILabel!
    @IBOutlet weak var invPhoneNumLbl           : UILabel!
    @IBOutlet weak var invEmailLbl              : UILabel!
    @IBOutlet weak var invIndustryLbl           : UILabel!
    @IBOutlet weak var invRoundLbl              : UILabel!
    @IBOutlet weak var invIdentityLbl           : UILabel!
    @IBOutlet weak var invAgencyView            : UIView!
    @IBOutlet weak var invAgencyNameLbl         : UILabel!
    @IBOutlet weak var invAgencyJobLbl          : UILabel!
    @IBOutlet weak var invAgencyOnWorkTimeLbl   : UILabel!
    
    // enterprise auth
    @IBOutlet weak var enterpriseAuth           : ShadowButton!
    @IBOutlet weak var enterpriseAuthScrollView : UIScrollView!
    @IBOutlet weak var entLicenseImg            : RoundRectImage!
    @IBOutlet weak var entLicenseImgBtn         : ShadowButton!
    @IBOutlet weak var entLogoImg               : RoundRectImage!
    @IBOutlet weak var entLogoImgBtn            : ShadowButton!
    @IBOutlet weak var entNameLbl               : UILabel!
    @IBOutlet weak var entTypeLbl               : UILabel!
    @IBOutlet weak var entRealNameLbl           : UILabel!
    @IBOutlet weak var entPhoneLbl              : UILabel!
    @IBOutlet weak var entMailLbl               : UILabel!
    @IBOutlet weak var entIntroLbl              : UILabel!
    @IBOutlet weak var entCreditCodeLbl         : UILabel!
    @IBOutlet weak var entLegalLbl              : UILabel!
    @IBOutlet weak var entLegalIDNumLbl         : UILabel!
    @IBOutlet weak var entLocationLbl           : UILabel!
    @IBOutlet weak var entDetialAddressLbl      : UILabel!
    
    
    @IBAction func investAuthClicked(_ sender: ShadowButton) {
        investAuth.setSelected()
        enterpriseAuth.reverseSelected()
        investAuthScrollView.isHidden = false
        enterpriseAuthScrollView.isHidden = true
    }
    
    @IBAction func enterpriseAuthClicked(_ sender: ShadowButton) {
        investAuth.reverseSelected()
        enterpriseAuth.setSelected()
        investAuthScrollView.isHidden = true
        enterpriseAuthScrollView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func uploadImg(_ sender: ShadowButton) {
        invAvatarImgBtn.isSelected = false
        invCardImgBtn.isSelected = false
        entLicenseImgBtn.isSelected = false
        entLogoImgBtn.isSelected = false
        
        sender.isSelected = true
        
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

    }
    
    @objc func chooseInvAvatarImg(_ sender: AnyObject) {
        
        

        invAvatarImg.isTapped = false
        invCardImg.isTapped = false
        entLicenseImg.isTapped = false
        entLogoImg.isTapped = false
        
//        img.isTapped = true
        
        
    }
    
    
    // MARK:- image picker protocol functions
    
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
            weak var weakSelf = self
            for img in images {
                // TODO:- set image
                if (weakSelf?.invAvatarImgBtn.isSelected)! {
                    weakSelf?.invAvatarImgBtn.setBackgroundImage(img, for: .normal)
                } else if (weakSelf?.invCardImgBtn.isSelected)! {
                    weakSelf?.invCardImgBtn.setBackgroundImage(img, for: .normal)
                } else if (weakSelf?.entLicenseImgBtn.isSelected)! {
                    weakSelf?.entLicenseImgBtn.setBackgroundImage(img, for: .normal)
                } else if (weakSelf?.entLogoImgBtn.isSelected)! {
                    weakSelf?.entLogoImgBtn.setBackgroundImage(img, for: .normal)
                }
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
