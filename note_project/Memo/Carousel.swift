//
//  Carousel.swift
//  note_project
//
//  Created by rui on 2020/07/11.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

final class Carousel: UICollectionViewController {
    
    var selectedLabel: String!
    var selectedRow:Int!
    var selectedMemo : [String]!
    
    
    var displaySegue: UIStoryboardSegue!
    
    
    private var cellSize: CGSize {
        let width = collectionView.bounds.width * 0.9
        let height = width * Cell.aspectRatio
        return CGSize(width: width, height: height)
    }

    private var headerSize: CGSize {
        let width = collectionView.bounds.width * 0.6
        return CGSize(width: width, height: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.decelerationRate = .fast

        let flowLayout = collectionViewLayout as! FlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = collectionView.bounds.height
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return selectedMemo.count - 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.noteText.text = selectedMemo[indexPath.row + 1]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind _: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headercell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! Cell
        headercell.headerLabel.text = selectedLabel
        return headercell
    }
    
    

    // セルが選択された時の処理を指定する
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("check")
        print(selectedMemo!)
        
        // 上書き
        /*let ud = UserDefaults.standard
        if ud.array(forKey: "memoArray") != nil{
            var saveMemoArray = ud.array(forKey: "memoArray") as! [[String]]
            saveMemoArray.remove(at: selectedRow)
            saveMemoArray.insert(selectedMemo, at: selectedRow)
            ud.set(saveMemoArray, forKey: "memoArray" )
            ud.synchronize()
            
        }*/
        
        if displaySegue.identifier == "toDisplay"{
            
            let detailViewController = displaySegue.destination as! DetailViewController
            detailViewController.displayMemo = selectedMemo[indexPath.row + 1]
            detailViewController.Row = selectedRow
            detailViewController.displayRow = indexPath.row
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        displaySegue = segue
    }
}

extension Carousel: UICollectionViewDelegateFlowLayout {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        (collectionView.collectionViewLayout as! FlowLayout).prepareForPaging()
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return headerSize
    }
}

