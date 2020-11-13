//
//  ProductViewController.swift
//  producttracker
//
//  Created by njuios on 2020/11/3.
//

import UIKit
import os.log

class ProductViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBAction func selectImage(_ sender: UIButton)
    {
        print("haha")
        //print(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        nametextfield.resignFirstResponder()
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    /*
    @IBAction func selectimage(_ sender: UITapGestureRecognizer)
    {
        print("haha")
        nametextfield.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("print a picture")
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoimageview.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    @IBOutlet weak var productnamelabel: UILabel!
    @IBOutlet weak var nametextfield: UITextField!
    @IBOutlet weak var photoimageview: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var product:Product?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("textcancel")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nametextfield.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("1")
        nametextfield.delegate=self
        if let product = product {
                navigationItem.title = product.name
                nametextfield.text = product.name
                photoimageview.image = product.photo
                ratingControl.rating = product.rating
            }
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
               os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
               return
           }
           
           let name = nametextfield.text ?? ""
           let photo = photoimageview.image
           let rating = ratingControl.rating
           
           // Set the meal to be passed to MealTableViewController after the unwind segue.
           product = Product(name: name, photo: photo, rating: rating)
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
            
            if isPresentingInAddMealMode {
                dismiss(animated: true, completion: nil)
            }
            else if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            }
            else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }
    }
}

