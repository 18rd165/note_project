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
    @IBOutlet weak var taskTimeLimit: UITextField!
    @IBOutlet weak var notification: UITextField!
    
    var formatter = DateFormatter()
    var datePicker: UIDatePicker = UIDatePicker()
    
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

        // Do any additional setup after loading the view.
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale(identifier: "ja_JP")
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

    }
    @objc func done() {
        taskTimeLimit.endEditing(true)

        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        
        taskTimeLimit.text = "\(formatter.string(from: datePicker.date))"

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
            // 戻るviewControllerがないとき(navigationController上で一番最初の画面のとき)
            let myClass = TaskTableViewController()
                myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit:Date(),notification:Date())

        }
        if let previousViewController = self.navigationController?.viewControllers[count] as? TaskTableViewController {
            // viewControlllerAの処理
            let myClass = previousViewController
                myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit:Date(),notification:Date())

            
        } else {
            // それ以外のviewControllerの処理
            let myClass = TaskTableViewController()
                myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit:Date(),notification:Date())

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
