//
//  ViewController.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/01.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet weak var splashView: UIImageView!
    
    var flowManager:FlowManager? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        // Do any additional setup after loading the view.
        flowManager = FlowManager(viewcontroller: self)
        flowManager?.start()
    }
}

