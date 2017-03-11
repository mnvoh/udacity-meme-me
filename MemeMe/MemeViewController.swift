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
    
    @IBOutlet weak var topTextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    let bottomTextTag = 1
    
    enum MediaTypes: String {
        case camera = "Camera"
        case photoLibrary = "Photo Library"
    }
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self
        bottomText.delegate = self
        
        shareButton.isEnabled = false
        
        // check to see if we've been granted permission or not.
        // this function will set the enabled status of the camera 
        // button.
        checkForCameraPermission()
        
        // Check to see if we have access to the photo library
        checkForPhotoLibraryPermission()
        
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
    
    /// This function will recalculate the correct constant values
    /// for the text views' constraints, so that they will fall over
    /// the image inside the imageView
    fileprivate func updateTextFieldsConstraints() {
        
    }
}

