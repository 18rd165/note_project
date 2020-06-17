//
//  TaskTableViewController.swift
//  note_project
//
//  Created by NobuyaNakanishi on 2020/06/10.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {

    @IBOutlet var taskTable: UITableView!
    @IBOutlet weak var goBackMemo: UIBarButtonItem!
    
    class Item: Codable{
        var subject : String = ""
        var description : String = ""
        var timeLimit : Date = Date()
        var notifiEnable : Bool = false
        var notification : Date = Date()
    }
    
    var taskSaver = UserDefaults.standard
    var taskKey: String = "taskList"
    
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        itemArray = readItems()!
    }
    
    func saveItems(items: [Item]) {
        let data = items.map { try! JSONEncoder().encode($0) }
        taskSaver.set(data as [Any], forKey: taskKey)
    }

    func readItems() -> [Item]? {
        guard let items = taskSaver.array(forKey: taskKey) as? [Data] else { return [Item]() }

        let decodedItems = items.map { try! JSONDecoder().decode(Item.self, from: $0) }
        return decodedItems
    }
    
    @IBAction func goBackMemo(_ sender: Any) {
        //self.appendTask(subject: "A", description: "B", timeLimit: d, notification: d)
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    
    func getTaskItems(){
        itemArray = readItems()!
    }
    func saveTaskItems(){
        saveItems(items: itemArray)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.subject+": "+item.description
        return cell
    }
    
    func appendTask(subject:String, description:String,timeLimit:Date,notification:Date){
        
        getTaskItems()
        
        let newItem: Item = Item()
        newItem.subject = subject
        newItem.description = description
        newItem.timeLimit = timeLimit
        newItem.notification = notification
        self.itemArray.append(newItem)
        
        saveTaskItems()

        self.tableView.reloadData()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        getTaskItems()
        
        itemArray.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveTaskItems()
    }
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
