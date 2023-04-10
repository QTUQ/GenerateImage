//
//  GenerateImageController.swift
//  GenerateImage
//
//  Created by Tuqa on 4/2/23.
//

import UIKit

class GenerateImageController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sketchTextField: UITextField!
    @IBOutlet weak var GenerateImageOutlet: UIButton!
    @IBOutlet weak var sketchImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var saveImageOutlet: UIButton!
    @IBOutlet weak var deleteOutlet: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sketchTextField.delegate = self
        saveImageOutlet.isHidden = true
        shareOutlet.isHidden = true
        deleteOutlet.isHidden = true
        activityIndicator.isHidden = true
        configureTextFieldUI()
        ButtonUI()
        setupKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK: - Request to generate the text to image action
    func fetchImage(prompt: String) {
        activityIndicator.isHidden = false
        sketchImage.isHidden = true
        activityIndicator.startAnimating()
        Task {
            do {
                print("do")
                let image = try  await ImagesGenerationsService().fetchImageForPrompt(prompt)
                await MainActor.run {
                    sketchImage.image = image
                    activityIndicator.stopAnimating()
                    sketchImage.isHidden = false
                    activityIndicator.isHidden = true
                    shareOutlet.isHidden = false
                    deleteOutlet.isHidden = false
                    saveImageOutlet.isHidden = false
                    print("image")
                }
            }
            catch {
                print(error.localizedDescription)
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                sketchImage.isHidden = false
                let alert = UIAlertController(title: "Connection Failed", message: "Please Check Your Internet Connection", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .cancel)
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func GenerateImageButton(_ sender: Any) {
        if let sketchText = sketchTextField.text, sketchText != "" {
            fetchImage(prompt: sketchText)
        }
        
        else {
            let alert = UIAlertController(title: "Help us bring your vision to life", message: "We recommend providing as much detail as possible in your description so that our app can create the perfect image for you.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            
        }
    }
    
    //MARK: - share the image with others action
    @IBAction func shareImageButton(_ sender: Any) {
        print("share image")
        //Load or create a UIImage object
        let image = sketchImage.image
        
        // Create an array of activity types for WhatsApp, Facebook, and other social media platforms
        let activityTypes: [UIActivity.ActivityType] = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
            .copyToPasteboard,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks,
        ]
        // Create a UIActivityViewController object and set its activityItems and excludedActivityTypes properties
        let activityViewController = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        activityViewController.excludedActivityTypes = activityViewController.excludedActivityTypes?.filter({ !activityTypes.contains($0) })
        
        // 4. Present the UIActivityViewController object
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - save the image to user photos action
    @IBAction func saveImageButton(_ sender: Any) {
        print("save image")
        guard let image = sketchImage.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    // action to save the image to the user photo
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Error saving image
            let alert = UIAlertController(title: "Error saving image", message: "Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            print("Error saving image: \(error.localizedDescription)")
        } else {
            // Image saved successfully
            print("Image saved successfully")
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    //MARK: - Delete the image and start over
    @IBAction func deleteButton(_ sender: Any) {
        print("delete")
        let alert = UIAlertController(title: "Delete", message: "are you sure you want to delete this image?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { action in
            self.sketchTextField.text = ""
            self.sketchTextField.placeholder = "a humanoid robot playing chess..."
            self.saveImageOutlet.isHidden = true
            self.shareOutlet.isHidden = true
            self.deleteOutlet.isHidden = true
            self.sketchImage.image = UIImage(named: "ChessImage")
            self.activityIndicator.isHidden = true
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    //MARK: - dealing with sketch text field, buttons UI
    func configureTextFieldUI() {
        sketchTextField.dropShadow(offset: CGSize(width: 0, height: 6), color: UIColor(named: "ShadowColor")!, radius: 5, opacity: 20)
        sketchTextField.autocorrectionType = .no
        sketchTextField.returnKeyType = .done
    }
    
    //MARK: - Buttons UI
    func ButtonUI() {
        GradientColor.graadientColorInstance.InsertGradientColor(view: GenerateImageOutlet, frame: CGRect(x: 0, y: 0, width: GenerateImageOutlet.frame.width, height: GenerateImageOutlet.frame.height), colors: [UIColor(named: "StartPointColor")!, UIColor(named: "EndPointColor")!], startPoint: CGPoint(x: 0.0,y: 0.5), endPoint: CGPoint(x: 1.0,y: 0.5), cornerRadius: 10)
        GenerateImageOutlet.layer.cornerRadius = 10
        GenerateImageOutlet.addTarget(self, action: #selector(buttonAnimateTarget), for: .touchUpInside)
        // share button UI
        shareOutlet.layer.cornerRadius = 8
        GradientColor.graadientColorInstance.InsertGradientColor(view: shareOutlet, frame: CGRect(x: 0, y: 0, width: shareOutlet.frame.width, height: shareOutlet.frame.height), colors: [UIColor(named: "StartPointColor")!, UIColor(named: "EndPointColor")!], startPoint: CGPoint(x: 0.0,y: 0.5), endPoint: CGPoint(x: 1.0,y: 0.5), cornerRadius: 8)
        // save image Button UI
        GradientColor.graadientColorInstance.InsertGradientColor(view: saveImageOutlet, frame: CGRect(x: 0, y: 0, width: saveImageOutlet.frame.width, height: saveImageOutlet.frame.height), colors: [UIColor(named: "StartPointColor")!, UIColor(named: "EndPointColor")!], startPoint: CGPoint(x: 0.0,y: 0.5), endPoint: CGPoint(x: 1.0,y: 0.5), cornerRadius: 8)
        saveImageOutlet.layer.cornerRadius = 8
        // delete button UI
        deleteOutlet.layer.cornerRadius = 8
        GradientColor.graadientColorInstance.InsertGradientColor(view: deleteOutlet, frame: CGRect(x: 0, y: 0, width: deleteOutlet.frame.width, height: deleteOutlet.frame.height), colors: [UIColor(named: "StartPointColor")!, UIColor(named: "EndPointColor")!], startPoint: CGPoint(x: 0.0,y: 0.5), endPoint: CGPoint(x: 1.0,y: 0.5), cornerRadius: 8)
    }
    
    // MARK: - Button Animation method
    // adding the animtion when press the button
    @objc func buttonAnimateTarget(sender: UIButton) {
        self.animateButton(sender)
    }
    
    fileprivate func animateButton(_ animate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            animate.transform = CGAffineTransform(scaleX: 0.92, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2,options: .curveEaseIn, animations:  {
                animate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
}

//MARK: - UITextField Delegate
extension GenerateImageController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: - Dealing with the keyboard
    func setupKeyboard() {
        // use the static KeyboardObserver instance to call the scrollWithKeyboard method to present the keyboard without any issues and the input remains visible
        KeyboardObserver.KeyboardObserverInstance.scrollWithKeyboard(view: self.view)
    }
}
