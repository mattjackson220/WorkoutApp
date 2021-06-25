//
//  ExerciseViewCell.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 8/4/17.
//  Copyright © 2017 Matthew Jackson. All rights reserved.
//

import Foundation
import UIKit

class ExerciseViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var weight: UITextView!
    @IBOutlet weak var previousWeight: UITextView!
    @IBOutlet weak var setsAndReps: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    
    let defaultStorage = UserDefaults.standard
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        previousWeight.isUserInteractionEnabled = false
        weight.isUserInteractionEnabled = true
        setsAndReps.isUserInteractionEnabled = false
        
        weight.keyboardType = .decimalPad
        
        self.setBorderOnCells(cell: previousWeight)
        self.setBorderOnCells(cell: weight)
        self.setBorderOnCells(cell: setsAndReps)
        
        exerciseButton.layer.borderWidth = 1.0
        exerciseButton.layer.borderColor = UIColor.black.cgColor
        exerciseButton.layer.cornerRadius = 4;
        
        weight.delegate = self

        previousWeight.text = ""
        weight.text = ""
        setsAndReps.text = ""
        
        // Initialization code
    }
    
    func setBorderOnCells(cell: UITextView) {
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 4;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        let buttonText = defaultStorage.object(forKey: "buttonText") as! String
        let tabText = defaultStorage.object(forKey: "tabText") as! String
        defaultStorage.set(weight.text, forKey: buttonText + tabText + exerciseButton.title(for: .normal)! + "Weight")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let weightInt:Int = Int(weight.text), let prevWeightInt:Int = Int(previousWeight.text) {
            if (weightInt > prevWeightInt) {
                (self.next?.next?.next as? WorkoutViewController)!.showIncreasedWeightMessage()
            }
        }
    }
}
