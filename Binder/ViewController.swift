//
//  ViewController.swift
//  Binder
//
//  Created by Mahesh.me on 1/19/17.
//  Copyright © 2017 Mahesh.me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bind: Bind!
    
    override func loadView() {
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.white
        
        bind = Bind.init(frame: CGRect.zero)
        self.view.addSubview(bind)
    }
    
    override func viewWillLayoutSubviews() {
        bind.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.width/2)
        bind.center = CGPoint.init(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
    }
}

