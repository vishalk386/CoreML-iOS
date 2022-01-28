//
//  ViewController.swift
//  DetectImage-CoreML
//
//  Created by Vishal Kamble on 25/01/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imageView.image = image
            
            guard  let ciImage = CIImage(image: image) else {
                fatalError("not detect image")
            }
            detectImg(imageCI: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detectImg(imageCI: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("not loaded coreML")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model failed to process image")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("Flower"){
                    self.navigationItem.title = "Flower!"
                }else{
                    self.navigationItem.title = "Not Flower"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: imageCI)
        do{
        try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    

}

