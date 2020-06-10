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
    @IBOutlet weak var taskTimeLimit: UIButton!
    @IBOutlet weak var notification: UIButton!
    @IBOutlet weak var taskRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        }else if(taskDescription.text! == ""){
            alert(title: "課題登録エラー",message: "課題内容が入力されていません")
        }
        
        let myClass = TaskTableViewController()
            myClass.appendTask(subject:subjectTitle.text ?? "", description:taskDescription.text,timeLimit:Date(),notification:Date())
        
        alert(title: "課題登録成功!", message: "課題登録が完了しました。")
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ButtonTouchDown(_ sender: Any) {
        registerButton()
    }
    @IBAction func ButtonTimeLimit(_ sender: Any) {
        
    }
    @IBAction func ButtonNotification(_ sender: Any) {
        
    }
}
