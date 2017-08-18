//
//  AccountTableViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AccountTableViewController: UITableViewController {
    
    var onChooseWindow = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var accounts = [Account]()
    let color = Color()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigs()
        
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AccountCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAndFetchAccounts()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    convenience init(choosable: Bool) {
        self.init(nibName: "AccountTableViewController", bundle: nil)
        onChooseWindow = choosable
    }
    
    // MARK: - Fetch data
    
    func setAndFetchAccounts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        
        do {
            let result = try context.fetch(fetchRequest)
            accounts = result as! [Account]
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AccountTableViewCell", owner: self, options: nil)?.first as! AccountTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        }
        
        let account = accounts[indexPath.row]
        cell.configureCell(account: account)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(accounts[indexPath.row] as NSManagedObject)
            accounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if onChooseWindow {
            let parent = self.parent as! AddTransactionViewController
            let account = accounts[indexPath.row]
            parent.selectedAcc = account
            parent.accountBtn.setTitle(account.title, for: .normal)
            parent.goDown()
        } else {
            let account = accounts[indexPath.row]
            let detail = AccountDetailTableViewController(account: account)
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }

    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "حساب ها"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func goToAdd() {
        let add = AddAccountViewController(nibName: "AddAccountViewController", bundle: nil)
        self.navigationController?.pushViewController(add, animated: true)
    }

}
