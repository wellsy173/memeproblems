//
//  ViewController.swift
//  Meme
//
//  Created by Simon Wells on 2020/4/27.
//  Copyright © 2020 Simon Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    
    
    //Text Attributes//
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 3.0 ]
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            subscribeToKeyboardNotifications()
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
            resetState()
            
        
    }
            
        override func viewWillDisappear(_ animated: Bool) {
            
            super.viewWillDisappear(animated)
            UnsubscribeToKeyBoardNotifications()
        }
        // Do any additional setup after loading the view.
//outlets//
    
    
    
    @IBAction func pickAnImage(_ sender: Any) {
        let input = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = input.tag == 0 ? .camera: . photoLibrary
        present(imagePicker, animated: true, completion: nil)
        print("image")
    }
    
    
    
    @IBAction func shareImage(_ sender: Any) {
        let sharedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activity, success, items, error) in
            if success {
            self.saveMeme()
        }
           
    }
    
    }

        //functions//
        
    func setTextField (field: UITextField, toText: String) {
        field.defaultTextAttributes = memeTextAttributes
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.delegate = self
        field.text = toText
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print("banana")
            imagePickerView.image = image
            }
            self.dismiss(animated: true, completion: nil)
    }
    struct Meme {
    let textFieldTop: String
    let textFieldBottom: String
    let originalImage: UIImage
    let memedImage: UIImage
    }
    //if put on MemeModel.swift, I get the error = Use of unresolved identifier 'Meme'//
    func saveMeme() {
        _ = Meme(textFieldTop: textFieldTop.text!, textFieldBottom: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
    //hide textfields//
        self.textFieldTop.isHidden = true
        self.textFieldBottom.isHidden = true
        //render to viewer//
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //show textfields//
        return memeImage
    }
    
    func resetState(){
    imagePickerView.image = nil
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        shareButton.isEnabled = false
        
    }

    let flexibleSpace = UIBarButtonItem(
        barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
        target: nil,
        action: nil
    )
            //keyboard setup functions//
    var isFirstEditTop: Bool = true
    var isFirstEditBottom: Bool = true
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == textFieldTop, isFirstEditTop == true {
                textField.text = ""
                isFirstEditTop = false
            }
            
            if textField == textFieldBottom, isFirstEditBottom == true {
                textField.text = ""
                isFirstEditBottom = false
                
            
    }
    }

        func textFieldShouldReturn(_ TextField: UITextField) -> Bool {
            self.view.endEditing(true)
            
            return true
            
            }
            
            
            func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
                let userInfo = notification.userInfo
                let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                return keyboardSize.cgRectValue.height
            }
            
            
    @objc func keyboardWillShow(_ notification: Notification) {
                     if textFieldBottom.isEditing {
                        view.frame.origin.y = -getKeyBoardHeight(notification)
                 }
    }
            
            func subscribeToKeyboardNotifications() {
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                    
            }
            
            func UnsubscribeToKeyBoardNotifications() {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
               
    
        @objc func keyboardWillHide(_notification: Notification) {
        view.frame.origin.y = 0
             
    }
               
    
    

    @IBAction func discardMeme(_ sender: Any) {
    resetState()
    }
    
                
            
    
}
