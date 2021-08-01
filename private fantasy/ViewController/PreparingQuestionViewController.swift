//
//  PreparingQuestionViewController.swift
//  private fantasy
//
//  Created by Vijay Rathore on 29/07/21.
//

import UIKit
import Lottie

class PreparingQuestionViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
   
    override func viewDidLoad() {
        animationView.loopMode = .loop
        animationView.play()
    }
    
}
