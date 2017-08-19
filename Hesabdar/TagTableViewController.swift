//
//  TagTableViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class TagTableViewController: UITableViewController {
    
    var onChooseWindow = false
    var tags = [Tag]()
    let model = Model()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigs()
        
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TagCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setAndFetchTags()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init(choosable: Bool) {
        self.init(nibName: "TagTableViewController", bundle: nil)
        self.onChooseWindow = choosable
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TagTableViewCell", owner: self, options: nil)?.first as! TagTableViewCell

        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        }
        
        let tag = tags[indexPath.row]
        cell.configCell(tag: tag)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(tags[indexPath.row] as NSManagedObject)
            tags.remove(at: indexPath.row)
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
            let tag = tags[indexPath.row]
            parent.selectedTag = tag
            parent.tagBtn.tintColor = tag.getColor()
            parent.tagBtn.setTitle(tag.title, for: .normal)
            parent.goDown()
        }
    }
    
    // MARK: - View configs
    
    func viewConfigs() {
        navigationItem.title = "برچسب ها"
        self.navigationController?.navigationBar.barTintColor = model.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        if !onChooseWindow {
            tableView.allowsSelection = false
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAdd))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func goToAdd() {
        let add = AddTagViewController(nibName: "AddTagViewController", bundle: nil)
        
        self.navigationController?.pushViewController(add, animated: true)
    }

}
