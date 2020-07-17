//
//  DetailViewController.swift
//  note_project
//
//  Created by rui on 2020/06/03.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // ----------------------  Side buttom  --------------------------
    @IBOutlet weak var rightContainerView: UIView! {
        didSet {
            guard let viewController = UIStoryboard(name: "SideBar", bundle: nil).instantiateInitialViewController() else { return }
            rightContainerView.frame = rightContainerViewInitFrame
            rightContainerView.addSubview(viewController.view)
        }
    }
    
    private let rightContainerViewInitFrame = CGRect(x: UIScreen.main.bounds.width, y: 0,
    width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    private let containerViewDispFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if let view = touch.view {
                transitionSlideViewController(tag: view.tag)
            }
        }
    }
    
    func transitionSlideViewController(tag: Int) {
        UIView.animate(withDuration: 0.3, animations: {
            self.rightContainerView.frame = self.rightContainerViewInitFrame
        })
    }
    
    
    @IBAction func slideButtom(_ sender: Any) {
        rightContainerView.frame = rightContainerViewInitFrame
        UIView.animate(withDuration: 0.3, animations: {
            self.rightContainerView.frame = self.containerViewDispFrame
        })
    }
    
   // -----------------------------------------------------------------------------
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var pages: UILabel!
    
    
    var displayRow:Int!
    var displayMemo : String!
    var Row:Int!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoTextView.text = displayMemo
        pages.text = "- \(displayRow+1) -"
    }
    
    
    @IBAction func overWrite(_ sender: Any) {
        if ud.array(forKey: "memoArray") != nil{
            print(Row!, displayRow!)
            var saveMemoArray = ud.array(forKey: "memoArray") as! [[String]]
            saveMemoArray[Row].remove(at: displayRow + 1)
            saveMemoArray[Row].insert(memoTextView.text, at: displayRow + 1)
            ud.set(saveMemoArray, forKey: "memoArray" )
            ud.synchronize()
            //画面遷移

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        if ud.array(forKey: "memoArray") != nil{
            var saveMemoArray = ud.array(forKey: "memoArray") as! [[String]]
            saveMemoArray[Row].remove(at: displayRow + 1)
            ud.set(saveMemoArray, forKey: "memoArray" )
            ud.synchronize()
            //画面遷移

            self.navigationController?.popViewController(animated: true)
        }
    }
}
