//
//  TransactionTableViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class TransactionTableViewController: UITableViewController {
    
    var transactions = [Transaction]()
    var tags = [Tag]()
    let color = Color()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigs()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAndFetchTags()
        setAndFetchTransactions()
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
    
    func getColor(ofTag: String) -> UIColor {
        for tag in tags {
            if tag.title == ofTag {
                return tag.getColor()
            }
        }
        return UIColor.clear
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
        let tagColor = getColor(ofTag: transaction.tagName!)
        
        cell.configureCell(transaction: transaction)
        cell.tagLabel.textColor = tagColor
        
        return cell
    }

    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "تراکنش ها"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
