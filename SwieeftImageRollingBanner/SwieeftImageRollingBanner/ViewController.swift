//
//  ViewController.swift
//  SwieeftImageRollingBanner
//
//  Created by Park GilNam on 2020/04/08.
//  Copyright © 2020 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: SwieeftImageRollingBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageUrls = ["https://raw.githubusercontent.com/swieeft/SwieeftImageRollingBanner/master/SwieeftImageRollingBanner/Resource/ract1.png",
                         "https://raw.githubusercontent.com/swieeft/SwieeftImageRollingBanner/master/SwieeftImageRollingBanner/Resource/ract2.png",
                         "https://raw.githubusercontent.com/swieeft/SwieeftImageRollingBanner/master/SwieeftImageRollingBanner/Resource/ract3.png",
                         "https://raw.githubusercontent.com/swieeft/SwieeftImageRollingBanner/master/SwieeftImageRollingBanner/Resource/ract4.png",
                         "https://raw.githubusercontent.com/swieeft/SwieeftImageRollingBanner/master/SwieeftImageRollingBanner/Resource/ract5.png"
        ]
        
        bannerView.imageUrls = imageUrls
    }
}

