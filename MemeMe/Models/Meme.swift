//
//  Meme.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/11/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import Photos

struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(self)
    }
}
