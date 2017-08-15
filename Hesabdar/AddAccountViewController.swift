//
//  AddAccountViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AddAccountViewController: UIViewController {
    
    let color = Color()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var idField: UITextField!
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "ثبت حساب"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        let saveButton = UIBarButtonItem(title: "ذخیره", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func save() {
        if let title = titleField.text, title != "", let id = idField.text, id != "" {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Account", in: context)
            let account = Account(entity: entity!, insertInto: context)
            
            account.title = title
            account.accID = id
            
            context.insert(account)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
