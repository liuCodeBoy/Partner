//
//  UnionMainVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/30.
//

import UIKit

class UnionMainVC: UIViewController {
    @IBOutlet weak var topContentView: UIView!
    var   sliderView : UIView?
    //滚动视图
    var   scrollView : UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true
        addTopViewChildsBtn()
        addChildScroll()
        
        
    }
    
    //初始化头部按钮
  func addTopViewChildsBtn(){
    let  btnArr = ["社联","社圈","私信","寻合伙"]
    let  width  = (screenWidth - 40) / CGFloat(btnArr.count)
    for i in 0..<btnArr.count {
        let  btnStr  = btnArr[i]
        let  x       = CGFloat(i)  * width
        let btn = UIButton.init(frame: CGRect.init(x: x, y: 0, width: width, height: 60))
        btn.contentHorizontalAlignment = .center
        btn.contentVerticalAlignment   = .bottom
        btn.setTitle(btnStr, for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.3028550148, green: 0.4081297517, blue: 0.4641876817, alpha: 1), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.7771913409, green: 0.7979340553, blue: 0.8144465089, alpha: 1), for: .selected)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(addOffSetX(btn:)), for: UIControlEvents.touchUpInside)
        self.topContentView.addSubview(btn)
        if  i == 0 {
            sliderView =  UIView.init()
            sliderView?.center.x = btn.center.x - 6
            sliderView?.frame.origin.y = btn.frame.maxY + 2
            sliderView?.frame.size = CGSize.init(width: 12, height: 3)
            sliderView?.backgroundColor = #colorLiteral(red: 0.2524492443, green: 0.3666573763, blue: 0.4243661463, alpha: 1)
            self.topContentView.addSubview(sliderView!)
        }
      }
    }
    
    //添加偏移量功能
   @objc  func   addOffSetX(btn : UIButton){
    UIView.animate(withDuration: 0.3) {
        weak var weakSelf = self
        weakSelf?.sliderView?.center.x = btn.center.x
       }
    for tempBtn  in topContentView.subviews{
        if  let   btn = tempBtn as? UIButton {
             btn.isSelected = false
        }
    }
    
    btn.isSelected = !btn.isSelected
    }
    
    //添加子控制器的ScrollView
    func addChildScroll(){
        //添加滚动控件
        let  scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 64, width:screenWidth, height: screenHeight - 104))
        scrollView.backgroundColor = UIColor.red
        scrollView.contentSize = CGSize.init(width: screenWidth  *  4, height: screenHeight - 64)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        //添加子控制器
        
         let momentVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "MomentMainVCID")
        self.addChildViewController(momentVC)
        self.scrollView?.addSubview(momentVC.view)
        
        
    }
}
