//
//  SplashViewController.swift
//  Movies
//
//  Created by Selay Soysal on 9.05.2019.
//  Copyright © 2019 Selay Turkmen. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 2,
                             target: self,
                             selector: #selector(self.showView),
                             userInfo: nil,
                             repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func showView(){
        DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "launch", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
    }
}
