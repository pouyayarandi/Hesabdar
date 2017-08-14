//
//  AddTransactionViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController {
    
    var selectedAcc: Account?
    var selectedTag: Tag?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigs()
        chooseStack.transform = CGAffineTransform(translationX: 0, y: 250)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var chooseStack: UIStackView!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var tagBtn: UIButton!
    
    @IBAction func showAccount(_ sender: Any) {
        let accountView = AccountTableViewController(choosable: true)
        accountView.view.frame = chooseView.frame
        chooseView.addSubview(accountView.view)
        self.addChildViewController(accountView)
        self.didMove(toParentViewController: accountView)
        goUp()
    }
    @IBAction func showTags(_ sender: Any) {
        let tagView = TagTableViewController(choosable: true)
        tagView.view.frame = chooseView.frame
        chooseView.addSubview(tagView.view)
        self.addChildViewController(tagView)
        self.didMove(toParentViewController: tagView)
        goUp()
    }
    @IBAction func close(_ sender: Any) {
        goDown()
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Control choose view
    
    func goUp() {
        UIView.animate(withDuration: 0.5) {
            self.titleField.resignFirstResponder()
            self.valueField.resignFirstResponder()
            self.chooseStack.transform = CGAffineTransform.identity
        }
    }
    func goDown() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.chooseStack.transform = CGAffineTransform(translationX: 0, y: 250)
        }) { (finished) in
            for i in 0..<self.chooseView.subviews.count {
                self.chooseView.subviews[i].removeFromSuperview()
            }
        }
    }
    
    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "ثبت تراکنش"
        
        let saveButton = UIBarButtonItem(title: "ذخیره", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func save() {
        if let title = titleField.text, title != "" {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
            let transaction = Transaction(entity: entity!, insertInto: context)
            
            transaction.title = title
            transaction.accID = selectedAcc?.accID ?? "0"
            transaction.date = NSDate()
            
            if valueField.text != "" {
                transaction.value = Float(valueField.text!)!
            } else {
                transaction.value = 0
            }
            
            if selectedTag != nil {
                transaction.tagName = selectedTag?.title
            } else {
                transaction.tagName = "بدون برچسب"
            }
            
            context.insert(transaction)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
