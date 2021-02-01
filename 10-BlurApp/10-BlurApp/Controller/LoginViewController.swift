//
//  ViewController.swift
//  10-BlurApp
//
//  Created by Влад Динеев on 01.02.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var backgroundImageView: UIImageView!
    
    let imageSet = ["cloud", "coffee", "food", "pmq", "temple"]
    var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let selectedImageIndex = Int(arc4random_uniform(5))
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }


}

