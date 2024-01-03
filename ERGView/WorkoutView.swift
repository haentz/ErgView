//
//  WorkoutView.swift
//  ERGView
//
//  Created by Hans Schneider on 28.12.23.
//

import SwiftUI
import UniformTypeIdentifiers


extension UTType {
    static let ergDocument = UTType(exportedAs: "de.hans-schneider.ergview")
}

struct WorkoutView: View {
   
    var ergKit = ErgKit()
    @State var ergData:ErgData? = nil
    
    var fileName:String = "";
    
    
    
    
    
    
    
   init() {
//        do {
//            let data:String = try ergKit.loadFile(filePath: "/Users/hans/Downloads/test.erg")
//           
//             try ergData = ergKit.parseErg(data: data)
//        }  catch  let error {
//                               print(error)
//            ergData = ErgData()
//        }
//                
//        
//        
    }
   
//    
//    init(_ergData: ErgData) {
//        self.ergData=_ergData
//    }




//            do {
     
        
//            }  catch  let error {
//                   print("error")
//                }
    
    
    
    func openFile() -> URL? {
        func showOpenPanel() -> URL? {
            let openpanel = NSOpenPanel()
            openpanel.title                = "Open ERG file"
            openpanel.isExtensionHidden    = false
            openpanel.canChooseDirectories = false
            openpanel.canChooseFiles       = true
            openpanel.allowedContentTypes  = [.ergDocument]

            
            let response = openpanel.runModal()
            return response == .OK ? openpanel.url : nil
        }
        
        return showOpenPanel()
    }
    
    
    
    func loadErgData(file: URL) {
        do {
                   let data:String = try ergKit.loadFile(url: file)
       
                    try ergData = ergKit.parseErg(data: data)
               }  catch  let error {
                   print(error)
                   ergData = ErgData()
               }
    }
    
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                
                if let ergData = ergData {
                    
                    
                    Canvas { context, size in
                        
                        
                        let pixelPerMinute: Float = (Float)( (size.width-10) / CGFloat(ergData.runtime));
                        let maxPower: Float = (Float)( (size.height-10) / CGFloat(ergData.powerMax));
                        var shading:GraphicsContext.Shading
                        
                        shading = .color(.blue)
                        
                        for segment:ErgData.WorkoutValues in ergData.workoutData {
                            
                            if(segment.startPower/ergData.ftp<0.55) {
                                shading = .color(.gray)
                            } else if(segment.startPower/ergData.ftp<0.75) {
                                shading = .color(.blue)
                            } else if(segment.startPower/ergData.ftp<0.90) {
                                shading = .color(.green)
                            } else if(segment.startPower/ergData.ftp<1.05) {
                                shading = .color(.yellow)
                            } else if(segment.startPower/ergData.ftp<1.2) {
                                shading = .color(.orange)
                            }else {
                                shading = .color(.red)
                            }
                            
                            
                            // if a segment would be too short to be visible, set it to a minimum width of 2px
                            // todo: fix how these small segments might appear pushed to the right
                            var segmentWidth:Int = (Int)(pixelPerMinute*segment.length)-5;
                            if(segmentWidth<2) {
                                segmentWidth = 2;
                            }
                            
                            context.fill(
                                Path(roundedRect:
                                        CGRect(x: (Int)(pixelPerMinute*segment.timing)+10, y: (Int)(size.height-((CGFloat)(segment.startPower*maxPower))),
                                               width:  segmentWidth, height: (Int)(segment.startPower*maxPower))
                                     , cornerRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/),
                                with: shading
                            )
                            
                            
                            context.draw(Text(String(format: "%.0fW",segment.startPower)).bold().italic().foregroundColor(.black), at: CGPoint(x: (Int)(pixelPerMinute*segment.timing)+(Int)(pixelPerMinute*segment.length/2)+5, y: (Int)(size.height-20)))
                            
                            context.draw(Text(String(format: "%.0f Min",segment.length)).foregroundColor(.black), at: CGPoint(x: (Int)(pixelPerMinute*segment.timing)+(Int)(pixelPerMinute*segment.length/2)+5, y: (Int)(size.height-8)))
                            
                            
                        }
                        //                        //calculate pixel per second
                        //
                        
                        //
                        //
                        //
                        //
                        //                        ForEach(self.ergData.workoutData ) { segment in
                        //                            context.fill(
                        //                                Path(roundedRect:
                        //                                        CGRect(x: (Int)(pixelPerMinute*segment.timing) + 2, y: (Int)(size.height),
                        //                                               width:  (Int)(pixelPerMinute*10), height: 100)
                        //                                     , cornerRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/),
                        //                                with: .color(.blue)
                        //                            )
                        //
                        //    }
                        
                        
                    }
                    
                    
                    Text(ergData.name)
                    
                    
                } else {
                    // no ergdata, show laod button
                   
                   
                    Button("Load ERG") {
                        if let url = openFile() {
                                           
                            loadErgData(file:url)
                                       } else {
                                           print("error opener")
                                       }
                    }
                }
            }
            
        }
        
    }
    
}

#Preview {
    ContentView()
}
