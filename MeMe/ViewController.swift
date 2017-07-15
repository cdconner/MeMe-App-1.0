//
//  ViewController.swift
//  MeMe
//
//  Created by Chris Conner on 7/10/17.
//  Copyright © 2017 Chris Conner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let pickerController = UIImagePickerController()
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!

    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        pickerController.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func pickAnImage(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickanImageFromCamera(_ sender: Any) {
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ pickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ textField: UIImagePickerController) {
        
    }
    
    
    //This is to clear the text field when a user taps into it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField {
            topTextField.text = ""
        } else {
            bottomTextField.text = ""
        }
    }
}

