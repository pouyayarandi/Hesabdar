//
//  HomeViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/16/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let color = Color()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigs()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Config view
    
    func viewConfigs() {
        navigationItem.title = "خانه"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.isTranslucent = false
    }
}
