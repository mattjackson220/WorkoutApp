//
//  TableRowObject.swift
//  WorkoutApp
//
//  Created by Matthew Jackson on 8/24/17.
//  Copyright © 2017 Matthew Jackson. All rights reserved.
//

struct TableRowObject {
    let exerciseName, previousWeight, weight, setsAndReps: String
    init(exerciseName: String, previousWeight: String, weight: String, setsAndReps: String) {
        self.exerciseName   = exerciseName
        self.previousWeight = previousWeight
        self.weight  = weight
        self.setsAndReps = setsAndReps
    }
}
