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
import Charts

struct TagWithValue {
    var tag: Tag
    var value: Float
}

class HomeViewController: UIViewController {
    
    let model = Model()
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
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var circularProgress: KDCircularProgress!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var givingLabel: UILabel!
    @IBOutlet weak var gettingLabel: UILabel!
    @IBOutlet weak var givingMonthLabel: UILabel!
    @IBOutlet weak var gettingMonthLabel: UILabel!
    
    // last transaction
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Charts
    
    func setDataCount() {
        setAndFetchTags()
        setTagsWithValue()
        var values = [PieChartDataEntry]()
        for tag in tagsWithValue {
            values.append(PieChartDataEntry(value: Double(tag.value), label: tag.tag.title))
        }
        let dataSet = PieChartDataSet(values: values, label: "")
        dataSet.sliceSpace = 2
        dataSet.colors.removeAll()
        for tag in tagsWithValue {
            dataSet.colors.append(tag.tag.getColor() as NSUIColor)
        }
        let percent = NumberFormatter()
        percent.numberStyle = .percent
        percent.maximumFractionDigits = 1
        percent.minusSign = ""
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DefaultValueFormatter(formatter: percent))
        pieChart.data = data
        pieChart.animate(xAxisDuration: 0.5)
    }
    
    // MARK: - Config view
    
    func viewConfigs() {
        navigationItem.title = "خانه"
        self.navigationController?.navigationBar.barTintColor = model.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        let tagBtn = UIBarButtonItem(image: UIImage(named: "tag"), style: .plain, target: self, action: #selector(openTags))
        navigationItem.leftBarButtonItem = tagBtn
        
        pieChart.legend.form = .circle
        pieChart.legend.xEntrySpace = 20
        pieChart.legend.font = UIFont(name: "IRANSans(FaNum)", size: 10)!
        pieChart.chartDescription?.text = ""
        pieChart.drawEntryLabelsEnabled = false
        pieChart.usePercentValuesEnabled = false
    }
    
    func openTags() {
        let tagView = TagTableViewController(nibName: "TagTableViewController", bundle: nil)
        self.navigationController?.pushViewController(tagView, animated: true)
    }
    
    func setValuesBefore() {
        setAndFetchTags()
        setAndFetchAccounts()
        setAndFetchTransactions()
        setLastTransaction()
        
        circularProgress.angle = 0
        budgetLabel.text = model.format().string(from: getSum() as NSNumber)
        givingLabel.text = model.format().string(from: getSumGivings() as NSNumber)
        gettingLabel.text = model.format().string(from: getSumGettings() as NSNumber)
        givingMonthLabel.text = model.format().string(from: getGivingsOfMonth() as NSNumber)
        gettingMonthLabel.text = model.format().string(from: getGettingsOfMonth() as NSNumber)
    }
    
    func setValuesAfter() {
        var angle = 0
        if getSumGettings() != 0 {
            angle = Int(Double(Double(getSumGivings())/Double(getSumGettings())) * 360)
        }
        circularProgress.animate(toAngle: Double(angle), duration: 0.5, completion: nil)
        setDataCount()
    }
    
    func setLastTransaction() {
        if !transactions.isEmpty {
            let transaction = transactions.last
            noDataLabel.alpha = 0
            titleLabel.alpha = 1
            valueLabel.alpha = 1
            tagLabel.alpha = 1
            accountLabel.alpha = 1
            
            titleLabel.text = transaction?.title
            tagLabel.text = transaction?.tagName
            valueLabel.text = model.format().string(from: (transaction?.value as NSNumber?)!)
            
            var tagColor = UIColor.gray
            if transaction?.tagName != "بدون برچسب", transaction?.tagName != "دریافت" {
                tagColor = getColor(ofTag: (transaction?.tagName!)!)
            }
            let accTitle = getAccountName(withID: (transaction?.accID!)!)
            
            tagLabel.textColor = tagColor
            
            if transaction?.tagName == "دریافت" {
                accountLabel.text = "به حساب " + accTitle
            } else {
                accountLabel.text = "از حساب " + accTitle
            }
        } else {
            noDataLabel.alpha = 1
            titleLabel.alpha = 0
            valueLabel.alpha = 0
            tagLabel.alpha = 0
            accountLabel.alpha = 0
        }
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
            return -(sum/givings)
        } else {
            return 0
        }
    }
    
    func setTagsWithValue() {
        var tagsWithVal = [TagWithValue]()
        for tag in tags {
            let val = getWithTag(title: tag.title!)
            let tagWithVal = TagWithValue(tag: tag, value: val)
            tagsWithVal.append(tagWithVal)
        }
        tagsWithValue = tagsWithVal
    }
}
