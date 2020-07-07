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
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
    class Item: Codable{
        var subject : String = ""
        var description : String = ""
        var timeLimit : Date = Date()
        var notifiEnable : Bool = false
        var notification : String = ""
        var notiUdid : String = ""
    }
    
    var taskSaver = UserDefaults.standard
    var taskKey: String = "taskList2"
    
    var itemArray: [Item] = []
    
    var selectedNum: Int = 0
    var notificationEnabled: Int = 0
    
    var notificationTime = DateComponents()
    
    let pickerMinuteInterval: Int = 1
    
    let notifiList: KeyValuePairs = ["00-noUse":"設定しない","01-5min":"提出期限の5分前","02-10min":"提出期限の10分前","03-15min":"提出期限の15分前","04-30min":"提出期限の30分前","05-1hour":"提出期限の1時間前","06-3hour":"提出期限の3時間前","07-6hour":"提出期限の6時間前","08-12hour":"提出期限の12時間前","09-24hour":"提出期限の前日"]
    var notifiListValue: [String] = []
    var notifiListDictionary: [String:String] = [:]
    
    let pickerView: UIPickerView = UIPickerView()
    let optionList: [String] = ["(並べ替え)"]
    let sortType: [String] = ["科目名の昇順","科目名の降順","提出期限が早い順","提出期限が遅い順","カスタム"]
    var sortingItemEnabled: Bool = true
    
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
        
        for (key, value) in notifiList {
            notifiListDictionary[key] = value
        }
        
        anyActionEvent()
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
        if sortingItemEnabled == false {
            anyActionEvent()
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        anyActionEvent()
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
    
    func getNotifiList() -> [String]{
        if notifiListValue.count >= 1 {
            return notifiListValue
        }
        for data in notifiList {
            notifiListValue.append(data.value)
        }
        return notifiListValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count+optionList.count-(sortingItemEnabled==false ? 1 : 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if indexPath.row < itemArray.count {
            let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.subject+": "+item.description
            return cell
        }else{
            cell.textLabel?.text = optionList[indexPath.row - itemArray.count]
            return cell
        }
    }
    
    func notificationCheck(){
        if notificationEnabled == 1 {
            
        }else{
            requestAuthorization()
        }
        return
    }
    func registerNotification(date: Date, timing: String, subject: String, identifier: String){
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
        //print(modifiedDate)
        //print(identifier)
        //ここから通知の登録
        let trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        let center = UNUserNotificationCenter.current()

        // トリガー設定
        notificationTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate)
        var now = Date()
        now = Calendar.current.date(byAdding: .second, value: 1, to: now)!
        let nowCom = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        //notificationTime.hour = 12
        //notificationTime.minute = 0
        if Date() > modifiedDate {
            notificationTime = nowCom
            print("now")
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }else{
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        }
        
        // 通知内容の設定
        content.title = subject
        content.body = "提出期限が近い課題があります。"
        content.sound = UNNotificationSound.default

        // 通知スタイルを指定
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        // 通知をセット
        center.add(request) { (error) in
                   if let error = error {
                       print(error.localizedDescription)
                   }
               }
        center.delegate = self
        
        /*
        center.getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }*/
    }
    
    func appendTask(subject:String, description:String, timeLimit:Date, notification:String){
        
        getTaskItems()
        
        let newItem: Item = Item()
        newItem.subject = subject
        newItem.description = description
        newItem.timeLimit = timeLimit
        newItem.notification = notification
        
        var udid: Int = -1
        if notification == notifiListDictionary["00-noUse"] {
            newItem.notiUdid = ""
        }else{
            udid = Int.random(in: 1 ..< 1000000007)
            newItem.notiUdid = String(udid)
        }
        
        self.itemArray.append(newItem)
        
        notificationCheck()
        if udid >= 0 {
            registerNotification(date: timeLimit,timing: notification,subject: subject,identifier: String(udid))
        }
        
        saveTaskItems()

        self.tableView.reloadData()
    }
    func updateTask(id:Int, subject:String, description:String, timeLimit:Date, notification:String){
        
        getTaskItems()
        
        let newItem: Item = Item()
        newItem.subject = subject
        newItem.description = description
        newItem.timeLimit = timeLimit
        newItem.notification = notification
        
        var udid: Int = -1
        if notification == notifiListDictionary["00-noUse"] {
            newItem.notiUdid = ""
            if itemArray[id].notiUdid != "" {
                removeNotification(identifier: itemArray[id].notiUdid)
            }
        }else{
            if itemArray[id].notiUdid == "" {
                udid = Int.random(in: 1 ..< 1000000007)
            }else{
                udid = Int(itemArray[id].notiUdid)!
            }
            newItem.notiUdid = String(udid)
        }
        
        itemArray[id] = newItem

        notificationCheck()
        if udid >= 1 {
            registerNotification(date: timeLimit,timing: notification,subject: subject,identifier: String(udid))
        }

        saveTaskItems()

        self.tableView.reloadData()
    }
    func removeTask(id: Int){
        getTaskItems()
        
        if itemArray[id].notiUdid != "" {
            removeNotification(identifier: itemArray[id].notiUdid)
        }
        itemArray.remove(at:id)
        
        saveTaskItems()
    }
    func insertTask(item: Item, at: Int){
        getTaskItems()
        
        itemArray.insert(item, at: at)
        
        saveTaskItems()
    }
    
    func removeNotification(identifier: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row < itemArray.count {
            return true
        }
        return false
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            getTaskItems()
        
            removeTask(id: indexPath.row)
            //itemArray.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        
            saveTaskItems()
        }
    }
    func optionItemEvent(id: Int){
        var taskId: Int = id
        if taskId>=0 && sortingItemEnabled==false {
            taskId = taskId - 1
        }
        switch id {
        case 0:
            anyActionEvent()
            viewSortingAlert()
            break
        default:
            break
        }
    }
    func viewSortingAlert(){
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "リストの並べ替え", message: "リストの並べ替え方法を選択してください。", preferredStyle:  UIAlertController.Style.actionSheet)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        /*
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
         */
        
        var actions: [UIAlertAction] = []
        var i: Int = 0
        sortType.forEach {
            let defaultAction: UIAlertAction = UIAlertAction(title: $0, style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.executeSort(type: action.title!)
            })
            actions.append(defaultAction)
            i += 1
        }
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        actions.forEach {
            alert.addAction($0)
        }
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
    }//https://qiita.com/funacchi/items/b76e62eb82fc8d788da5#表示スタイルactionsheet
    
    func executeSort(type: String){
        getTaskItems()
        switch type {
        case sortType[0]:
            //科目名昇順
            itemArray.sort{ $0.subject < $1.subject }
            break
        case sortType[1]:
            //科目名降順
            itemArray.sort{ $0.subject > $1.subject }
            break
        case sortType[2]:
            //提出期限昇順
            itemArray.sort{ $0.timeLimit < $1.timeLimit }
            break
        case sortType[3]:
            //提出期限降順
            itemArray.sort{ $0.timeLimit > $1.timeLimit }
            break
        default:
            //カスタム編集の許可
            setCustomSorting(enabled: true)
            break
        }
        saveTaskItems()
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        anyActionEvent()
        if indexPath.row < itemArray.count {
            selectedNum = indexPath.row
            //print(selectedNum)
            //if(selectedNum != nil){
                performSegue(withIdentifier: "toEditController", sender: nil)
            //}
        }else{
            optionItemEvent(id: indexPath.row-itemArray.count)
        }
        tableView.deselectRow(at: indexPath, animated: true)

        //ここに遷移処理を書く
        //self.present(EditTaskController(), animated: true, completion: nil)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        getTaskItems()
        
        let targetItem = itemArray[fromIndexPath.row]
        itemArray.remove(at: fromIndexPath.row)
        itemArray.insert(targetItem, at: to.row)
        
        saveTaskItems()
    }

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
        anyActionEvent()
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
    
    func anyActionEvent(){
        //任意のアクションの実行時
        setCustomSorting(enabled: false)
        self.tableView.reloadData()
    }
    func setCustomSorting(enabled: Bool){
        tableView.isEditing = enabled
        tableView.allowsSelectionDuringEditing = enabled
        sortingItemEnabled = !enabled
        if enabled == true{
            goBackMemo.title = "完了"
        }else{
            goBackMemo.title = "戻る"
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      // ここで処理を行う
        completionHandler([.badge, .alert, .sound])
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        switch item.tag {
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    func getMinuteInterval() -> Int {
        return pickerMinuteInterval
    }
    func isNotificationEnable() -> Bool {
        return notificationEnabled != 0
    }
}
