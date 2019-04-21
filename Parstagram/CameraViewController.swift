//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Weiran Xiong on 4/16/19.
//  Copyright © 2019 Weiran Xiong. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: (commentField.superview?.frame.origin.y)!), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.imageView?.image = scaledImage
        
        imageView.setImage(scaledImage, for: .normal)
        
        imageSelected = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        if !imageSelected || commentField.text == nil {
            let alertController = UIAlertController(title: "Empty Post", message: "Please add some text and a photo first", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        
        let post = PFObject(className: "Posts")
        
        guard let imgData = imageView.image(for: .normal)?.pngData() else {
            print("data not fetched")
            return
        }
        let file = PFFile(data: imgData)
        
        post["author"] = PFUser.current()
        post["caption"] = commentField.text
        post["image"] = file
        
        post.saveInBackground { (success, err) in
            if success {
                print("saved")
            } else {
                print("error")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
