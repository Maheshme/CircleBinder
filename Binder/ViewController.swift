//
//  ViewController.swift
//  Binder
//
//  Created by Mahesh.me on 1/19/17.
//  Copyright © 2017 Mahesh.me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//testcommit
    var bind: Bind!
    var curveBinder: CurveBinder!
    
    override func loadView() {
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        
        bind = Bind.init(frame: CGRect.zero)
        self.view.addSubview(bind)
        
        curveBinder = CurveBinder.init(frame: CGRect.zero)
        self.view.addSubview(curveBinder)
    }
    
    override func viewWillLayoutSubviews() {
        bind.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.width/2)
        bind.center = CGPoint.init(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4)
        curveBinder.frame = CGRect.init(x: 0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
    }
}

