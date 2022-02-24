//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit



class WelcomeViewController: UIViewController {
    
    // MARK: - IBAoutlet

    @IBOutlet weak var titleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textAnimation()
       
    }
    
    // MARK: - Viariables
    
    
    
    // MARK: - Helper Functions
    
    // Create Animation on text by Timer
    func textAnimation() {
        let titleText = "⚡️FlashChat"
        var currentIndex = 0.0

        for title in titleText {

            Timer.scheduledTimer(withTimeInterval: 0.1 * currentIndex, repeats: false) { timer in
                self.titleLabel.text?.append(title)
            }
            currentIndex += 1
        }
    }
    
 

}
