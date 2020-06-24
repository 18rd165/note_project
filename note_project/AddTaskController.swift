//
//  AddTaskController.swift
//  note_project
//
//  Created by NobuyaNakanishi on 2020/06/10.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class AddTaskController: UIViewController {
    @IBOutlet weak var subjectTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var taskRegister: UIButton!
    @IBOutlet weak var taskTimeLimit: UITextView!
    @IBOutlet weak var notification: UITextView!
    
    var formatter = DateFormatter()
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIPickerView = UIPickerView()
    
    var notifiList: [String] = []
    
    class DateUtils {
        class func dateFromString(string: String, format: String) -> Date {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.date(from: string)!
        }

        class func stringFromDate(date: Date, format: String) -> String {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
    //https://qiita.com/k-yamada-github/items/8b6411959579fd6cd995
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTimeLimit.isEditable = false
        notification.isEditable = false
        
        // Do any additional setup after loading the view.
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.minuteInterval = TaskTableViewController().getMinuteInterval()
        taskTimeLimit.inputView = datePicker

        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)

        // インプットビュー設定(紐づいているUITextfieldへ代入)
        taskTimeLimit.inputView = datePicker
        taskTimeLimit.inputAccessoryView = toolbar
        
        //https://qiita.com/ryomaDsakamoto/items/ab4ae031706a8133f193
        
        formatter.dateFormat = "yyyy-MM-dd"

        let day = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: day)!
        datePicker.date = formatter.date(from: formatter.string(from: modifiedDate))!
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        taskTimeLimit.text = formatter.string(from: modifiedDate)+" 0:00";
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if #available(iOS 7.0,*){
            
        }else{
            pickerView.showsSelectionIndicator = true
        }

        // 決定バーの生成
        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        toolbar2.setItems([spacelItem2, doneItem2], animated: true)
         
        // インプットビュー設定
        notification.inputView = pickerView
        notification.inputAccessoryView = toolbar2
        
        //通知タイミングリストの取得
        notifiList = TaskTableViewController().getNotifiList()
    }
    @objc func done() {
        taskTimeLimit.endEditing(true)

        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        
        taskTimeLimit.text = "\(formatter.string(from: datePicker.date))"

    }
    @objc func done2(){
        notification.endEditing(true)
        
        //notification.text = ""
    }

    @IBAction func TodoRegisterButton(_ sender: Any){
        
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func alert(title:String, message:String) {
        let alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }

    @objc func registerButton(){
        if(subjectTitle.text! == ""){
            alert(title: "課題登録エラー",message: "科目名が入力されていません")
            return
        }else if(taskDescription.text! == ""){
            alert(title: "課題登録エラー",message: "課題内容が入力されていません")
            return
        }
        
        let count = (self.navigationController?.viewControllers.count)! - 2
        if count < 0 {
            //戻るviewControllerがないとき(navigationController上で一番最初の画面のとき)
            let myClass = TaskTableViewController()
            myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit: datePicker.date,notification:notification.text)
        }
        if let previousViewController = self.navigationController?.viewControllers[count] as? TaskTableViewController {
            // viewControlllerAの処理
            let myClass = previousViewController
                myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit: datePicker.date,notification:notification.text)
        } else {
            // それ以外のviewControllerの処理
            let myClass = TaskTableViewController()
                myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit: datePicker.date,notification:notification.text)
        }
        
        alert(title: "課題登録成功!", message: "課題登録が完了しました。")
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ButtonTouchDown(_ sender: Any) {
        registerButton()
    }
    @IBAction func ButtonTimeLimit(_ sender: Any) {
        
    }
    @IBAction func ButtonNotification(_ sender: Any) {
        
    }
}
extension AddTaskController : UIPickerViewDelegate, UIPickerViewDataSource {
 
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*
         列が複数ある場合は
         if component == 0 {
         } else {
         ...
         }
         こんな感じで分岐が可能
         */
        return notifiList.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*
         列が複数ある場合は
         if component == 0 {
         } else {
         ...
         }
         こんな感じで分岐が可能
         */
        return notifiList[row]
    }
    
    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.notification.text = notifiList[row]
    }
    
}//https://www.egao-inc.co.jp/programming/swift_uipickerview/
