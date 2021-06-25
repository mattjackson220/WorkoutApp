//
//  CustomWorkoutsViewController.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 8/11/17.
//  Copyright © 2017 Matthew Jackson. All rights reserved.
//

import UIKit

class CustomWorkoutsViewController: UIViewController {
    @IBOutlet weak var createNewButton: WorkoutButtonView!
    @IBAction func clickedCreateNew(_ sender: Any) {
        addButton(buttonNumber: 1, yValue: lastButtonYValue)
        lastButtonYValue += yValueAdjustment
    }
    @IBOutlet weak var backToMainMenuButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var customWorkoutNames: [WorkoutTextView] = []
    let defaultStorage = UserDefaults.standard
    var newButtonText: String!
    var lastButtonYValue = 0
    var buttonToDeleteButtonMap = [WorkoutDeleteButtonView:WorkoutButtonView]()
    var buttonToTextMap = [WorkoutButtonView:WorkoutTextView]()
    var yValueAdjustment: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoFitButtonLabel(button: self.backToMainMenuButton)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        yValueAdjustment = Int( (self.view.frame.size.height) / 6) + 10
        reloadAllWorkoutButtons()
    }
    
    func loadCustomButtons() {
        var scrollLength = 0
        if let decodedWorkoutNamesDb = defaultStorage.object(forKey: "customWorkoutNames") {
            let workoutNamesDb = NSKeyedUnarchiver.unarchiveObject(with: decodedWorkoutNamesDb as! Data ) as! [WorkoutTextView]
            customWorkoutNames = workoutNamesDb
            var i = 0
            var startingYValue = 0
            for customWorkoutName in customWorkoutNames {
                loadButton(buttonNumber: i, textValue: customWorkoutName.text, yValue: startingYValue)
                if i == customWorkoutNames.count {
                    self.lastButtonYValue = startingYValue
                }
                i += 1
                startingYValue += yValueAdjustment
                scrollLength += yValueAdjustment
            }
        }
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width - 70, height: CGFloat(scrollLength))
        self.view.addSubview(self.scrollView)

    }
    
    @objc func buttonAction(sender: WorkoutButtonView!) {
        performSegue(withIdentifier: "goToCustomWorkoutExercises", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        var buttonText = "";
        if (segue.identifier == "goToCustomWorkoutExercises") {
            let button = sender as! WorkoutButtonView
            let textFromButton = self.buttonToTextMap[button]
            buttonText = (textFromButton?.text)!
            let destination = segue.destination as! WorkoutViewController;
            destination.fromCustomMenu = true
        }
        if buttonText != "" {
            defaultStorage.set(buttonText, forKey: "buttonText")
            let destination = segue.destination as! WorkoutViewController;
            destination.buttonText = buttonText;
        }
    }
    
    func reloadAllWorkoutButtons() {
        for view in self.scrollView.subviews {
            if let workoutButton = view as? WorkoutButtonView {
                workoutButton.removeFromSuperview()
            }
            if let workoutText = view as? WorkoutTextView {
                workoutText.removeFromSuperview()
            }
            if let workoutDeleteButton = view as? WorkoutDeleteButtonView {
                workoutDeleteButton.removeFromSuperview()
            }
        }
        self.buttonToDeleteButtonMap.removeAll()
        self.buttonToTextMap.removeAll()
        self.loadCustomButtons()
    }
    
    @objc func deleteButtonAction(sender: WorkoutDeleteButtonView!) {
        let alert = UIAlertController(title: "Delete " + self.buttonToTextMap[self.buttonToDeleteButtonMap[sender]!]!.text! + "?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let button = self.buttonToDeleteButtonMap[sender]!
            let text = self.buttonToTextMap[button]!
            for name in self.customWorkoutNames {
                if name.text == text.text {
                    let index = self.customWorkoutNames.index(of: name)
                    self.customWorkoutNames.remove(at: index!)
                }
            }
            text.removeFromSuperview()
            button.removeFromSuperview()
            sender.removeFromSuperview()
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.customWorkoutNames)
            self.defaultStorage.set(encodedData, forKey: "customWorkoutNames")
            self.defaultStorage.synchronize()
            
            self.reloadAllWorkoutButtons()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func addButton(buttonNumber: Int!, yValue: Int!) {
        
        let alert = UIAlertController(title: "Create New Workout", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(workoutName: UITextField!) in
            workoutName.placeholder = "Enter workout name:"
        })
        alert.addTextField(configurationHandler: {(workoutCyclesCount: UITextField!) in
            workoutCyclesCount.placeholder = "Enter number of cycles (in weeks):"
        })
        
        alert.addTextField(configurationHandler: {(workoutTabCount: UITextField!) in
            workoutTabCount.placeholder = "Enter number of workouts per week:"
        })
        
        for okText in alert.textFields! {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object:okText,
            queue: OperationQueue.main) { (notification) -> Void in
                self.validateFields(alert: alert)
               }
        }
        
        let okButton1 = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let workoutNameTextField = alert.textFields![0] as UITextField
            let workoutCyclesCountTextField = alert.textFields![1] as UITextField
            let workoutTabCountTextField = alert.textFields![2] as UITextField
            
            let workoutName = workoutNameTextField.text!
            let workoutCyclesCount = Int(workoutCyclesCountTextField.text!)
            
            let secondAlert = UIAlertController(title: "Create Tabs for " + workoutName, message: "Message", preferredStyle: UIAlertControllerStyle.alert)

            if let workoutTabCount = Int(workoutTabCountTextField.text!) {
                for index in 1...workoutTabCount {
                    secondAlert.addTextField(configurationHandler: {(workoutTabName: UITextField!) in
                        workoutTabName.placeholder = "Enter name for tab " + String(index) + ": "
                    })
                    secondAlert.addTextField(configurationHandler: {(workoutTabExerciseCount: UITextField!) in
                        workoutTabExerciseCount.placeholder = "Enter number of exercises for tab " + String(index) + ": "
                    })
                    
                }
            }
            
            let okButton2 = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
                var tabString = ""
                var firstTab = ""
                for field in secondAlert.textFields! {
                    let index = secondAlert.textFields?.index(of: field)
                    if index! % 2 == 0 {
                        let tabName = field.text!
                        firstTab = firstTab.isEmpty ? tabName : firstTab
                        tabString += tabString.isEmpty ? tabName : "," + field.text!
                        self.defaultStorage.set(1, forKey: workoutName + tabName + "WorkoutWeekCount")
                        self.defaultStorage.set(workoutCyclesCount, forKey: workoutName + tabName + "WorkoutWeekMax")
                    } else {
                        let tabExerciseCount = Int(field.text!)
                        self.defaultStorage.set(tabExerciseCount, forKey: workoutName + secondAlert.textFields![index! - 1].text! + "ExerciseCount")
                    }
                }
                self.defaultStorage.set(tabString, forKey: workoutName + "TabString")
                self.defaultStorage.set(firstTab, forKey: workoutName + "FirstTab")
            })
            
            for okText in secondAlert.textFields! {
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object:okText,
                queue: OperationQueue.main) { (notification) -> Void in
                    self.validateFields(alert: secondAlert)
                   }
            }
            
            okButton2.isEnabled = false;
            secondAlert.addAction(okButton2);

            self.present(secondAlert, animated: true, completion: nil)
            
            self.newButtonText = workoutName
            let button = WorkoutButtonView(frame: CGRect(x: 50, y: yValue, width: Int(self.view.frame.size.width - 150), height: self.yValueAdjustment - 10))
            button.setImage(#imageLiteral(resourceName: "barbell-clipart-no-background-3.png"), for: .normal)
            button.setTitle("customWorkoutButton" + String(buttonNumber), for: .normal)
            button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)

            let textWidth = Int(button.frame.size.width / 2)
            let text = WorkoutTextView(frame: CGRect(x: Int(button.center.x) - Int(textWidth / 2), y:yValue - 5, width: textWidth , height: Int(button.frame.size.height / 3)))
            text.text = self.newButtonText
            text.textAlignment = NSTextAlignment.center

            self.customWorkoutNames.append(text)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.customWorkoutNames)
            self.defaultStorage.set(encodedData, forKey: "customWorkoutNames")
            self.defaultStorage.synchronize()

            let deleteButton = WorkoutDeleteButtonView(frame: CGRect(x: Int(button.frame.maxX) + 10, y: yValue, width: 25, height: 25))
            deleteButton.setImage(#imageLiteral(resourceName: "deleteButton.png"), for: .normal)
            deleteButton.setTitle("deleteButton" + String(buttonNumber), for: .normal)
            deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: .touchUpInside)

            self.buttonToDeleteButtonMap[deleteButton] = button
            self.buttonToTextMap[button] = text

            self.scrollView.addSubview(button)
            self.scrollView.addSubview(text)
            self.scrollView.addSubview(deleteButton)
            self.reloadAllWorkoutButtons()

        })
        okButton1.isEnabled = false;
        alert.addAction(okButton1)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadButton(buttonNumber: Int!, textValue: String!, yValue: Int!) {
        let button = WorkoutButtonView(frame: CGRect(x: 50, y: yValue, width: Int(self.view.frame.size.width - 150), height: yValueAdjustment - 10))
        button.setImage(#imageLiteral(resourceName: "barbell-clipart-no-background-3.png"), for: .normal)
        button.setTitle("customWorkoutButton" + String(buttonNumber), for: .normal)
        button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            
        let textWidth = Int(button.frame.size.width / 2)
        let text = WorkoutTextView(frame: CGRect(x: Int(button.center.x) - Int(textWidth / 2), y:yValue - 5, width: textWidth , height: Int(button.frame.size.height / 3)))
        text.text = textValue
        text.textAlignment = NSTextAlignment.center
        text.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let deleteButton = WorkoutDeleteButtonView(frame: CGRect(x: Int(button.frame.maxX) + 10, y: yValue, width: 25, height: 25))
        deleteButton.setImage(#imageLiteral(resourceName: "deleteButton.png"), for: .normal)
        deleteButton.setTitle("deleteButton" + String(buttonNumber), for: .normal)
        deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: .touchUpInside)
        
        self.buttonToDeleteButtonMap[deleteButton] = button
        self.buttonToTextMap[button] = text
        
        self.scrollView.addSubview(button)
        self.scrollView.addSubview(text)
        self.scrollView.addSubview(deleteButton)

    }
    
    func autoFitButtonLabel(button: UIButton) {
        button.titleLabel?.minimumScaleFactor = 0.25
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.titleLabel?.numberOfLines = 2
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateFields(alert: UIAlertController!) {
        var valid = true
        for field in alert.textFields! {
            if (!field.hasText) {
                valid = false
            }
        }
        alert.actions[0].isEnabled = valid
    }
}
