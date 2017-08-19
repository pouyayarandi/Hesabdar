//
//  HelpViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/19/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import Auk

class HelpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var slider: UIScrollView!
    
    @IBAction func closeHelp(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        UIApplication.shared.keyWindow?.rootViewController = delegate.bar
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View config
    
    func viewConfig() {
        slider.auk.show(image: UIImage(named: "tag")!)
        slider.auk.show(image: UIImage(named: "transaction")!)
        slider.auk.show(image: UIImage(named: "giving")!)
        slider.auk.show(image: UIImage(named: "getting")!)
    }

}
