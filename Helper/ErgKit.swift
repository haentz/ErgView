//
//  ErgKit.swift
//  ERGView
//
//  Created by Hans Schneider on 25.12.23.
//

import Foundation

public struct ErgData{
    
    // todo rename
    struct WorkoutValues {
        var timing: Float = 0 // segment timing in workout in seconds
        var length: Float = 0 // length of segment in seconds
        var startPower: Float = 0 // power at start of segment in watts
        var endPower: Float = 0 // power at end of segment in watts
        var powerZone: Int = 0 //power zone 1-5
    }
    
    var name: String = "FTP 8211 Builder Wk 1 Day 1"
    var ftp: Float = 278
    
    
    var runtime: Float = 0.0
    var powerMin: Float = 0.0
    var powerMax: Float = 0.0
    var numberIntervals: Int = 0
    
    // todo rename
    var workoutData: [WorkoutValues] = []
   
    
    
    
}


public struct ErgKit {
    
    enum ErgKitErrors: Error {
        
        case failedToLoadData
        
    }
    
    
    // header list {FTP, Name, description}
    
    
    //load file into erg
        //throws
    func loadFile(url: URL) throws -> String {
    
       // let url = URL(fileURLWithPath: filePath)
    
        
        
        do {
            url.startAccessingSecurityScopedResource()
            
            let data = try Data(contentsOf: url)
            
            url.stopAccessingSecurityScopedResource()
            return String(decoding: data, as: UTF8.self)
        } catch let error {
            
            throw error
//            print("error lading file")
        }
        
        
    }

    
    
    // parse erg
    //throws
    func parseErg(data: String)  -> ErgData{
        
        var inHeader: Bool=false
        var inData: Bool=false
        
        var ergData : ErgData = ErgData()
        
        var oldTiming:Float = 0.0
        var oldStartPower:Float = 0.0
     
        for line in data.components(separatedBy: .newlines) {
            
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
       
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
            // todo: read headers
                
                
            } else if(inData) {
                let segmentData = trimmed.components(separatedBy: "\t") as [String]
                let currentTiming = (segmentData[0] as NSString).floatValue
                
                let currentPower = (segmentData[1] as NSString).floatValue
                
                
                if(currentTiming.isEqual(to: oldTiming)==false) {
                    // write new Workoutvaalues step
                    var newWorkoutStep:ErgData.WorkoutValues = ErgData.WorkoutValues()
                    newWorkoutStep.timing = oldTiming
                    newWorkoutStep.length = currentTiming-oldTiming
                    newWorkoutStep.startPower = oldStartPower
                    newWorkoutStep.endPower = currentPower
                    ergData.workoutData.append(newWorkoutStep)
                  
                }
                
                // update metadata for workout
                ergData.runtime = ergData.runtime+currentTiming-oldTiming
                ergData.numberIntervals+=1
                
                if(currentPower<=ergData.powerMin) {
                    ergData.powerMin = currentPower
                }
                
                if(currentPower>=ergData.powerMax) {
                    ergData.powerMax = currentPower
                }
                
                
                oldTiming = currentTiming
                oldStartPower = currentPower
            }
            
        }
        
        
      //  print(ergData);
        
       return ergData
        
    }
    
    
    
    // parse mrc
    
}
