//
//  AddAccountViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AddAccountViewController: UIViewController, UITextFieldDelegate {
    
    let model = Model()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
        balanceField.delegate = self
        balanceField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        viewConfigs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Textfield
    
    func textFieldDidChange(textField: UITextField) {
        if textField == balanceField, textField.text != "" {
            var text = textField.text ?? ""
            var fineText = ""
            for char in text.characters {
                if char != "," {
                    fineText.append(char)
                }
            }
            let value = Int(fineText) ?? 0
            textField.text = model.format().string(from: value as NSNumber)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == titleField {
            idField.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "ثبت حساب"
        self.navigationController?.navigationBar.barTintColor = model.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        let saveButton = UIBarButtonItem(title: "ذخیره", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func save() {
        if let title = titleField.text, title != "", let id = idField.text, id != "" {
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
            
            if balanceField.text != "" {
                saveBalance()
            }
        }
    }
    
    func saveBalance() {
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
        let transaction = Transaction(entity: entity!, insertInto: context)
        
        transaction.title = "موجودی اولیه حساب " + titleField.text!
        transaction.value = Float(model.format().number(from: balanceField.text!)!)
        transaction.date = NSDate()
        transaction.accID = idField.text
        transaction.tagName = "دریافت"
        
        context.insert(transaction)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
}
