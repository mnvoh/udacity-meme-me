//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/10/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MemeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: - Properties
    let bottomTextTag = 1
    
    // Each time a text field is selected for editing, this var gets updated
    // so that we can determine whether we need to shift the view up or not.
    var textFieldWithFocusTag = 0
    
    enum MediaTypes: String {
        case camera = "Camera"
        case photoLibrary = "Photo Library"
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topText)
        setupTextField(bottomText)
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        shareButton.isEnabled = false
        
        // check to see if we've been granted permission or not.
        // this function will set the enabled status of the camera 
        // button.
        checkForCameraPermission()
        
        // Check to see if we have access to the photo library
        checkForPhotoLibraryPermission()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:))
            , name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear)
            , name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        // make sure nothing is nil
        guard let topText = topText.text,
            let bottomText = bottomText.text,
            let originalImage = imageView.image else {
                return
        }
        
        let memedImage = generateMemedImage()
        
        // now we start an activity view controller to share the image
        let activityViewController = UIActivityViewController(activityItems: [memedImage],
                                                              applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity: UIActivityType?, completed: Bool, items: [Any]?, error: Error?) in
            guard completed, error == nil else {
                return
            }
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage,
                            memedImage: memedImage)
            meme.save()
        }
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    
    @IBAction func loadImageFromCamera(_ sender: UIBarButtonItem) {
        // first check to see if we have permission
        checkForCameraPermission()
        
        // load an image from the camera
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loadImageFromGallery(_ sender: UIBarButtonItem) {
        // load an image from the gallery
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate
extension MemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldWithFocusTag = textField.tag
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - UINavigationControllerDelegate
extension MemeViewController: UINavigationControllerDelegate {}


// MARK: - UIImagePickerControllerDelegate
extension MemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
        
        shareButton.isEnabled = true
    }
    
}

// MARK: - Public functions
extension MemeViewController {}


// MARK: - Private functions
extension MemeViewController {
    
    fileprivate func setupTextField(_ textField: UITextField) {
        textField.delegate = self
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.center
        
        let attributes: [String : Any] = [
            NSStrokeWidthAttributeName: -4.0,
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: 0.0,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        ]
        
        textField.defaultTextAttributes = attributes
    }

    fileprivate func checkForCameraPermission() {
        // get the current authorization status of camera access
        let permissionStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch permissionStatus {
        case .authorized:
            // Already authorized. Nothing to do.
            break
        case .denied:
            // The user has previously opted to deny access, 
            // so we'll ask her to open settings and grant it.
            requestAccess(alreadyMade: true, mediaType: .camera)
        case .notDetermined:
            // The status is not determined, i.e. it has neither been
            // granted nor denied, which means it's the first time this
            // process is occuring. So ask for permission
            requestAccess(alreadyMade: false, mediaType: .camera)
        default:
            break
        }
    }
    
    fileprivate func checkForPhotoLibraryPermission() {
        let permissionStatus = PHPhotoLibrary.authorizationStatus()
        
        switch permissionStatus {
        case .authorized:
            // Already authorized. Nothing to do.
            break
        case .denied:
            // The user has previously opted to deny access,
            // so we'll ask her to open settings and grant it.
            cameraButton.isEnabled = false
            requestAccess(alreadyMade: true, mediaType: .photoLibrary)
        case .notDetermined:
            // The status is not determined, i.e. it has neither been
            // granted nor denied, which means it's the first time this
            // process is occuring. So ask for permission
            requestAccess(alreadyMade: false, mediaType: .photoLibrary)
        default:
            break
        }
    }
    
    fileprivate func requestAccess(alreadyMade: Bool, mediaType: MediaTypes) {
        if alreadyMade {
            let title = "\(mediaType.rawValue) Permission"
            let message = "You have denied access to your \(mediaType.rawValue.lowercased()). Please open your device's settings to grant the permission."
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionOpenSettings = UIAlertAction(title: "Open Settings", style: .default, handler: openSettings)
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(actionCancel)
            alertController.addAction(actionOpenSettings)
            present(alertController, animated: true, completion: nil)
        }
        else {
            switch mediaType {
            case .camera:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (newStatus: Bool) in
                    if !newStatus {
                        self.cameraButton.isEnabled = false
                    }
                }
            case .photoLibrary:
                // we don't need to do anything in the closure, because
                // if the user taps cancel, and later decides that he
                // wants this feature, she has to tap the album button
                // again, which start this process again.
                PHPhotoLibrary.requestAuthorization {_ in }
            }
        }
    }
    
    fileprivate func openSettings(_ action: UIAlertAction) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        // Open the url of the device's settings.
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    @objc fileprivate func keyboardWillAppear(_ notification: Notification) {
        // if the top text field is being edited, we don't wanna move the view
        if textFieldWithFocusTag != bottomTextTag {
            return
        }
        
        if let userInfo = notification.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            view.frame.origin.y = -keyboardSize.cgRectValue.height
        }
    }
    
    @objc fileprivate func keyboardWillDisappear() {
        view.frame.origin.y = 0
    }
    
    fileprivate func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        
        return memedImage
    }
}

