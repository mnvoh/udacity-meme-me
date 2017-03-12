//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/12/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard imageView != nil else { return }
            
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
