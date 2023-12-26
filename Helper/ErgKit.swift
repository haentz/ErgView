//
//  ErgKit.swift
//  ERGView
//
//  Created by Hans Schneider on 25.12.23.
//

import Foundation

public struct ErgData{
    
    struct WorkoutValues {
        var Timing: Int
        var Power: Int
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
        
        var inHeader: Bool
        var inData: Bool
        
        var ergData : ErgData = ErgData()
        
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
                inData = false
            }
            
        
        }
        
       return ergData
        
    }
    
    
    
    // parse mrc
    
}
