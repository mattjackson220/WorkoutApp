//
//  ToningMenuViewController.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 3/30/18.
//  Copyright © 2018 Matthew Jackson. All rights reserved.
//

import UIKit

class ToningMenuViewController: UIViewController {
    
    let defaultStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        var buttonText = "";
        if (segue.identifier == "goToToning1") {
            buttonText = "Toning"
        } else if (segue.identifier == "goToToning2") {
            buttonText = "Toning2"
        }
        if buttonText != "" {
            defaultStorage.set(buttonText, forKey: "buttonText")
            let destination = segue.destination as! WorkoutViewController;
            destination.buttonText = buttonText;
        }
    }
}



