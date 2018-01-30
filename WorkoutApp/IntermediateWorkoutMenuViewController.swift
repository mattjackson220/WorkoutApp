//
//  IntermediateWorkoutMenuViewController.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 1/12/18.
//  Copyright © 2018 Matthew Jackson. All rights reserved.
//

import UIKit

class IntermediateWorkoutMenuViewController: UIViewController {
    
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
        if (segue.identifier == "goToInt15") {
            buttonText = "Int15"
        } else if (segue.identifier == "goToInt12") {
            buttonText = "Int12"
        }
        if buttonText != "" {
            defaultStorage.set(buttonText, forKey: "buttonText")
            let destination = segue.destination as! WorkoutViewController;
            destination.buttonText = buttonText;
        }
    }
}


