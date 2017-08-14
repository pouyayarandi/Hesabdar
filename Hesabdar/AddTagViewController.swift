//
//  AddTagViewController.swift
//  Hesabdar
//
//  Created by Pouya on 8/14/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {
    
    var color: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigs()
        chooseStack.transform = CGAffineTransform(translationX: 0, y: 250)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var chooseStack: UIStackView!
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var colorView: UIView!

    @IBAction func chooseColor(_ sender: Any) {
        goUp()
    }
    @IBAction func close(_ sender: Any) {
        goDown()
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func viewConfigs() {
        navigationItem.title = "ثبت برچسب"
        let saveButton = UIBarButtonItem(title: "ذخیره", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func save() {
        if let title = titleField.text, title != "", color != nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Tag", in: context)
            let tag = Tag(entity: entity!, insertInto: context)
            
            tag.title = title
            tag.setColor(color: color!)
            
            context.insert(tag)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Control choose view
    
    func goUp() {
        self.titleField.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.chooseStack.transform = CGAffineTransform.identity
        }
    }
    func goDown() {
        UIView.animate(withDuration: 0.5, animations: {
            self.chooseStack.transform = CGAffineTransform(translationX: 0, y: 250)
        })
    }
    
    // MARK: - Color pallett
    
    func setColor(color: UIColor) {
        self.color = color
        colorView.backgroundColor = color
        goDown()
    }
    
    @IBAction func palletRed(_sender: Any) {
        setColor(color: UIColor.red)
    }
    @IBAction func palletOrange(_sender: Any) {
        setColor(color: UIColor.orange)
    }
    @IBAction func palletYellow(_sender: Any) {
        setColor(color: UIColor.yellow)
    }
    @IBAction func palletGreen(_sender: Any) {
        setColor(color: UIColor.green)
    }
    @IBAction func palletBlue(_sender: Any) {
        setColor(color: UIColor.blue)
    }
    @IBAction func palletCyan(_sender: Any) {
        setColor(color: UIColor.cyan)
    }
    @IBAction func palletPurple(_sender: Any) {
        setColor(color: UIColor.purple)
    }
    @IBAction func palletMagneta(_sender: Any) {
        setColor(color: UIColor.magenta)
    }
    @IBAction func palletBrown(_sender: Any) {
        setColor(color: UIColor.brown)
    }
    @IBAction func palletBlack(_sender: Any) {
        setColor(color: UIColor.black)
    }
}
