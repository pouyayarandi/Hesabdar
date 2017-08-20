//
//  AddTransactionViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController, UITextFieldDelegate {
    
    var selectedAcc: Account?
    var selectedTag: Tag?
    var transaction: Transaction?
    var getting = false
    var edit = false
    var index = 0
    let model = Model()

    var tags = [Tag]()
    var accounts = [Account]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        viewConfigs()
        
        valueField.delegate = self
        titleField.delegate = self
        
        if edit {
            titleField.text = transaction?.title
            if getting {
                valueField.text = String(Int((transaction?.value)!))
            } else {
                valueField.text = String(Int(-(transaction?.value)!))
            }
            if transaction?.accID != "0" {
                selectedAcc = getAccount(id: (transaction?.accID!)!)
                accountBtn.setTitle(selectedAcc?.title, for: .normal)
            }
            if transaction?.tagName != "بدون برچسب", transaction?.tagName != "دریافت" {
                selectedTag = getTag(title: (transaction?.tagName)!)
                tagBtn.setTitle(selectedTag?.title, for: .normal)
            }
        }
        
        chooseStack.transform = CGAffineTransform(translationX: 0, y: 250)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        deleteAllChooseView()
        let accountView = AccountTableViewController(choosable: true)
        accountView.view.frame = chooseView.frame
        accountView.view.frame.origin.y -= 50
        chooseView.addSubview(accountView.view)
        self.addChildViewController(accountView)
        self.didMove(toParentViewController: accountView)
        goUp()
    }
    @IBAction func showTags(_ sender: Any) {
        deleteAllChooseView()
        let tagView = TagTableViewController(choosable: true)
        tagView.view.frame = chooseView.frame
        tagView.view.frame.origin.y -= 50
        chooseView.addSubview(tagView.view)
        self.addChildViewController(tagView)
        self.didMove(toParentViewController: tagView)
        goUp()
    }
    @IBAction func close(_ sender: Any) {
        goDown()
    }
    
    func setAndFetchAccounts() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        do {
            let result = try context.fetch(fetchRequest)
            accounts = result as! [Account]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func getAccount(id: String) -> Account {
        setAndFetchAccounts()
        for account in accounts {
            if account.accID == id {
                return account
            }
        }
        return Account()
    }
    
    func setAndFetchTags() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        
        do {
            let result = try context.fetch(fetchRequest)
            tags = result as! [Tag]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func getTag(title: String) -> Tag {
        setAndFetchTags()
        for tag in tags {
            if tag.title == title {
                return tag
            }
        }
        return Tag()
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(getting: Bool) {
        self.init(nibName: "AddTransactionViewController", bundle: nil)
        self.getting = getting
    }
    
    convenience init(transaction: Transaction, edit: Bool, getting: Bool, index: Int) {
        self.init(nibName: "AddTransactionViewController", bundle: nil)
        self.getting = getting
        self.edit = edit
        self.transaction = transaction
        self.index = index
        
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
            self.deleteAllChooseView()
        }
    }
    
    func deleteAllChooseView() {
        for i in 0..<self.chooseView.subviews.count {
            self.chooseView.subviews[i].removeFromSuperview()
        }
    }
    
    // MARK: - Textfield
    
    func textFieldDidChange(textField: UITextField) {
        if textField == valueField, textField.text != "" {
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
            valueField.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - View configs
    
    func viewConfigs() {
        if getting {
            navigationItem.title = "ثبت تراکنش دریافت"
        } else {
            navigationItem.title = "ثبت تراکنش پرداخت"
        }
        if edit {
            navigationItem.title = "ویرایش تراکنش"
        }
        
        let saveButton = UIBarButtonItem(title: "ذخیره", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        
        if getting {
            tagView.removeFromSuperview()
            accountBtn.setTitle("به حساب", for: .normal)
        }
    }
    
    func save() {
        if let title = titleField.text, title != "" {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if edit {
                
                transaction?.title = title
                transaction?.accID = selectedAcc?.accID ?? "0"
                
                if valueField.text != "" {
                    let val = Float(valueField.text!)!
                    if getting {
                        transaction?.value = val
                    } else {
                        transaction?.value = -(val)
                    }
                } else {
                    transaction?.value = 0
                }
                
                if selectedTag?.title != nil {
                    transaction?.tagName = selectedTag?.title
                } else {
                    if getting {
                        transaction?.tagName = "دریافت"
                    } else {
                        transaction?.tagName = "بدون برچسب"
                    }
                }
                
                transaction?.date = self.transaction?.date
                let nav = self.parent as! UINavigationController
                let parent = nav.childViewControllers.first as! TransactionTableViewController
                parent.transactions.remove(at: index)
                parent.transactions.insert(transaction!, at: index)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
                let transaction = Transaction(entity: entity!, insertInto: context)
                
                transaction.title = title
                transaction.accID = selectedAcc?.accID ?? "0"
                
                if valueField.text != "" {
                    let val = Float(model.format().number(from: valueField.text!)!)
                    if getting {
                        transaction.value = val
                    } else {
                        transaction.value = -(val)
                    }
                } else {
                    transaction.value = 0
                }
                
                if selectedTag?.title != nil {
                    transaction.tagName = selectedTag?.title
                } else {
                    if getting {
                        transaction.tagName = "دریافت"
                    } else {
                        transaction.tagName = "بدون برچسب"
                    }
                }
                transaction.date = NSDate()
                context.insert(transaction)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
