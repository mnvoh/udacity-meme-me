//
//  GridViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/12/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var memesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    let itemSpacing: CGFloat = 8
    let itemsPerRow: Int = 3
    
    var memes = [Meme]() {
        didSet {
            guard memesCollectionView != nil else { return }
            
            memesCollectionView.reloadData()
        }
    }
    
    struct Storyboard {
        static let cellReuseId = "memeGridCell"
        static let memeEditorId = "MemeEditor"
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup flow layout
        
        // to make an even spacing between the cells, we have to divide the collection view
        // width minus the total spacings by itemsPerRow
        let totalItemSpacing = CGFloat(itemsPerRow + 1) * itemSpacing
        let itemSize = (memesCollectionView.frame.width - totalItemSpacing) / CGFloat(itemsPerRow)
        
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    // MARK: - IBActions
    
    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        let memeEditorView = storyboard?.instantiateViewController(withIdentifier: Storyboard.memeEditorId) as! MemeViewController
        navigationController?.pushViewController(memeEditorView, animated: true)
    }
}

// MARK: - CollectionView Datasource
extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellReuseId, for: indexPath)
            as! MemeGridCollectionViewCell
        
        let meme = memes[indexPath.item]
        
        cell.memeImage.image = meme.originalImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        
        return cell
    }
    
}


// MARK: - COllectionView Delegate
extension GridViewController: UICollectionViewDelegate {}

// MARK: - private functions
extension GridViewController {}
