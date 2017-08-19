//
//  TransactionDetailViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/15/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class TransactionDetailViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let model = Model()
    var tags = [Tag]()
    var accounts = [Account]()
    var transaction: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAndFetchTags()
        setAndFetchAccounts()
        
        viewConfigs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(transaction: Transaction) {
        self.init(nibName: "TransactionDetailViewController", bundle: nil)
        self.transaction = transaction
    }
    
    // MARK: - Fetch data
    
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
    
    func viewConfigs() {
        titleLabel.text = transaction?.title
        valueLabel.text = model.format().string(from: (transaction?.value as NSNumber?)!)
        accountLabel.text = getAccountName(withID: (transaction?.accID)!)
        tagLabel.text = transaction?.tagName
        tagLabel.textColor = getColor(ofTag: (transaction?.tagName)!)
        
        let date = transaction?.date! as Date?
        let cal = Calendar(identifier: .persian)
        let day = cal.component(.day, from: date!)
        let month = cal.component(.month, from: date!)
        let year = cal.component(.year, from: date!)
        let hour = cal.component(.hour, from: date!)
        let min = cal.component(.minute, from: date!)
        
        dateLabel.text = String(year) + "/" + String(month) + "/" + String(day)
        timeLabel.text = String(hour) + ":" + String(min)
    }
}
