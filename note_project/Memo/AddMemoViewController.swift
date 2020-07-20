//
//  AddMemoViewController.swift
//  note_project
//
//  Created by rui on 2020/06/03.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class AddMemoViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var subjectText: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        let inputText = memoTextView.text
        let inputLabel = subjectText.text
        let ud = UserDefaults.standard
        let inputArray:[String] = [inputLabel!, inputText!]
        
        if ud.array(forKey: "memoArray") != nil{
            //saveMemoArrayに取得
            var saveMemoArray = ud.array(forKey: "memoArray") as! [[String]]
                //テキストに何か書かれているか？
            if inputLabel != ""{
                if inputText != ""{
                    saveMemoArray.append(inputArray)
                    memoTextView.text = ""
                    subjectText.text = ""
                    ud.set(saveMemoArray, forKey: "memoArray")
                }
                else {
                    showAlert(title: "ノートに何も入力されていません")
                }
                
            }else{
                showAlert(title: "教科名に何も入力されていません")

            }

        }else{
            //最初、何も書かれていない場合
            var newMemoArray = [[String]]()
            //nilを強制アンラップはエラーが出るから
            if inputLabel != ""{
                newMemoArray.append(inputArray)
                memoTextView.text = ""
                subjectText.text = ""
                ud.set(newMemoArray, forKey: "memoArray")
                if inputText != ""{
                    newMemoArray.append(inputArray)
                    
                }
                else {
                    showAlert(title: "ノートに何も入力されていません")
                }
                
            }else{
                showAlert(title: "教科名に何も入力されていません")
            }
        }
        showAlert(title: "保存完了")
        ud.synchronize()
    }
    
    func showAlert(title:String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion:nil)
    }
    
}
