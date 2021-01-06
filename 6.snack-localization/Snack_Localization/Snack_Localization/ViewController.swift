//
//  ViewController.swift
//  Snack_Localization
//
//  Created by nju on 2020/12/6.
//

import UIKit
import os.log
import CoreML
import CoreMedia
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var localization: UIButton!
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        image.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        print("select image from photolibrary")
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    lazy var localizationRequest: VNCoreMLRequest = {
        do{
            let localization = try my_model(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: localization.model)
            let request = VNCoreMLRequest(model: model)
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to create a request!")
        }
    }()
    
    @IBAction func snackLocalization(){
        
    }
}

