//
//  ViewController.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 7/28/17.
//  Copyright © 2017 Matthew Jackson. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet var exerciseTableView: UITableView!
    @IBOutlet weak var weightDate: UITextField!
    @IBOutlet weak var previousDate: UITextField!
    @IBOutlet weak var workoutWeekCounterText: UITextField!
    @IBOutlet weak var pageHeaderText: UITextField!
    @IBOutlet weak var exerciseHeaderText: UILabel!
    @IBOutlet weak var previousHeaderText: UILabel!
    @IBOutlet weak var weightHeaderText: UILabel!
    @IBOutlet weak var editExercisesButton: UIButton!
    @IBOutlet weak var exerciseTableTextField: UITextField!
    @IBOutlet weak var saveExercisesButton: UIButton!
    @IBOutlet weak var setsAndRepsHeaderText: UILabel!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var backToCustomWorkoutsButton: UIButton!
    @IBOutlet weak var addNewExerciseButton: UIButton!
    @IBOutlet weak var editWeekInfoButton: UIButton!
    @IBOutlet weak var newTabButton: UIButton!
    @IBAction func newTabButtonClick(_ sender: Any) {
        self.createNewTab()
    }
    
    var tabArray = [WorkoutButtonView]()
    var tabDeleteArray = [UIButton]()
    var tabDeleteToTabMap = [UIButton:WorkoutButtonView]()
    
    var buttonText: String!
    let defaultStorage = UserDefaults.standard
    var todayString: String!
    var previousString: String!
    var fromCustomMenu = false
    var tabText = "Back and Biceps"
    var dateHasChanged: Bool!
    var updatedForDateChange: Bool!
    var isInEditMode = false
    var workoutWeek: Int!
    var workoutWeekMax: Int!
//    var weekHasBeenUpdated: Bool! = false
    var hideCellAllowed: Bool! = false
    var currentTab: WorkoutButtonView!
    
    @IBAction func editExercisesButtonClicked(_ sender: Any) {
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseViewCell>
        isInEditMode = true
        
        editWeekInfoButton.isHidden = false
        workoutWeekCounterText.isHidden = true
        
        for cell in cells {
            cell.exercise.isHidden = true
            cell.exerciseButton.isHidden = false;
            cell.previousWeight.isUserInteractionEnabled = true
            cell.previousWeight.backgroundColor = UIColor.lightGray
            cell.weight.isUserInteractionEnabled = true
            cell.weight.backgroundColor = UIColor.lightGray
            cell.setsAndReps.isUserInteractionEnabled = true
            cell.setsAndReps.backgroundColor = UIColor.lightGray
            cell.deleteButton.isHidden = false
        }
        
        for deleteTabButton in tabDeleteArray {
            deleteTabButton.isHidden = false
            deleteTabButton.superview?.bringSubview(toFront: deleteTabButton)
        }
        
        newTabButton.isHidden = false
        
        addNewExerciseButton.isHidden = false
        
        editExercisesButton.isHidden = true
        saveExercisesButton.isHidden = false
    }
    
    @IBAction func addNewExercise(_ sender: Any) {
        var rowCount = defaultStorage.object(forKey: self.buttonText + tabText + "ExerciseCount") as! Int

        rowCount += 1
        if rowCount > 9 {
            self.sendTooManyExercisesAlert()
        } else {
            defaultStorage.set(rowCount, forKey: self.buttonText + tabText + "ExerciseCount")
            self.exerciseTableView.reloadData()
            self.editExercisesButtonClicked(self)
        }
    }
    
    @IBAction func saveEditedExercises(_ sender: Any) {
        isInEditMode = false
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseViewCell>
        var i = 1
        
        workoutWeekCounterText.isHidden = false
        editWeekInfoButton.isHidden = true
        
        for cell in cells {
            cell.exercise.isHidden = false
            cell.exerciseButton.isHidden = true;
            cell.previousWeight.isUserInteractionEnabled = false
            cell.previousWeight.backgroundColor = UIColor.white
            cell.weight.backgroundColor = UIColor.white
            cell.setsAndReps.isUserInteractionEnabled = false
            cell.setsAndReps.backgroundColor = UIColor.white
            
            defaultStorage.set(cell.exercise.text, forKey: buttonText + tabText + String(i) + "ExerciseName")
            defaultStorage.set(cell.setsAndReps.text, forKey: buttonText + tabText + cell.exercise.text + "SetsAndReps")
            defaultStorage.set(cell.previousWeight.text, forKey: buttonText + tabText + cell.exercise.text + "PreviousWeight")
            defaultStorage.set(cell.weight.text, forKey: buttonText + tabText + cell.exercise.text + "Weight")
            
            i += 1
        }
        
        for deleteTabButton in tabDeleteArray {
            deleteTabButton.isHidden = true
        }
        
        newTabButton.isHidden = true
        
        addNewExerciseButton.isHidden = true
        editExercisesButton.isHidden = false
        saveExercisesButton.isHidden = true
        
        self.exerciseTableView.reloadData()
    }
    
    @IBAction func editWeekInfoButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title:"Edit Week Count Information", message: "Please enter the new week count information.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(newWeekCount: UITextField!) in
            newWeekCount.placeholder = "Enter current week number (as integer):"
        })
        alert.addTextField(configurationHandler: {(newWeekMax: UITextField!) in
            newWeekMax.placeholder = "Enter total weeks in workout (as an integer):"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let newWeekCountField = alert.textFields![0] as UITextField
            let newWeekCountFieldInt: Int! = Int(newWeekCountField.text!)
            let newWeekMaxField = alert.textFields![1] as UITextField
            let newWeekMaxFieldInt: Int! = Int(newWeekMaxField.text!)
            self.defaultStorage.set(newWeekCountFieldInt, forKey: self.buttonText + self.tabText + "WorkoutWeekCount")
            self.defaultStorage.set(newWeekMaxFieldInt, forKey: self.buttonText + self.tabText + "WorkoutWeekMax")
            
            self.workoutWeekCounterText.text = "Week: " + String(newWeekCountFieldInt) + " / " + String(newWeekMaxFieldInt)
            
            self.loadTabWorkouts(sender: self.currentTab)


        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseTableView.dataSource = self
        
        self.autoFitButtonLabel(button: editExercisesButton)
        self.autoFitButtonLabel(button: saveExercisesButton)
        self.autoFitButtonLabel(button: backToMenuButton)
        self.autoFitButtonLabel(button: backToCustomWorkoutsButton)
        self.autoFitButtonLabel(button: addNewExerciseButton)

        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(gestureRecognizer: )))
        exerciseTableView.addGestureRecognizer(longpress)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        dateHasChanged = defaultStorage.bool(forKey: "dateHasChanged")
        
        exerciseTableView.isScrollEnabled = true
        
        updatedForDateChange = defaultStorage.bool(forKey: "hasBeenUpdated")
        
        let firstTab = defaultStorage.string(forKey: buttonText + "FirstTab")
        tabText = (firstTab == nil) ? tabText : firstTab!
        defaultStorage.set(tabText, forKey: "tabText")
        
        weightDate.isHidden = true
        previousDate.isHidden = true
    
        editExercisesButton.isHidden = false
        saveExercisesButton.isHidden = true
        
        weightHeaderText.isUserInteractionEnabled = false
        formatBorder(cell: weightHeaderText)
        
        previousHeaderText.isUserInteractionEnabled = false
        formatBorder(cell: previousHeaderText)

        exerciseHeaderText.isUserInteractionEnabled = false
        formatBorder(cell: exerciseHeaderText)
        
        setsAndRepsHeaderText.isUserInteractionEnabled = false
        formatBorder(cell: setsAndRepsHeaderText)
        
        exerciseTableView.allowsSelection = false
        
        pageHeaderText.text = buttonText
        pageHeaderText.isUserInteractionEnabled = false
        
//        let todayDb = defaultStorage.object(forKey: "todayDate") as! String
//        let previousDateDb = defaultStorage.object(forKey: "previousDate") as! String
////        weightDate.text = todayDb
////        previousDate.text = previousDateDb
//        todayString = todayDb
//        previousString = previousDateDb
        
        backToCustomWorkoutsButton.isHidden = true
        backToMenuButton.isHidden = false
        if fromCustomMenu {
            backToCustomWorkoutsButton.isHidden = false
            backToMenuButton.isHidden = true
        }
        
        workoutWeek = defaultStorage.integer(forKey: buttonText + tabText + "WorkoutWeekCount")
        workoutWeekMax = defaultStorage.integer(forKey: buttonText + tabText + "WorkoutWeekMax")
        
        let tabString = defaultStorage.string(forKey: buttonText + "TabString")
        let tabArray = (tabString?.components(separatedBy: ","))! as [String]
        let tabCount = (tabArray.count) as Int
        var xValue = 12

        if tabCount != 0 {
            for tabIndex in 1...tabCount {
                let width = Int(( (self.view.frame.width - 24) / CGFloat(tabCount) ) - 2)
                createTabButton(xValue: xValue, buttonTitle: tabArray[tabIndex - 1], width: width)
                if !updatedForDateChange {
                    defaultStorage.set(dateHasChanged, forKey: buttonText + tabArray[tabIndex - 1] + "DateChange")
                    defaultStorage.set(false, forKey: buttonText + tabArray[tabIndex - 1] + "WeekHasBeenUpdated")
                }
                xValue = xValue + width + 2
            }
        }
        
        newTabButton.center.y = (self.tabDeleteToTabMap.first?.value.frame.minY)! - (0.5 * newTabButton.frame.height) - 5
        newTabButton.center.x = 12 + (0.5 * newTabButton.frame.width)
        newTabButton.layer.cornerRadius = 8
        newTabButton.isHidden = true
    
        
        workoutWeekCounterText.text = "Week: " + String(workoutWeek) + " / " + String(workoutWeekMax)
        workoutWeekCounterText.isUserInteractionEnabled = false
        editWeekInfoButton.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func formatBorder(cell: UILabel) {
        cell.layer.cornerRadius = 4
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultStorage.object(forKey: self.buttonText + tabText + "ExerciseCount") as! Int
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseID = "exerciseViewCell"
    
        let cell: ExerciseViewCell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! ExerciseViewCell
        
        cell.setsAndReps.text = defaultStorage.string(forKey: buttonText + tabText + cell.exercise.text + "SetsAndReps")
        cell.previousWeight.text = defaultStorage.string(forKey: buttonText + tabText + cell.exercise.text + "PreviousWeight")
        cell.weight.text = defaultStorage.string(forKey: buttonText + tabText + cell.exercise.text + "Weight")
        
        if isInEditMode {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        cell.deleteButton.addTarget(self, action: #selector(self.removeExercise), for: .touchUpInside)
               
        let exerciseText = defaultStorage.string(forKey: buttonText + tabText + String((indexPath as NSIndexPath).row + 1) + "ExerciseName")
        if exerciseText != nil {
            let attributedString = NSMutableAttributedString(string: exerciseText!)
            let storedValue = defaultStorage.string(forKey: exerciseText!)
            if (storedValue != nil && storedValue != "") {
                let url = URL(string: storedValue!)
                attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))
                cell.exercise.attributedText = attributedString
                cell.exercise.isUserInteractionEnabled = true
            }
        } else {
            cell.exercise.attributedText = NSMutableAttributedString(string: "")
        }
        cell.exercise.text = exerciseText
        cell.exercise.textAlignment = NSTextAlignment.center
        
        cell.exerciseButton.setTitle(cell.exercise.text, for: .normal)
        cell.exerciseButton.addTarget(self, action: #selector(self.editExerciseInfo), for: .touchDown)
        return cell
    }
    
    @objc func editExerciseInfo(sender: UIButton) {
        let alert = UIAlertController(title:"Edit Exercise Information", message: "Please update the exercise information.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(exerciseName: UITextField!) in
            exerciseName.text = sender.titleLabel?.text
        })
        alert.addTextField(configurationHandler: {(exerciseUrl: UITextField!) in
            exerciseUrl.text = self.defaultStorage.string(forKey: (sender.titleLabel?.text!)!)
        })
        
        let cell = sender.superview?.superview as? ExerciseViewCell
        var table = cell?.superview?.superview as? UITableView
        if table == nil {
            table = cell?.superview as? UITableView
        }
        let index: Int! = table?.indexPath(for: cell!)?.row
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let newExerciseName = alert.textFields![0].text
            let newExerciseUrl = alert.textFields![1].text
            
            self.defaultStorage.set(newExerciseUrl, forKey: (sender.titleLabel?.text!)!)
            self.defaultStorage.set(newExerciseName, forKey: (self.buttonText + self.tabText + String(index + 1) + "ExerciseName"))
            
            self.loadTabWorkouts(sender: self.currentTab)
            self.exerciseTableView.reloadData()
        } ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        let cell = cell as! ExerciseViewCell
        let dateChangeUpdate = defaultStorage.bool(forKey: buttonText + tabText + "DateChange")
        
        if (dateHasChanged && dateChangeUpdate){
            updateForDateChange(cell: cell)
        }
        if indexPath.row == lastRowIndex - 1 {
            updatedForDateChange = true
            defaultStorage.set(true, forKey: "hasBeenUpdated")
            defaultStorage.set(false, forKey: buttonText + tabText + "DateChange")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func getShortDate(date: Date) -> String {
        let dF = DateFormatter()
        dF.timeStyle = DateFormatter.Style.none
        dF.dateStyle = DateFormatter.Style.short
        let shortDate = dF.string(from: date)
        return shortDate
    }
    
    func createTabButton(xValue: Int, buttonTitle: String, width: Int) {
        let height = Int(super.view.frame.height / 18)
        let yvalue = self.exerciseHeaderText.frame.minY - CGFloat( height ) - 5
//        let button = WorkoutButtonView(frame: CGRect(x: xValue, y: Int(yvalue), width: width, height: 40))
        let button = WorkoutButtonView(frame: CGRect(x: xValue, y: Int(yvalue), width: width, height: height ))
        if buttonTitle == self.tabText {
            button.backgroundColor = UIColor.darkGray
            self.currentTab = button
        } else {
            button.backgroundColor = UIColor.lightGray
        }
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.loadTabWorkouts), for: .touchUpInside)
        self.autoFitButtonLabel(button: button)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        
        tabArray.append(button)
        
        let deleteTabButton = UIButton(frame: CGRect(x: xValue + Int(button.frame.width) - 20, y: 75, width: 20, height: 20))
        deleteTabButton.setImage(#imageLiteral(resourceName: "deleteButton.png"), for: .normal)
        deleteTabButton.setTitle("deleteButton" + String(buttonTitle), for: .normal)
        deleteTabButton.addTarget(self, action: #selector(self.deleteTabButtonAction), for: .touchUpInside)
        if self.isInEditMode {
            deleteTabButton.isHidden = false
        } else {
            deleteTabButton.isHidden = true
        }
        tabDeleteArray.append(deleteTabButton)
        
        tabDeleteToTabMap[deleteTabButton] = button
         
        self.view.addSubview(button)
        self.view.addSubview(deleteTabButton)
    }
    
    @objc func loadTabWorkouts(sender: WorkoutButtonView) {
        self.resetTabColor()
        sender.backgroundColor = UIColor.darkGray
        self.currentTab = sender
        self.tabText = (sender.titleLabel?.text)!
        defaultStorage.set(tabText, forKey: "tabText")
        
        workoutWeek = defaultStorage.integer(forKey: buttonText + tabText + "WorkoutWeekCount")
        workoutWeekMax = defaultStorage.integer(forKey: buttonText + tabText + "WorkoutWeekMax")
        
        workoutWeekCounterText.text = "Week: " + String(workoutWeek) + " / " + String(workoutWeekMax)
        
        self.exerciseTableView.reloadData()
        if isInEditMode {
            self.editExercisesButtonClicked(self)
        } else {
            self.saveEditedExercises(self)
        }
    }
    
    @objc func deleteTabButtonAction(sender: UIButton) {
        let tabToDeleteText = self.tabDeleteToTabMap[sender]?.titleLabel?.text
        let alert = UIAlertController(title: "Delete " + tabToDeleteText! + "?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let tabButton = self.tabDeleteToTabMap[sender]!
            
            let tabString = self.defaultStorage.string(forKey: self.buttonText + "TabString")
            var tabArray = (tabString?.components(separatedBy: ","))! as [String]
            tabArray.remove(at: tabArray.index(of: (tabButton.titleLabel?.text)!)!)
            var newTabString = ""
            for tab in tabArray {
                newTabString = newTabString.isEmpty ? tab : newTabString + "," + tab
            }
            
            let tabCount = (tabArray.count) as Int
            for tabButton in self.tabDeleteToTabMap {
                tabButton.key.removeFromSuperview()
                tabButton.value.removeFromSuperview()
                self.tabDeleteToTabMap.remove(at: self.tabDeleteToTabMap.index(forKey: tabButton.key)!)
            }
            
            var xValue = 12
            if tabCount != 0 {
                for tabIndex in 1...tabCount {
                    let width = Int(( (self.view.frame.width - 24) / CGFloat(tabCount) ) - 2)
//                    let width = (340 / tabCount) - 2
                    self.createTabButton(xValue: xValue, buttonTitle: tabArray[tabIndex - 1], width: width)
                    if !self.updatedForDateChange {
                        self.defaultStorage.set(self.dateHasChanged, forKey: self.buttonText + tabArray[tabIndex - 1] + "DateChange")
                    }
                    xValue = xValue + width + 2
                }
            }
            
            if self.tabText == tabToDeleteText {
                self.tabText = tabArray.first!
                self.exerciseTableView.reloadData()
            }
            
            self.defaultStorage.set(newTabString, forKey: self.buttonText + "TabString")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateForDateChange(cell: ExerciseViewCell) {
        let newPreviousWeightText = defaultStorage.string(forKey: buttonText + tabText + cell.exercise.text + "Weight")
        var weightsUpdated: Bool = false
        if (!((newPreviousWeightText?.isEmpty)!) && ((newPreviousWeightText != nil))) {
            cell.previousWeight.text = newPreviousWeightText
            defaultStorage.set(newPreviousWeightText, forKey: buttonText + tabText + cell.exercise.text + "PreviousWeight")
            weightsUpdated = true
        }
        cell.weight.text = ""
        defaultStorage.set("", forKey: buttonText + tabText + cell.exercise.text + "Weight")
        let weekHasBeenUpdated = self.defaultStorage.bool(forKey: buttonText + tabText + "WeekHasBeenUpdated")
        
        if weightsUpdated && !weekHasBeenUpdated {
            workoutWeek = workoutWeek + 1
            self.defaultStorage.set(workoutWeek, forKey: self.buttonText + self.tabText + "WorkoutWeekCount")
            if workoutWeek > workoutWeekMax {
                self.completedWeekCountAlert()
            }
//            weekHasBeenUpdated = true
            self.defaultStorage.set(true, forKey: buttonText + tabText + "WeekHasBeenUpdated")
            workoutWeekCounterText.text = "Week: " + String(workoutWeek) + " / " + String(workoutWeekMax)
        }
    }
    
    @objc func removeExercise(sender: UIButton!) {
        let cell = sender.superview?.superview as? ExerciseViewCell
        var table = cell?.superview?.superview as? UITableView
        if table == nil {
            table = cell?.superview as? UITableView
        }
        let index: Int! = table?.indexPath(for: cell!)?.row
        var rowCount = defaultStorage.object(forKey: self.buttonText + tabText + "ExerciseCount") as! Int
        
        for i in 0 ..< rowCount {
            if i == index {
                //Do nothing to delete this row
            }
            else if i > index {
                let prevRow = defaultStorage.string(forKey: buttonText + tabText + String(i + 1) + "ExerciseName")
                defaultStorage.set(prevRow, forKey: buttonText + tabText + String(i) + "ExerciseName")
            }
        }
        defaultStorage.removeObject(forKey: buttonText + tabText + String(rowCount) + "ExerciseName")

        rowCount -= 1
        defaultStorage.set(rowCount, forKey: self.buttonText + tabText + "ExerciseCount")
        self.exerciseTableView.reloadData()
        self.editExercisesButtonClicked(self)
    }
    
    func exitEditMode() {
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseViewCell>
        isInEditMode = true
        
        for cell in cells {
            cell.exercise.isUserInteractionEnabled = false
            cell.exercise.backgroundColor = UIColor.white
            cell.previousWeight.isUserInteractionEnabled = false
            cell.previousWeight.backgroundColor = UIColor.white
            cell.weight.isUserInteractionEnabled = false
            cell.weight.backgroundColor = UIColor.white
            cell.setsAndReps.isUserInteractionEnabled = false
            cell.setsAndReps.backgroundColor = UIColor.white
            cell.deleteButton.isHidden = true
        }
        
        addNewExerciseButton.isHidden = true
        
        editExercisesButton.isHidden = false
        saveExercisesButton.isHidden = true

    }
    
    func sendTooManyExercisesAlert() {
        let alert = UIAlertController(title:"Error: Too Many Exercises", message: "You cannot add more than 9 exercises to a workout.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func completedWeekCountAlert() {
        let alert = UIAlertController(title:"Congratulations!", message: "You completed all of the weeks for this cycle of this exercise! Resetting the week count.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            self.workoutWeek = 1
            self.defaultStorage.set(1, forKey: self.buttonText + self.tabText + "WorkoutWeekCount")
            self.workoutWeekCounterText.text = "Week: " + String(self.workoutWeek) + " / " + String(self.workoutWeekMax)
        } ))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.exerciseTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.exerciseTableView.contentInset = contentInset
        exerciseTableView.scrollToNearestSelectedRow(at: UITableViewScrollPosition.middle, animated: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.exerciseTableView.contentInset = contentInset
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: exerciseTableView)
        let indexPath = exerciseTableView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath as NSIndexPath?
                let cell = exerciseTableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshopOfCell(inputView: cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                exerciseTableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                    
                }, completion: { (finished) -> Void in
                    if finished && self.hideCellAllowed {
                        cell?.isHidden = true
                    }
                })
            }
        case .changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath! as IndexPath)) {
                exerciseTableView.moveRow(at: Path.initialIndexPath! as IndexPath, to: indexPath!)
                self.saveReorderedTable()
                Path.initialIndexPath = indexPath! as NSIndexPath
                
            }
        default:
            self.hideCellAllowed = false
            let cell = exerciseTableView.cellForRow(at: Path.initialIndexPath! as IndexPath) as UITableViewCell!
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = (cell?.center)!
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapshot!.removeFromSuperview()
                    My.cellSnapshot = nil
                }
            })
        }
    }

    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize.init(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func saveReorderedTable() {
        let cells = self.exerciseTableView.visibleCells as! Array<ExerciseViewCell>
        for cell in cells {
            let index = exerciseTableView.indexPath(for: cell)?.row
            defaultStorage.set(cell.exercise.text, forKey: buttonText + tabText + String(index! + 1) + "ExerciseName")
        }
        
        self.exerciseTableView.reloadData()
    }
    
    func createNewTab() {
        let alert = UIAlertController(title:"Add new tab", message: "Adding a new tab to this workout.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(newTabName: UITextField!) in
            newTabName.placeholder = "Enter new tab name:"
        })
        alert.addTextField(configurationHandler: {(newTabExerciseCount: UITextField!) in
            newTabExerciseCount.placeholder = "Enter number of exercises in workout:"
        })
        alert.addTextField(configurationHandler: {(newTabWeekCount: UITextField!) in
            newTabWeekCount.placeholder = "Enter number of weeks in cycle:"
        })
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            let newTabNameField = alert.textFields![0] as UITextField
            let newTabExercisesField = alert.textFields![1] as UITextField
            let newTabWeekCountField = alert.textFields![2] as UITextField
            let newTabName = newTabNameField.text
            let newTabExercises = Int(newTabExercisesField.text!)
            let newTabWeekCount = Int(newTabWeekCountField.text!)
            
            self.defaultStorage.set(1, forKey: self.buttonText + newTabName! + "WorkoutWeekCount")
            self.defaultStorage.set(newTabWeekCount, forKey: self.buttonText + newTabName! + "WorkoutWeekMax")
            
            var tabString = self.defaultStorage.string(forKey: self.buttonText + "TabString")!
            if (tabString.range(of: newTabName!) != nil) {
                self.tabExistsErrorMessage(tabName: newTabName!)
                return
            }
            
            tabString = (tabString.isEmpty ? newTabName : tabString + "," + newTabName!)!
            var tabArray = (tabString.components(separatedBy: ",")) as [String]
            
            let tabCount = (tabArray.count) as Int
            for tabButton in self.tabDeleteToTabMap {
                tabButton.key.removeFromSuperview()
                tabButton.value.removeFromSuperview()
                self.tabDeleteToTabMap.remove(at: self.tabDeleteToTabMap.index(forKey: tabButton.key)!)
            }
            
            var xValue = 12
            if tabCount != 0 {
                for tabIndex in 1...tabCount {
                    let width = Int(( (self.view.frame.width - 24) / CGFloat(tabCount) ) - 2)
//                    let width = (340 / tabCount) - 2
                    self.createTabButton(xValue: xValue, buttonTitle: tabArray[tabIndex - 1], width: width)
                    if !self.updatedForDateChange {
                        self.defaultStorage.set(self.dateHasChanged, forKey: self.buttonText + tabArray[tabIndex - 1] + "DateChange")
                    }
                    xValue = xValue + width + 2
                }
            }
            
            self.defaultStorage.set(tabString, forKey: self.buttonText + "TabString")
            self.defaultStorage.set(newTabExercises, forKey: self.buttonText + newTabName! + "ExerciseCount")
            
        } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tabExistsErrorMessage(tabName: String) {
        let alert = UIAlertController(title:"Tab Already Exists!", message: "There is already a tab named " + tabName + ". Please try again with a new name.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func autoFitButtonLabel(button: UIButton) {
        button.titleLabel?.minimumScaleFactor = 0.25
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.titleLabel?.numberOfLines = 2
    }
    
    func resetTabColor() {
        for tab in tabArray {
            tab.backgroundColor = UIColor.lightGray
        }
    }
        
}

