//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Milad Nozari on 3/10/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import AVFoundation

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
        
        topText.delegate = self
        bottomText.delegate = self
        
        // disable the camera button if no camera is availble
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        else {
            // if camera is available, check to see if we've been granted permission or not.
            checkForCameraPermission()
        }
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
        // load an image from the camera
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func loadImageFromGallery(_ sender: UIBarButtonItem) {
    }
}

// MARK: - TextField Delegate
extension MemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}

// MARK: - UINavigationControllerDelegate
extension MemeViewController: UINavigationControllerDelegate {
    
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension MemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
}

// MARK: - Public functions
extension MemeViewController {
    
    
    
}


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
            requestCameraAccess(alreadyMade: true)
        case .notDetermined:
            // The status is not determined, i.e. it has neither been
            // granted nor denied, which means it's the first time this
            // process is occuring. So ask for permission
            requestCameraAccess(alreadyMade: false)
        default:
            break
        }
    }
    
    fileprivate func requestCameraAccess(alreadyMade: Bool) {
        if alreadyMade {
            let title = "Camera Permission"
            let message = alreadyMade
                ? "You have denied access to your camera. Please open your device's settings to grant the permission."
                : "We need to access your camera, in case you want to take a picture and make a meme from it."
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionOpenSettings = UIAlertAction(title: "Open Settings", style: .default, handler: openSettings)
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(actionCancel)
            alertController.addAction(actionOpenSettings)
            present(alertController, animated: true, completion: nil)
        }
        else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
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
    
}

