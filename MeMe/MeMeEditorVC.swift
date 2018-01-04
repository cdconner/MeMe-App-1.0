//
//  ViewController.swift
//  MeMe
//
//  Created by Chris Conner on 7/10/17.
//  Copyright © 2017 Chris Conner. All rights reserved.
//

import UIKit

class MeMeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let pickerController = UIImagePickerController()
    
    struct Meme {
        let topText: String!
        let bottomText: String!
        let originalImage: UIImage!
        let memedImage: UIImage!
    }
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextField(textField: topTextField, defaultText: "Top")
        customizeTextField(textField: bottomTextField, defaultText: "Bottom")
        pickerController.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
    }
    
    func customizeTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedStringKey.strokeWidth.rawValue: -5
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
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
        shareButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ textField: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //This is to clear the text field when a user taps into it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField {
            topTextField.text = ""
        } else {
            bottomTextField.text = ""
        }
    }
    
    //This allows for dismissal of the keyboard when the user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
//    func keyboardWillShow(_ notification:Notification) {
//        view.frame.origin.y -= (getKeyboardHeight(notification)/2)
//    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (topTextField.isFirstResponder) {
            view.frame.origin.y -= (getKeyboardHeight(notification)/6)
        } else {view.frame.origin.y -= (getKeyboardHeight(notification))
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.toolBar.isHidden = true
        self.navBar.isHidden = true
       // self.shareButton.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Unhide toolbar and navbar
        self.toolBar.isHidden = false
        self.navBar.isHidden = false
      //  self.shareButton.isHidden = false
        return memedImage
    }
    
    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.save()
        }
        
        present(activityController, animated: true, completion: nil)
    }
}

