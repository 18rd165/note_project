//
//  TaskTableViewController.swift
//  note_project
//
//  Created by NobuyaNakanishi on 2020/06/10.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit
import UserNotifications

class TaskTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var taskTable: UITableView!
    @IBOutlet weak var goBackMemo: UIBarButtonItem!
    
    class Item: Codable{
        var subject : String = ""
        var description : String = ""
        var timeLimit : Date = Date()
        var notifiEnable : Bool = false
        var notification : String = ""
    }
    
    var taskSaver = UserDefaults.standard
    var taskKey: String = "taskList"
    
    var itemArray: [Item] = []
    
    var selectedNum: Int = 0
    var notificationEnabled: Int = 0
    
    var notificationTime = DateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //saveItems(items: itemArray)
        itemArray = readItems()!
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in

            switch settings.authorizationStatus {
            case .authorized:
                self.notificationEnabled = 1
                break
            case .denied:
                break
            case .notDetermined:
                break
            case .provisional:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func requestAuthorization() {
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }

                if granted {
                    print("通知許可")

                    let center = UNUserNotificationCenter.current()
                    center.delegate = self

                } else {
                    print("通知拒否")
                }
            })

        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
    }//https://qiita.com/yamataku29/items/f45e77de3026d4c50016
    
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
    
    func notificationCheck(){
        if notificationEnabled == 1 {
            
        }else{
            requestAuthorization()
        }
        return
    }
    func registerNotification(date: Date, timing: String){
        var modifiedDate: Date = Date()
        if timing == "設定しない"{
            return
        }else if timing.contains("の5分") {
            modifiedDate = Calendar.current.date(byAdding: .minute, value: -5, to: date)!
        }else if timing.contains("の10分") {
            modifiedDate = Calendar.current.date(byAdding: .minute, value: -10, to: date)!
        }else if timing.contains("の15分") {
            modifiedDate = Calendar.current.date(byAdding: .minute, value: -15, to: date)!
        }else if timing.contains("の30分") {
            modifiedDate = Calendar.current.date(byAdding: .minute, value: -30, to: date)!
        }else if timing.contains("の1時間") {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: date)!
        }else if timing.contains("の3時間") {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: -3, to: date)!
        }else if timing.contains("の6時間") {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: -6, to: date)!
        }else if timing.contains("の12時間") {
            modifiedDate = Calendar.current.date(byAdding: .hour, value: -12, to: date)!
        }else if timing.contains("の前日") {
            modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }else{
            return
        }
        print(modifiedDate)

        
    }
    
    func appendTask(subject:String, description:String,timeLimit:Date,notification:String){
        
        getTaskItems()
        
        let newItem: Item = Item()
        newItem.subject = subject
        newItem.description = description
        newItem.timeLimit = timeLimit
        newItem.notification = notification
        self.itemArray.append(newItem)
        
        notificationCheck()
        registerNotification(date:timeLimit,timing:notification)
        
        saveTaskItems()

        self.tableView.reloadData()
    }
    func updateTask(id:Int,subject:String, description:String,timeLimit:Date,notification:String){
        
        getTaskItems()
        
        let newItem: Item = Item()
        newItem.subject = subject
        newItem.description = description
        newItem.timeLimit = timeLimit
        newItem.notification = notification
        itemArray[id] = newItem
        
        notificationCheck()
        registerNotification(date:timeLimit,timing:notification)

        saveTaskItems()

        self.tableView.reloadData()
    }
    func removeTask(id: Int){
        getTaskItems()
        
        itemArray.remove(at:id)
        
        saveTaskItems()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        selectedNum = indexPath.row
        //print(selectedNum)
        if(selectedNum != nil){
            performSegue(withIdentifier: "toEditController", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)

        //ここに遷移処理を書く
        //self.present(EditTaskController(), animated: true, completion: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEditController" {
            let subVC: EditTaskController = (segue.destination as? EditTaskController)!
            subVC.selectedNum = selectedNum
            print("status:\(selectedNum)")
            subVC.selectedSubject = itemArray[selectedNum].subject
            subVC.selectedDescription = itemArray[selectedNum].description
            subVC.selectedTimeLimit = itemArray[selectedNum].timeLimit
            subVC.selectedNotification = itemArray[selectedNum].notification
        }
    }
    

}
