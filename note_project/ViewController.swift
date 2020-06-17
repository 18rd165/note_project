//
//  ViewController.swift
//  note_project
//
//  Created by rui on 2020/06/01.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UITabBarDelegate {
    
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var searchMemo: UISearchBar!
    @IBOutlet weak var typeTabBar: UITabBar!
    
    var memoArray = [String]()
    var searchResult = [String]()

    let ud = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( searchMemo.text != "" ) {
        return searchResult.count
        } else {
        return memoArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        cell.textLabel?.text = memoArray[indexPath.row]
        if( searchMemo.text != "" ) {
        cell.textLabel?.text = searchResult[indexPath.row]
        } else {
        cell.textLabel?.text = memoArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        //押したら押した状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchMemo.delegate = self
         //何も入力されていなくてもReturnキーを押せるようにする。
        searchMemo.enablesReturnKeyAutomatically = false
        memoTableView.delegate = self
        memoTableView.dataSource = self
        
        typeTabBar.delegate = self
    }
    @objc func tabOnClick(){
        /*
        let nextViewController = TaskNaviController()
        self.present(nextViewController, animated:true, completion:nil)
         */
        let storyboard: UIStoryboard = UIStoryboard(name: "Tasks", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController()!
        present(next, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadMemo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //destinationのクラッシュ防ぐ
        if segue.identifier == "toDetail"{
            //detailViewControllerを取得
            //as! DetailViewControllerでダウンキャストしている
            let detailViewController = segue.destination as! DetailViewController
            //遷移前に選ばれているCellが取得できる
            if(searchMemo.text != "" ){
                let selectedIndexPath = memoTableView.indexPathForSelectedRow!
                detailViewController.selectedMemo = searchResult[selectedIndexPath.row]
                detailViewController.selectedRow = selectedIndexPath.row
            }
            else{
                let selectedIndexPath = memoTableView.indexPathForSelectedRow!
                detailViewController.selectedMemo = memoArray[selectedIndexPath.row]
                detailViewController.selectedRow = selectedIndexPath.row
            }
        }
    }
    func loadMemo(){
        if ud.array(forKey: "memoArray") != nil{
            //取得 またas!でアンラップしているのでnilじゃない時のみ
            memoArray = ud.array(forKey: "memoArray") as![String]
            //reloadしてくれる
            memoTableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

                if editingStyle == .delete {

                    //resultArray内のindexPathのrow番目をremove（消去）する
                    memoArray.remove(at: indexPath.row)

                    //再びアプリ内に消去した配列を保存
                    ud.set(memoArray, forKey: "memoArray")

                    //tableViewを更新
                    tableView.reloadData()
                }
            }
    }
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMemo.endEditing(true)
         
        //検索文字列を含むデータを検索結果配列に格納する。
        searchResult = memoArray.filter { data in
        return data.contains(searchMemo.text!)
        }
         
        //テーブルを再読み込みする。
        memoTableView.reloadData()
        
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        switch item.tag {
        case 2:
            //Homework
            tabOnClick()
            break
        default:
            return
        }
    }
}
