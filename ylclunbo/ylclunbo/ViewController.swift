//
//  ViewController.swift
//  ylclunbo
//
//  Created by  yanglc on 15/12/1.
//  Copyright © 2015年  yanglc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    var images:Array<UIImage>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        images = Array();
        
        for a in 1...5{
            var ima = UIImage(named: "img_0"+String(a));
            
            
            
            
            var cc = UIImageView(image: ima);
            
            
            
            cc.frame = CGRect(x: ((a-1) * Int(Float(scrollview.bounds.width))), y: 0, width: Int(Float(scrollview.bounds.width)), height:Int(Float(scrollview.bounds.height)));
            
            
            scrollview.addSubview(cc)
            
        }
        
        // scrollview.backgroundColor = UIColor.redColor();
        
        scrollview.contentSize = CGSize(width: 5 * scrollview.bounds.width , height: 0);
        
        scrollview.delegate = self;
        
        scrollview.pagingEnabled = true;
        scrollview.bounces = false;
        
        pagecontrol.currentPage = 0;
        
        pagecontrol.addTarget(self, action: "pagechanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updatetimer", userInfo: nil, repeats:true)
        
        
    }
    
    
    func restartTimer(){
        
        timer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updatetimer", userInfo: nil, repeats:true)
        
        
        // 添加到运行循环
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes);
        
    }
    
    func cancelTimer(){
        timer.invalidate();
        
    }
    
    
    var timer:NSTimer!;
    
    func updatetimer(){
        var page = pagecontrol.currentPage;
        page++;
        if(page > 4){
            page = 0;
        }
        
        
        pagecontrol.currentPage = page;
        
        scrollview.setContentOffset(CGPoint(x: page * Int(Float(scrollview.bounds.width)), y: 0), animated: true)
        
        print("updatetimer")
        
    }
    
    func pagechanged(pagecc:UIPageControl){
        print("sdfs")

        var page = pagecc.currentPage;

        
        scrollview.setContentOffset(CGPoint(x: page * Int(Float(scrollview.bounds.width)), y: 0), animated: true)
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = Int(Float(scrollview.contentOffset.x / scrollview.bounds.width));
        
        pagecontrol.currentPage = page;
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
         cancelTimer();
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        restartTimer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

