//
//  MainVC.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation
import UIKit

class MainVC: UIViewController{
    
    static func instance() -> MainVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainVC
    }
    
    public static var mInstance:MainVC? = nil

    
    override func viewDidLoad() {
        MainVC.mInstance = self
        
        
//        UrlHandlerManager.sharedInstance.mainActivated = true
//        UrlHandlerManager.sharedInstance.processUrl()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
