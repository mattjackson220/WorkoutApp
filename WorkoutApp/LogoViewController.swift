//
//  ViewController.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 7/28/17.
//  Copyright © 2017 Matthew Jackson. All rights reserved.
//

import UIKit

class LogoViewController: UIViewController {
    
    var toningBackAndBicepsMap = [String: String]()
    var toningBackAndBicepsMap2 = [String: String]()
    var bulkingBackAndBicepsMap = [String: String]()
    var intBackAndBiceps15Map = [String: String]()
    var intBackAndBiceps12Map = [String: String]()
    
    var toningChestAndTricepsMap = [String: String]()
    var toningChestAndTricepsMap2 = [String: String]()
    var bulkingChestAndTricepsMap = [String: String]()
    var intChestAndTriceps15Map = [String: String]()
    var intChestAndTriceps12Map = [String: String]()
    
    var bulkingLegsMap = [String:String]()
    var toningLegsMap = [String:String]()
    var toningLegsMap2 = [String:String]()
    var intLegs15Map = [String:String]()
    var intLegs12Map = [String:String]()
    
    var bulkingShouldersMap = [String:String]()
    var intShoulders15Map = [String:String]()
    var intShoulders12Map = [String:String]()
    
    var toningExercisesMap = [String:[String:String]]()
    var toningExercisesMap2 = [String:[String:String]]()
    var bulkingExercisesMap = [String:[String:String]]()
    var intExercises15Map = [String:[String:String]]()
    var intExercises12Map = [String:[String:String]]()
    
    var helpLinkMap = [String:String]()
    
    var tabString = ""
    let defaultStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delete all history
//        if let bundle = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundle)
//        }
        
        self.loadDefaultWorkoutMaps()
        
        toningExercisesMap["Back and Biceps"] = toningBackAndBicepsMap
        toningExercisesMap["Chest and Triceps"] = toningChestAndTricepsMap
        toningExercisesMap["Legs"] = toningLegsMap
        
        toningExercisesMap2["Back and Biceps"] = toningBackAndBicepsMap2
        toningExercisesMap2["Chest and Triceps"] = toningChestAndTricepsMap2
        toningExercisesMap2["Legs"] = toningLegsMap2

        bulkingExercisesMap["Back and Biceps"] = bulkingBackAndBicepsMap
        bulkingExercisesMap["Chest and Triceps"] = bulkingChestAndTricepsMap
        bulkingExercisesMap["Legs"] = bulkingLegsMap
        bulkingExercisesMap["Shoulders"] = bulkingShouldersMap
        
        intExercises15Map["Back and Biceps"] = intBackAndBiceps15Map
        intExercises15Map["Chest and Triceps"] = intChestAndTriceps15Map
        intExercises15Map["Legs"] = intLegs15Map
        intExercises15Map["Shoulders"] = intShoulders15Map

        intExercises12Map["Back and Biceps"] = intBackAndBiceps12Map
        intExercises12Map["Chest and Triceps"] = intChestAndTriceps12Map
        intExercises12Map["Legs"] = intLegs12Map
        intExercises12Map["Shoulders"] = intShoulders12Map

        
//        defaultStorage.set("", forKey: "todayDate")
//        defaultStorage.set("", forKey: "previousDate")

        
        let today = Date()
        let todayString = getShortDate(date: today)
        let previousTodayDb = defaultStorage.object(forKey: "todayDate")
        var previousTodayString = todayString
        defaultStorage.set(false, forKey: "dateHasChanged")
        
        if (previousTodayDb != nil) {
            let previousTodayDBString = previousTodayDb as! String
            previousTodayString = previousTodayDBString
        } else {
            defaultStorage.set(todayString, forKey: "todayDate")
        }
        
        if previousTodayString != todayString {
            defaultStorage.set(todayString, forKey: "todayDate")
            defaultStorage.set(previousTodayString, forKey: "previousDate")
            defaultStorage.set(true, forKey: "dateHasChanged")
            defaultStorage.set(false, forKey: "hasBeenUpdated")
        }
        
        let toningHasBeenInitialized = defaultStorage.bool(forKey: "Toning1")
        if (!toningHasBeenInitialized) {
                tabString = ""
                for exercise in toningExercisesMap {
                    let initializeToningDbList = initializeExercises(exerciseMap: exercise.value)
                    defaultStorage.set(true, forKey: "Toning1")
                    self.loadRowForExercises(exerciseList: initializeToningDbList, exerciseTitle: "Toning", tabTitle: exercise.key, weekCount: 4)
                    tabString = tabString.isEmpty ? exercise.key : tabString + "," + exercise.key
                }
            defaultStorage.set(tabString, forKey: "ToningTabString")
        }
        
        let toning2HasBeenInitialized = defaultStorage.bool(forKey: "Toning2")
        if (!toning2HasBeenInitialized) {
            tabString = ""
            for exercise in toningExercisesMap2 {
                let initializeToningDbList = initializeExercises(exerciseMap: exercise.value)
                defaultStorage.set(true, forKey: "Toning2")
                self.loadRowForExercises(exerciseList: initializeToningDbList, exerciseTitle: "Toning2", tabTitle: exercise.key, weekCount: 4)
                tabString = tabString.isEmpty ? exercise.key : tabString + "," + exercise.key
            }
            defaultStorage.set(tabString, forKey: "Toning2TabString")
        }
        
        let bulkingHasBeenInitialized = defaultStorage.bool(forKey: "Bulking1")
        if (!bulkingHasBeenInitialized) {
                tabString = ""
                for exercise in bulkingExercisesMap {
                    let initializeBulkingDbList = initializeExercises(exerciseMap: exercise.value)
                    defaultStorage.set(true, forKey: "Bulking1")
                    self.loadRowForExercises(exerciseList: initializeBulkingDbList, exerciseTitle: "Bulking", tabTitle: exercise.key, weekCount: 8)
                    tabString = tabString.isEmpty ? exercise.key : tabString + "," + exercise.key
                }
                defaultStorage.set(tabString, forKey: "BulkingTabString")
        }
        
        let int15HasBeenInitialized = defaultStorage.bool(forKey: "Int15_1")
        if (!int15HasBeenInitialized) {
            tabString = ""
            for exercise in intExercises15Map {
                let initializeInt15DbList = initializeExercises(exerciseMap: exercise.value)
                defaultStorage.set(true, forKey: "Int15_1")
                self.loadRowForExercises(exerciseList: initializeInt15DbList, exerciseTitle: "Int15", tabTitle: exercise.key, weekCount: 6)
                tabString = tabString.isEmpty ? exercise.key : tabString + "," + exercise.key
            }
            defaultStorage.set(tabString, forKey: "Int15TabString")
        }
        
        let int12HasBeenInitialized = defaultStorage.bool(forKey: "Int12_1")
        if (!int12HasBeenInitialized) {
            tabString = ""
            for exercise in intExercises12Map {
                let initializeInt12DbList = initializeExercises(exerciseMap: exercise.value)
                defaultStorage.set(true, forKey: "Int12_1")
                self.loadRowForExercises(exerciseList: initializeInt12DbList, exerciseTitle: "Int12", tabTitle: exercise.key, weekCount: 6)
                tabString = tabString.isEmpty ? exercise.key : tabString + "," + exercise.key
            }
            defaultStorage.set(tabString, forKey: "Int12TabString")
        }
        
        let helpLinkBeenInitialized = defaultStorage.bool(forKey: "helpLink_1")
        if (!helpLinkBeenInitialized) {
            self.loadHelpLinks()
            for help in self.helpLinkMap {
                defaultStorage.set(help.value, forKey: help.key)
            }
            defaultStorage.set(true, forKey: "helpLink_1")
        }
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getShortDate(date: Date) -> String {
        let dF = DateFormatter()
//        dF.timeStyle = DateFormatter.Style.full // for testing to simulate day changes every load
        dF.dateStyle = DateFormatter.Style.short
        let shortDate = dF.string(from: date)
        return shortDate
    }
    
    func initializeExercises(exerciseMap: [String:String]) -> [TableRowObject] {
        var exerciseList: [TableRowObject] = []
        for exercise in exerciseMap {
            exerciseList.append(TableRowObject.init(exerciseName: exercise.key, previousWeight: "", weight: "", setsAndReps: exercise.value))
        }
        return exerciseList
    }
    
    func loadRowForExercises(exerciseList: [TableRowObject], exerciseTitle: String, tabTitle: String, weekCount: Int) {
        for i in 0 ..< exerciseList.count {
            let exerciseName = exerciseList[i].exerciseName
            let previousWeight = exerciseList[i].previousWeight
            let weight = exerciseList[i].weight
            let setsAndReps = exerciseList[i].setsAndReps
            defaultStorage.set(exerciseName, forKey: exerciseTitle + tabTitle + String(i+1) + "ExerciseName")
            defaultStorage.set(previousWeight, forKey: exerciseTitle + tabTitle + exerciseName + "PreviousWeight")
            defaultStorage.set(weight, forKey: exerciseTitle + tabTitle + exerciseName + "Weight")
            defaultStorage.set(setsAndReps, forKey: exerciseTitle + tabTitle + exerciseName + "SetsAndReps")
            defaultStorage.synchronize()
        }
        defaultStorage.set(exerciseList.count, forKey: exerciseTitle + tabTitle + "ExerciseCount")
        defaultStorage.set(weekCount, forKey: exerciseTitle + tabTitle + "WorkoutWeekMax")
        defaultStorage.set(1, forKey: exerciseTitle + tabTitle + "WorkoutWeekCount")
    }
    
    func loadHelpLinks() {
        helpLinkMap["Bench"] = "https://www.youtube.com/watch?v=gRVjAtPip0Y"
    }
    
    func loadDefaultWorkoutMaps() {
        // toning, bulking, and int back and biceps
        toningBackAndBicepsMap["Lat Pull Downs"] = "1 x 100"
        toningBackAndBicepsMap["Bent DB Rows"] = "3 x 25,20,15"
        toningBackAndBicepsMap["Rear Delt Flys"] = "1 x 100"
        toningBackAndBicepsMap["Seated Rows"] = "3 x 25,20,15"
        toningBackAndBicepsMap["Seated High Rows"] = "1 x 100"
        toningBackAndBicepsMap["Strive Curls"] = "3 x 25,20,15"
        toningBackAndBicepsMap["Hammer Curls"] = "1 x 100"
        
        toningBackAndBicepsMap2["Lat Pull Downs"] = "3 x 25,20,15"
        toningBackAndBicepsMap2["Bent DB Rows"] = "1 x 100"
        toningBackAndBicepsMap2["Rear Delt Flys"] = "3 x 25,20,15"
        toningBackAndBicepsMap2["Seated Rows"] = "1 x 100"
        toningBackAndBicepsMap2["Seated High Rows"] = "3 x 25,20,15"
        toningBackAndBicepsMap2["Strive Curls"] = "1 x 100"
        toningBackAndBicepsMap2["Hammer Curls"] = "3 x 25,20,15"
        
        bulkingBackAndBicepsMap["Deadlift"] = "3 x 8"
        bulkingBackAndBicepsMap["Rack Chins"] = "3 x 8"
        bulkingBackAndBicepsMap["Underhand Lat Pulldowns"] = "3 x 8"
        bulkingBackAndBicepsMap["DB Rows"] = "3 x 8"
        bulkingBackAndBicepsMap["Weighted Pull Ups"] = "3 x 8"
        bulkingBackAndBicepsMap["Incline DB Curls"] = "3 x 8"
        bulkingBackAndBicepsMap["DB Preacher Curls"] = "3 x 8"
        bulkingBackAndBicepsMap["Barbell Curls"] = "3 x 8"
        bulkingBackAndBicepsMap["Pinwheel Curls"] = "3 x 8"
        
        intBackAndBiceps15Map["Deadlift"] = "3 x 15"
        intBackAndBiceps15Map["Lat Pulldowns"] = "3 x 15"
        intBackAndBiceps15Map["DB Rows"] = "3 x 15"
        intBackAndBiceps15Map["Seated Rows"] = "3 x 15"
        intBackAndBiceps15Map["Strive Curls"] = "3 x 15"
        intBackAndBiceps15Map["Hammer Curls"] = "3 x 15"
        intBackAndBiceps15Map["Incline Curls"] = "3 x 15"
        
        intBackAndBiceps12Map["Deadlift"] = "3 x 12"
        intBackAndBiceps12Map["Lat Pulldowns"] = "3 x 12"
        intBackAndBiceps12Map["DB Rows"] = "3 x 12"
        intBackAndBiceps12Map["Seated Rows"] = "3 x 12"
        intBackAndBiceps12Map["Strive Curls"] = "3 x 12"
        intBackAndBiceps12Map["Hammer Curls"] = "3 x 12"
        intBackAndBiceps12Map["Incline Curls"] = "3 x 12"
        
        // toning and bulking chest and triceps
        toningChestAndTricepsMap["Bench"] = "1 x 100"
        toningChestAndTricepsMap["DB Incline"] = "3 x 25,20,15"
        toningChestAndTricepsMap["Cable Fly"] = "1 x 100"
        toningChestAndTricepsMap["Shoulder Press"] = "3 x 25,20,15"
        toningChestAndTricepsMap["Lateral Raises"] = "1 x 100"
        toningChestAndTricepsMap["Palms Down Triceps"] = "3 x 25,20,15"
        toningChestAndTricepsMap["Palms Up Triceps"] = "1 x 100"
        
        toningChestAndTricepsMap2["Bench"] = "3 x 25,20,15"
        toningChestAndTricepsMap2["DB Incline"] = "1 x 100"
        toningChestAndTricepsMap2["Cable Fly"] = "3 x 25,20,15"
        toningChestAndTricepsMap2["Shoulder Press"] = "1 x 100"
        toningChestAndTricepsMap2["Lateral Raises"] = "3 x 25,20,15"
        toningChestAndTricepsMap2["Palms Down Triceps"] = "1 x 100"
        toningChestAndTricepsMap2["Palms Up Triceps"] = "3 x 25,20,15"
        
        bulkingChestAndTricepsMap["Incline Bench"] = "3 x 8"
        bulkingChestAndTricepsMap["Bench"] = "3 x 8"
        bulkingChestAndTricepsMap["Incline Flies"] = "3 x 8"
        bulkingChestAndTricepsMap["Cable Flies (ground up)"] = "3 x 8"
        bulkingChestAndTricepsMap["PJR Pullovers"] = "3 x 8"
        bulkingChestAndTricepsMap["Dead-Stop Skull Crushers"] = "3 x 8"
        bulkingChestAndTricepsMap["Close Grip Bench"] = "3 x 8"
        bulkingChestAndTricepsMap["Overhead Tri Extensions"] = "3 x 8"
        
        intChestAndTriceps15Map["DB Bench"] = "3 x 15"
        intChestAndTriceps15Map["Incline Bench"] = "3 x 15"
        intChestAndTriceps15Map["Incline Fly"] = "3 x 15"
        intChestAndTriceps15Map["Close Bench"] = "3 x 15"
        intChestAndTriceps15Map["Palm Down Tri"] = "3 x 15"
        intChestAndTriceps15Map["Palm Up Tri"] = "3 x 15"
        intChestAndTriceps15Map["Skull Crushers"] = "3 x 15"
        
        intChestAndTriceps12Map["Bench"] = "3 x 12"
        intChestAndTriceps12Map["DB Incline"] = "3 x 12"
        intChestAndTriceps12Map["Cable Fly"] = "3 x 12"
        intChestAndTriceps12Map["Close Bench"] = "3 x 12"
        intChestAndTriceps12Map["Palm Down Tri"] = "3 x 12"
        intChestAndTriceps12Map["Palm Up Tri"] = "3 x 12"
        intChestAndTriceps12Map["Skull Crushers"] = "3 x 12"

        
        //toning, bulking, int legs
        toningLegsMap["Leg Extensions"] = "1 x 100"
        toningLegsMap["Squats"] = "3 x 25,20,15"
        toningLegsMap["Leg Curls"] = "1 x 100"
        toningLegsMap["Leg Press"] = "3 x 25,20,15"
        toningLegsMap["Lunges"] = "1 x 100"
        toningLegsMap["Standing Calf Raises"] = "3 x 25,20,15"
        toningLegsMap["Seated Calf Raises"] = "1 x 100"
        
        toningLegsMap2["Leg Extensions"] = "3 x 25,20,15"
        toningLegsMap2["Squats"] = "1 x 100"
        toningLegsMap2["Leg Curls"] = "3 x 25,20,15"
        toningLegsMap2["Leg Press"] = "1 x 100"
        toningLegsMap2["Lunges"] = "3 x 25,20,15"
        toningLegsMap2["Standing Calf Raises"] = "1 x 100"
        toningLegsMap2["Seated Calf Raises"] = "3 x 25,20,15"
        
        bulkingLegsMap["Squats"] = "3 x 8"
        bulkingLegsMap["Leg Press"] = "3 x 8"
        bulkingLegsMap["Leg Extension"] = "3 x 8"
        bulkingLegsMap["Standing Lunges"] = "3 x 8"
        bulkingLegsMap["Seated Calf Raises"] = "3 x 8"
        bulkingLegsMap["Standing Calf Raises"] = "3 x 8"
        bulkingLegsMap["Hamstring Curls"] = "3 x 8"
        bulkingLegsMap["Stiff Leg Deadlifts"] = "3 x 8"
        
        intLegs15Map["Squats"] = "3 x 15"
        intLegs15Map["Leg Press"] = "3 x 15"
        intLegs15Map["Leg Extensions"] = "3 x 15"
        intLegs15Map["Leg Curls"] = "3 x 15"
        intLegs15Map["Walking Lunges"] = "3 x 15"
        intLegs15Map["Standing Calf"] = "3 x 15"
        intLegs15Map["Seated Calf"] = "3 x 15"
        
        intLegs12Map["Squats"] = "3 x 12"
        intLegs12Map["Leg Press"] = "3 x 12"
        intLegs12Map["Leg Extensions"] = "3 x 12"
        intLegs12Map["Leg Curls"] = "3 x 12"
        intLegs12Map["Walking Lunges"] = "3 x 12"
        intLegs12Map["Standing Calf"] = "3 x 12"
        intLegs12Map["Seated Calf"] = "3 x 12"

        
        
        // bulking and int shoulders
        bulkingShouldersMap["Smith High Incline Press"] = "3 x 8"
        bulkingShouldersMap["DB Lateral Raises"] = "3 x 8"
        bulkingShouldersMap["DB Miliary Press"] = "3 x 8"
        bulkingShouldersMap["Face Pulls"] = "3 x 8"
        
        intShoulders15Map["Shoulder Press"] = "3 x 15"
        intShoulders15Map["Lateral Raise"] = "3 x 15"
        intShoulders15Map["Pull Ups"] = "3 x 15"
        intShoulders15Map["DB Military Press"] = "3 x 15"
        intShoulders15Map["Shrugs"] = "3 x 15"
        intShoulders15Map["Handstand Pushups"] = "3 x 12"
        
        intShoulders12Map["Shoulder Press"] = "3 x 12"
        intShoulders12Map["Lateral Raise"] = "3 x 12"
        intShoulders12Map["Pull Ups"] = "3 x 20"
        intShoulders12Map["DB Military Press"] = "3 x 12"
        intShoulders12Map["Shrugs"] = "3 x 12"
        intShoulders12Map["Handstand Pushups"] = "3 x 12"

    }

}

