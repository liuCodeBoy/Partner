//
//  UnionMainVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/30.
//

import UIKit


class UnionMainVC: UIViewController {
    
    @IBOutlet weak var topContentView: UIView!
    var noticeBtn : UIButton?
    var modelArr = [NoticeInfoModel]()
    var   sliderView : UIView?
    //滚动视图
    var   scrollView : UIScrollView?
    var   isRead : Int?
    //滑动Btn数组
    var   sliderBtnArr  = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = true
        addTopViewChildsBtn()
        addChildScroll()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.noticeBtn != nil {
            self.noticeBtn?.removeFromSuperview()
        }
        loadNotice()
    }
  
    
    
    //初始化头部按钮
  func addTopViewChildsBtn(){
    let  btnArr = ["社联","社圈"]
    let  width  = (screenWidth - 50) / CGFloat(btnArr.count)
    for i in 0..<btnArr.count {
        let  btnStr  = btnArr[i]
        let  x       = CGFloat(i)  * width
        let btn = UIButton.init(frame: CGRect.init(x: x, y: 0, width: width, height: 60))
        btn.contentHorizontalAlignment = .center
        btn.contentVerticalAlignment   = .bottom
        btn.setTitle(btnStr, for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.7771913409, green: 0.7979340553, blue: 0.8144465089, alpha: 1), for: .normal)
        btn.setTitleColor( #colorLiteral(red: 0.3028550148, green: 0.4081297517, blue: 0.4641876817, alpha: 1),for: .selected)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tag = i+1212
        btn.addTarget(self, action: #selector(addOffSetX(btn:)), for: UIControlEvents.touchUpInside)
        sliderBtnArr.append(btn)
        self.topContentView.addSubview(btn)
        if  i == 0 {
            sliderView =  UIView.init()
            sliderView?.center.x = btn.center.x - 6
            sliderView?.frame.origin.y = btn.frame.maxY + 2
            sliderView?.frame.size = CGSize.init(width: 12, height: 3)
            sliderView?.backgroundColor = #colorLiteral(red: 0.2524492443, green: 0.3666573763, blue: 0.4243661463, alpha: 1)
            btn.isSelected = true
            self.topContentView.addSubview(sliderView!)
        }
      }
    }
    
    //添加通知按钮
    func   addNoticBtn(){
        let btn = UIButton.init(frame: CGRect.init(x: screenWidth - 50, y: 0, width: 50, height: 60))
        btn.contentHorizontalAlignment = .center
        btn.contentVerticalAlignment   = .bottom
        if self.isRead == 1 {
            btn.setImage(#imageLiteral(resourceName: "society_news_normal"), for: .normal)
        }else {
            btn.setImage(#imageLiteral(resourceName: "ring_noread"), for: .normal)
        }
        btn.addTarget(self, action: #selector(addNotice(btn:)), for: UIControlEvents.touchUpInside)
        self.noticeBtn = btn
        self.topContentView.addSubview(self.noticeBtn!)
    }
    
    //网络请求
    func loadNotice() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getNoticeApiList(token: access_token) { [weak self](result, error) in
            print(access_token)
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for dict in dictArr{
                        if  let statusViewModel = NoticeInfoModel.mj_object(withKeyValues: dict){
                            self?.modelArr.append(statusViewModel)
                        }
                    }
                    for model in (self?.modelArr)! {
                        if model.read == 1{
                            self?.isRead = 1
                        }else{ self?.isRead = 0}
                    }
                }
                self?.addNoticBtn()
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    
    //跳转通知控制器
    @objc  func   addNotice(btn : UIButton){
        let  noticeViewControllerVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "NoticeViewControllerID") as! NoticeViewController
        self.navigationController?.pushViewController(noticeViewControllerVC, animated: true)
        
    }
    
    
    //添加偏移量功能
   @objc  func   addOffSetX(btn : UIButton){
    UIView.animate(withDuration: 0.3) {
        weak var weakSelf = self
        weakSelf?.sliderView?.center.x = btn.center.x
        let  index = CGFloat(btn.tag - 1212)
        weakSelf?.scrollView?.contentOffset.x = index * screenWidth
       }
      for tempBtn  in topContentView.subviews{
        if  let   btn = tempBtn as? UIButton {
             btn.isSelected = false
        }
    }
    btn.isSelected = !btn.isSelected
   }
    
    //设置滚动
    func addBtnScroll(btn : UIButton){
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
        scrollView.contentSize = CGSize.init(width: screenWidth  *  2, height: screenHeight - 104)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        self.scrollView?.delegate = self
        //添加子控制器
        
         let momentVC  = AppDelegate.momentVC
        self.addChildViewController(momentVC)
        
        //CricleViewController 子控制器
        let cricleVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CricleViewControllerID")
        self.addChildViewController(cricleVC)
        
        momentVC.view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight - 104)
        self.scrollView?.addSubview(momentVC.view)
        cricleVC.view.frame = CGRect.init(x: screenWidth, y: 0, width: screenWidth, height: screenHeight - 104)
        self.scrollView?.addSubview(cricleVC.view)
        
        
    }
}


extension   UnionMainVC  : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let   page = Int(scrollView.contentOffset.x / screenWidth)
     let   tempBtn  = self.sliderBtnArr[page]
     addBtnScroll(btn: tempBtn)
        
    }
    
    
    
    
    
}
