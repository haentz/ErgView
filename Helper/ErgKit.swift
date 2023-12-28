//
//  ErgKit.swift
//  ERGView
//
//  Created by Hans Schneider on 25.12.23.
//

import Foundation

public struct ErgData{
    
    struct WorkoutValues {
        var Timing: Float = 0 // segment timing in workout in seconds
        var length: Float = 0 // length of segment in seconds
        var startPower: Float = 0 // power at start of segment in watts
        var endPower: Float = 0 // power at end of segment in watts
    }
    
    var name: String = ""
    var ftp: Int = 0
    
    var workoutData: [WorkoutValues] = []
    
    
}


public struct ErgKit {
    
    enum ErgKitErrors: Error {
        
        case failedToLoadData
        
    }
    
    
    // header list {FTP, Name, description}
    
    
    //load file into erg
    func loadFile(filePath: String) throws -> String {
    
        let url = URL(fileURLWithPath: filePath)
    
        do {
            let data = try Data(contentsOf: url)
            return String(decoding: data, as: UTF8.self)
        } catch {
            throw ErgKitErrors.failedToLoadData
        }
        
    }

    
    
    // parse erg
    func parseErg(data: String) throws -> ErgData{
        
        var inHeader: Bool=false
        var inData: Bool=false
        
        var ergData : ErgData = ErgData()
        
        var oldTiming:Float = 0.0
        var oldPower:Float = 0.0
        
        for line in data.components(separatedBy: .newlines) {
            
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        print(trimmed)
            if(trimmed.caseInsensitiveCompare("[COURSE HEADER]")==ComparisonResult.orderedSame) {
                inHeader = true
            } else if(trimmed.caseInsensitiveCompare("[END COURSE HEADER]")==ComparisonResult.orderedSame) {
                inHeader = false
            } else if(trimmed.caseInsensitiveCompare("[COURSE DATA]")==ComparisonResult.orderedSame) {
                inData = true
            } else if(trimmed.caseInsensitiveCompare("[END COURSE DATA]")==ComparisonResult.orderedSame) {
                inData = false
                
            }
            
        
            else if(inHeader) {
                
                
                
            } else if(inData) {
                let segmentData = trimmed.components(separatedBy: "\t") as [String]
                let currentTiming = (segmentData[0] as NSString).floatValue
                
                let currentPower = (segmentData[1] as NSString).floatValue
                
                
                // error: swirtch when same as old timing
                
                if(currentTiming.isEqual(to: oldTiming)==false) {
                    var newWorkoutStep:ErgData.WorkoutValues = ErgData.WorkoutValues()
                    newWorkoutStep.Timing = currentTiming
                    newWorkoutStep.startPower = currentPower
                    ergData.workoutData.append(newWorkoutStep)
                }
                
                oldTiming = currentTiming
            
            }
            
        }
        
        
        print(ergData);
        
       return ergData
        
    }
    
    
    
    // parse mrc
    
}
