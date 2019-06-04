//
//  ViewController.swift
//  kfvz-firebase2
//
//  Created by 馬馬桑 on 2019/5/21.
//  Copyright © 2019  kfvzfur. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate { 

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func upload() {
        activityIndicatorView.startAnimating()
        let db = Firestore.firestore()
        let data: [String: Any] = ["message": textField.text!, "date": Date()]
        var photoReference: DocumentReference?
        photoReference = db.collection("photos").addDocument(data: data) { (error) in
            guard error == nil else {
                self.activityIndicatorView.stopAnimating()
                return
            }
            
            let storageReference = Storage.storage().reference()
            let fileReference = storageReference.child(UUID().uuidString + ".jpg")
            let image = self.photoButton.image(for: .normal)
            
            let size = CGSize(width: 640, height:
                image!.size.height * 640 / image!.size.width)
            UIGraphicsBeginImageContext(size)
            image?.draw(in: CGRect(origin: .zero, size: size))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let data = resizeImage?.jpegData(compressionQuality: 0.8) {
                fileReference.putData(data, metadata: nil) { (metadata, error) in
                    guard let _ = metadata, error == nil else {
                        self.activityIndicatorView.stopAnimating()
                        return
                    }
                    fileReference.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {
                            self.activityIndicatorView.stopAnimating()
                            return
                        }
                        photoReference?.updateData(["photoUrl": downloadURL.absoluteString])
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        photoButton.setImage(image, for: .normal)
        photoButton.imageView?.contentMode = .scaleAspectFill
        photoButton.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func selectPhoto(_ sender: Any) {
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        present(imagepicker, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        upload()
    }
}
