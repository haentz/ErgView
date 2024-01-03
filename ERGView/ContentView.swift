//
//  ContentView.swift
//  ERGView
//
//  Created by Hans Schneider on 25.12.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            
            HStack {
                
                
                
                
               
                    Canvas { context, size in
                        
                        //calculate pixel per second
                        
                        let pixelPerSecond: Float = (Float)(size.width / 48.0);
                        
                        //calcualte height of segment bar (Int)(pixelPerSecond*4)
                        var segmentSize = CGSize(width: (Int)(pixelPerSecond*4), height: 120)
                        var origin = CGPoint(x: 0, y: size.height-170)
                        
                  
                        context.fill(
                            Path(roundedRect: CGRect(x: (Int)(pixelPerSecond*4) + 2, y: (Int)(size.height-220), width:  (Int)(pixelPerSecond*10), height: 170)
                                 , cornerRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/),
                            with: .color(.blue)
                        )
                        
                        
                      
                        
                }
            }
            Text("Workout")
        }

    }
    
    
    
}

#Preview {
    ContentView()
}
