//
//  ViewController.swift
//  realDataBase
//
//  Created by AFFIXUS IMAC1 on 10/17/18.
//  Copyright © 2018 AFFIXUS IMAC1. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btAdd: UIBarButtonItem!
    
    var realm : Realm!
    
    var remindersList: Results<Reminder> {     //we are lazy-calling Reminder objects
        get {
            return try! Realm().objects(Reminder.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        realm = try! Realm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        let item = remindersList[indexPath.row]
        
        cell.lbl.text = item.name        // (5)
        cell.lbl.textColor = item.done == false ? UIColor.black : UIColor.lightGray
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = remindersList[indexPath.row]
        try! self.realm.write({     // (6)
            item.done = !item.done
        })
        
        //refresh rows
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            let item = remindersList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)     // (7)
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        
    }
    
    @IBAction func addNew(_ sender: Any) {
        let alertVC : UIAlertController = UIAlertController(title: "New Reminder", message: "What do you want to remember?", preferredStyle: .alert)
        
        alertVC.addTextField { (UITextField) in
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        
        alertVC.addAction(cancelAction)
        
        //Alert action closure
        let addAction = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let textFieldReminder = (alertVC.textFields?.first)! as UITextField
            
            let reminderItem = Reminder()       // (8)
            reminderItem.name = textFieldReminder.text!
            reminderItem.done = false
            
            // We are adding the reminder to our database
            try! self.realm.write({
                self.realm.add(reminderItem)    // (9)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.remindersList.count-1, section: 0)], with: .automatic)
            })
            
        }
        
        alertVC.addAction(addAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
}

