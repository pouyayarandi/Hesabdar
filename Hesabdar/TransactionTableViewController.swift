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
        var tagColor = UIColor.gray
        if transaction.tagName != "بدون برچسب" {
            tagColor = getColor(ofTag: transaction.tagName!)
        }
        let accTitle = getAccountName(withID: transaction.accID!)
        
        cell.configureCell(transaction: transaction)
        cell.tagLabel.textColor = tagColor
        cell.accountLabel.text = "از/به حساب " + accTitle
        
        return cell
    }

    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "تراکنش ها"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func goToAdd() {
        let add = AddTransactionViewController(nibName: "AddTransactionViewController", bundle: nil)
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
