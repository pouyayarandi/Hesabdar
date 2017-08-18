//
//  TransactionTableViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController, UITextFieldDelegate {
    
    var transactions = [Transaction]()
    var searchResult = [Transaction]()
    var tags = [Tag]()
    var accounts = [Account]()
    let color = Color()
    
    @IBOutlet weak var searchField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchField.delegate = self
        
        viewConfigs()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAndFetchTags()
        setAndFetchTransactions()
        setAndFetchAccounts()
        tableView.reloadData()
        
        if transactions.isEmpty {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Fetch data
    
    func setAndFetchTransactions() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        do {
            let result = try context.fetch(fetchRequest)
            transactions = result as! [Transaction]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func setAndFetchTags() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        
        do {
            let result = try context.fetch(fetchRequest)
            tags = result as! [Tag]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func setAndFetchAccounts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        do {
            let result = try context.fetch(fetchRequest)
            accounts = result as! [Account]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func getColor(ofTag: String) -> UIColor {
        for tag in tags {
            if tag.title == ofTag {
                return tag.getColor()
            }
        }
        return UIColor.clear
    }
    
    func getAccountName(withID: String) -> String {
        for account in accounts {
            if account.accID == withID {
                return account.title!
            }
        }
        return "ناشناس"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionTableViewCell", owner: self, options: nil)?.first as! TransactionTableViewCell
        
        let transaction = transactions[indexPath.row]
        cell.configureCell(transaction: transaction)
        
        var tagColor = UIColor.gray
        if transaction.tagName != "بدون برچسب", transaction.tagName != "دریافت" {
            tagColor = getColor(ofTag: transaction.tagName!)
        }
        let accTitle = getAccountName(withID: transaction.accID!)
        
        cell.tagLabel.textColor = tagColor
        
        if transaction.tagName == "دریافت" {
            cell.accountLabel.text = "به حساب " + accTitle
        } else {
            cell.accountLabel.text = "از حساب " + accTitle
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(transactions[indexPath.row] as NSManagedObject)
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            var getting = false
            if transactions[indexPath.row].tagName == "دریافت" {
                getting = true
            }
            let transaction = transactions[indexPath.row]
            let edit = AddTransactionViewController(transaction: transaction, edit: true, getting: getting, index: indexPath.row)
            self.navigationController?.pushViewController(edit, animated: true)
        } else {
            let detail = TransactionDetailViewController(transaction: transactions[indexPath.row])
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }

    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "تراکنش ها"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        tableView.contentInset.bottom = 30
        
        let addButton = UIBarButtonItem(image: UIImage(named: "giving"), style: .plain, target: self, action: #selector(goToAdd))
        navigationItem.rightBarButtonItem = addButton
        
        let addGettingButton = UIBarButtonItem(image: UIImage(named: "getting"), style: .plain, target: self, action: #selector(goToAddGetting))
        navigationItem.rightBarButtonItems?.append(addGettingButton)
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    func goToAdd() {
        let add = AddTransactionViewController(nibName: "AddTransactionViewController", bundle: nil)
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    func goToAddGetting() {
        let add = AddTransactionViewController(getting: true)
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    // MARK: - Textfield delegate
    
    func textFieldDidChange() {
        if searchField.text != "" {
            search(withKey: searchField.text!)
        } else {
            setAndFetchTransactions()
            tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func search(withKey: String) {
        setAndFetchTransactions()
        searchResult.removeAll()
        
        for transaction in transactions {
            if (transaction.title?.contains(withKey))! {
                searchResult.append(transaction)
            }
        }
        
        transactions.removeAll()
        transactions = searchResult
        tableView.reloadData()
    }
}
