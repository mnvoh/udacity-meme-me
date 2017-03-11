//
//  Meme.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/11/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    func getShareableObject() -> [AnyObject] {
        var retval = [AnyObject]()
        
        retval.append(memedImage)
        
        return retval
    }
}
