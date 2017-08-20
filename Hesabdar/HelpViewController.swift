//
//  HelpViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/19/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import Auk

class HelpViewController: UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.delegate = self
        viewConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var slider: UIScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    
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
        for i in 1...4 {
            slider.auk.show(image: UIImage(named: String(i))!)
        }
        closeBtn.transform = CGAffineTransform(translationX: 0, y: 100)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if slider.auk.currentPageIndex == 3 {
            UIView.animate(withDuration: 0.3, animations: {
                self.closeBtn.transform = CGAffineTransform.identity
            })
        }
    }
}
