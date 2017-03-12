//
//  ListViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/12/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var memesTableView: UITableView!
    
    // MARK: - Properties
    let tableViewRowHeight: CGFloat = 44
    
    var memes = [Meme]() {
        didSet {
            memesTableView.reloadData()
        }
    }
    
    struct Storyboard {
        static let memeEditorId = "MemeEditor"
        static let cellReuseId = "memeListCell"
        static let detailViewId = "MemeDetail"
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func editMemes(_ sender: UIBarButtonItem) {
        if(memesTableView.isEditing == true) {
            memesTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
        else {
            memesTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }
}

// MARK: - Table View Datasource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellReuseId, for: indexPath)

        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.imageView?.image = meme.originalImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.deleteRow(at: indexPath)
        }
        return [action]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteRow(at: indexPath)
    }
}

// MARK: - Table View Delegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
}

// MARK: - Private functions
extension ListViewController {
    
    fileprivate func deleteRow(at indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes.remove(at: indexPath.row)
        appDelegate.memes = memes
        memesTableView.reloadData()
    }
    
}
