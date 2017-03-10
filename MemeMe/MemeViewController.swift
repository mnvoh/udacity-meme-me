//
//  ViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/10/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    // MARK: - Properties
    
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: Add keyboard observer
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // TODO: Remove keyboard observer
    }
    
    // MARK: - IBActions
    
    @IBAction func share(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func loadImageFromCamera(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func loadImageFromGallery(_ sender: UIBarButtonItem) {
    }
}

// MARK: - Public functions
extension MemeViewController {
    
    
    
}


// MARK: - Private functions
extension MemeViewController {

    
    
}

