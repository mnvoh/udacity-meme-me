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
    let itemsPerRowPortrait = 3
    let itemsPerRowLandscape = 6
    var itemsPerRow: Int = 3
    
    var memes = [Meme]() {
        didSet {
            guard memesCollectionView != nil else { return }
            
            memesCollectionView.reloadData()
        }
    }
    
    struct Storyboard {
        static let cellReuseId = "memeGridCell"
        static let memeEditorId = "MemeEditor"
        static let detailViewId = "MemeDetail"
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup flow layout
        setupFlowLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // add an observer so that we'll get notified when device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged(_:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
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
        cell.topText.attributedText = getAttributedText(text: meme.topText)
        cell.bottomText.attributedText = getAttributedText(text: meme.bottomText)
        
        return cell
    }
    
}


// MARK: - COllectionView Delegate
extension GridViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailView = storyboard?.instantiateViewController(withIdentifier: Storyboard.detailViewId)
            as! DetailViewController
        memeDetailView.image = memes[indexPath.item].memedImage
        navigationController?.pushViewController(memeDetailView, animated: true)
    }
    
}

// MARK: - private functions
extension GridViewController {

    fileprivate func setupFlowLayout() {
        // to make an even spacing between the cells, we have to divide the collection view
        // width minus the total spacings by itemsPerRow
        let totalItemSpacing = CGFloat(itemsPerRow + 1) * itemSpacing
        let itemSize = (memesCollectionView.frame.width - totalItemSpacing) / CGFloat(itemsPerRow)
        
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    @objc fileprivate func deviceOrientationChanged(_ notification: Notification) {
        // first set the new items per row. We could just simply re-setup the flow layout
        // but that way the items would become too tall on small devices
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            itemsPerRow = itemsPerRowPortrait
        }
        else {
            itemsPerRow = itemsPerRowLandscape
        }
        setupFlowLayout()
    }
    
    fileprivate func getAttributedText(text: String) -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.center
        
        let attributes: [String : Any] = [
            NSStrokeWidthAttributeName: -2.0,
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: 0.0,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 4)!,
            ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }

}
