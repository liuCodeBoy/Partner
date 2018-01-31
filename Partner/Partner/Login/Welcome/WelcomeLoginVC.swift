//
//  WelcomeLoginVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/3.
//

import UIKit

class WelcomeLoginVC: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var aa: UIButton!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var welcomeScrollview: UIScrollView!
    var _pageControl: UIPageControl!
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    @IBAction func showRegitserLoginVC(_ sender: Any) {
        self.view.isHidden = true
//          let RegisterAndLoginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterAndLoginVCID")
//         let  navRegistAndLoginVC = UINavigationController.init(rootViewController: RegisterAndLoginVC)
//        self.present(navRegistAndLoginVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        let  layer   = CALayer.init(layer: self)
//        layer.frame  =  aa.frame
//        layer.shadowOffset = CGSize.init(width: 5, height: 5)
//        layer.shadowOpacity = 0.8;
//        layer.backgroundColor = UIColor.gray.cgColor
//        layer.cornerRadius = 20
//        
//        self.view.layer.addSublayer(layer)
        
        
        welcomeScrollview.delegate = self
        _pageControl = UIPageControl.init()
        _pageControl.frame = CGRect.init(x: 0 , y: 0, width:pageView.frame.width , height: pageView.frame.height)
        _pageControl.numberOfPages = 3;//指定页面个数
        _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
        //添加委托方法，当点击小白点就执行此方法
        
        _pageControl.pageIndicatorTintColor = UIColor.white // 设置非选中页的圆点颜色
        _pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.7239996791, green: 0.8308950067, blue: 0.8865274787, alpha: 1) // 设置选中页的圆点颜色
        self.pageView.addSubview(_pageControl)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //pagecontroll的委托方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let  page = scrollView.contentOffset.x / scrollView.frame.size.width;
        switch page {
        case 0:
             _pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.7239996791, green: 0.8308950067, blue: 0.8865274787, alpha: 1)
             break
        case  1:
             _pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.7081480622, green: 0.8769126534, blue: 0.8800068498, alpha: 1)
            break
        case  2:
             _pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.7960425019, green: 0.8475874662, blue: 0.6707105041, alpha: 1)
            break
        default:
            break
        }
    // 设置页码
        _pageControl.currentPage = Int(page);
    }


}
