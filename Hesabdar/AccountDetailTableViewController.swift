//
//  AccountDetailTableViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/15/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AccountDetailTableViewController: UITableViewController {
    
    var transactions = [Transaction]()
    var results = [Transaction]()
    var accounts = [Account]()
    var tags = [Tag]()
    var account: Account?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionCell")
        tableView.allowsSelection = false
        
        setAndFetchTransactions()
        setAndFetchTags()
        setAndFetchAccounts()
        getResults()
        titleLabel.text = "حساب " + (account?.title)!
        idLabel.text = account?.accID
        countLabel.text = String(results.count) + " تراکنش"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var countLabel : UILabel!
    
    // MARK: - Init
    
    convenience init(account: Account) {
        self.init(nibName: "AccountDetailTableViewController", bundle: nil)
        self.account = account
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
    
    func getResults() {
        for transaction in transactions {
            if transaction.accID == account?.accID {
                results.append(transaction)
            }
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
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TransactionTableViewCell", owner: self, options: nil)?.first as! TransactionTableViewCell

        let transaction = results[indexPath.row]
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
