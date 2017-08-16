//
//  HomeViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/16/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData
import KDCircularProgress

struct TagWithValue {
    var tag: Tag
    var value: Float
}

class HomeViewController: UIViewController {
    
    let color = Color()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transactions = [Transaction]()
    var accounts = [Account]()
    var tags = [Tag]()
    
    var tagsWithValue = [TagWithValue]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setValuesBefore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setValuesAfter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var circularProgress: KDCircularProgress!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var givingLabel: UILabel!
    @IBOutlet weak var gettingLabel: UILabel!
    @IBOutlet weak var givingMonthLabel: UILabel!
    @IBOutlet weak var gettingMonthLabel: UILabel!
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Config view
    
    func viewConfigs() {
        navigationItem.title = "خانه"
        self.navigationController?.navigationBar.barTintColor = color.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setValuesBefore() {
        setAndFetchTags()
        setAndFetchAccounts()
        setAndFetchTransactions()
        
        circularProgress.angle = 0
        budgetLabel.text = String(getSum())
        givingLabel.text = String(getSumGivings())
        gettingLabel.text = String(getSumGettings())
        givingMonthLabel.text = String(getGivingsOfMonth())
        gettingMonthLabel.text = String(getGettingsOfMonth())
    }
    
    func setValuesAfter() {
        var angle = 0
        if getSumGettings() != 0 {
            angle = Int(Double(Double(getSumGivings())/Double(getSumGettings())) * 360)
        }
        circularProgress.animate(toAngle: Double(angle), duration: 0.5, completion: nil)
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
    
    func getGivingsOfMonth() -> Int {
        var sum: Float = 0
        let date = Date()
        let cal = Calendar(identifier: .persian)
        for transaction in transactions {
            if transaction.value < 0 {
                let transDate = transaction.date as Date?
                if cal.component(.year, from: transDate!) == cal.component(.year, from: date), cal.component(.month, from: transDate!) == cal.component(.month, from: date) {
                    sum += transaction.value
                }
            }
        }
        return Int(-sum)
    }
    
    func getGettingsOfMonth() -> Int {
        var sum: Float = 0
        let date = Date()
        let cal = Calendar(identifier: .persian)
        for transaction in transactions {
            if transaction.value > 0 {
                let transDate = transaction.date as Date?
                if cal.component(.year, from: transDate!) == cal.component(.year, from: date), cal.component(.month, from: transDate!) == cal.component(.month, from: date) {
                    sum += transaction.value
                }
            }
        }
        return Int(sum)
    }
    
    func getSumGettings() -> Int {
        var sum: Float = 0
        for transaction in transactions {
            if transaction.value > 0 {
                sum += transaction.value
            }
        }
        return Int(sum)
    }
    
    func getSumGivings() -> Int {
        var sum: Float = 0
        for transaction in transactions {
            if transaction.value < 0 {
                sum += transaction.value
            }
        }
        return Int(-sum)
    }
    
    func getSum() -> Int {
        let gettings = getSumGettings()
        let givings = getSumGivings()
        return gettings - givings
    }
    
    func getWithTag(title: String) -> Float {
        var sum: Float = 0
        let givings = Float(getSumGivings())
        for transaction in transactions {
            if transaction.tagName == title {
                sum += transaction.value
            }
        }
        if givings != 0 {
            return sum/givings
        } else {
            return 0
        }
    }
}
