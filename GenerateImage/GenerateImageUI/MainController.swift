//
//  IntroController.swift
//  SmartSketch
//
//  Created by Tuqa on 3/29/23.
//

import UIKit

class MainController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var continueOutlet: UIButton!
    @IBOutlet weak var purubleImage: UIImageView!
    @IBOutlet weak var blueImage: UIImageView!
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientTetx()
        addGradientToButton()
        rotateImage()
        SetUpnavigation()
    }
    
    //MARK: - saving users logIn
    func SetUpnavigation() {
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            // User is already LoggedIn
            // push at the top of the stack
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "generatorVC") as! GenerateImageController
            self.navigationController?.pushViewController(VC, animated: false)
        }
    }
    
    //MARK: - Actions
    @IBAction func continueButton(_ sender: Any) {
        // keep the user in the generator controller
        UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
        // push the generator Controller at the top of the stack
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "generatorVC") as! GenerateImageController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK: - Rotate Image
    func rotateImage() {
        purubleImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        blueImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
    }
    //MARK: - Set greadient color to the text, Button
    func addGradientTetx() {
        // Create an instance of GradientLabel
        let gradientLabel = GradientLabel()
        gradientLabel.text = "Help us bring your vision to life"
        gradientLabel.frame = CGRect(x: view.frame.width/4.4, y: view.frame.height/2.19, width: 265, height: 38)
        // Add the label to the view hierarchy
        view.addSubview(gradientLabel)
    }
    // adding gradient colo to the button
    func addGradientToButton() {
        GradientColor.graadientColorInstance.InsertGradientColor(view: continueOutlet, frame: CGRect(x: 0, y: 0, width: continueOutlet.frame.width, height: continueOutlet.frame.height), colors: [UIColor(named: "StartPointColor")!, UIColor(named: "EndPointColor")!], startPoint: CGPoint(x: 0.0,y: 0.5), endPoint: CGPoint(x: 1.0,y: 0.5), cornerRadius: 10)
        continueOutlet.layer.cornerRadius = 10
    }
}
