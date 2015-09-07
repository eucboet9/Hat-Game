//
//  AboutVC.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 05.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewWillLayoutSubviews() {
        textView.setContentOffset(CGPointZero, animated: false)
    }

}
