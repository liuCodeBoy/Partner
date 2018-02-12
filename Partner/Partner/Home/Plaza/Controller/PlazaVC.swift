//
//  PlazaVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/6.
//

import UIKit

class PlazaVC: UIViewController {
    var loopView: LoopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let URLArr = [URL(string: "http://ow1i9ri5b.bkt.clouddn.com/Screen%20Shot%202017-10-21%20at%205.35.48%20PM.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/%E8%BD%AE%E6%92%AD%E5%9B%BE2.png"),
                      URL(string: "http://ow1i9ri5b.bkt.clouddn.com/%E8%BD%AE%E6%92%AD%E5%9B%BE.png")]
        loopView = LoopView.init(images: URLArr as! [URL], frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 160), isAutoScroll: true)
        self.view.addSubview(loopView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
