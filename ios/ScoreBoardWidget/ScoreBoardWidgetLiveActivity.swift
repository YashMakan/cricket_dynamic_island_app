//
//  ScoreBoardWidgetLiveActivity.swift
//  ScoreBoardWidget
//
//  Created by Yash Makan on 22/09/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState // don't forget to add this line, otherwise, live activity will not display it.

     public struct ContentState: Codable, Hashable { }
     
     var id = UUID()
}

let sharedDefault = UserDefaults(suiteName: "group.scoreboard")!

struct ScoreBoardWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let heading = sharedDefault.string(forKey: "heading")!
            let subHeading = sharedDefault.string(forKey: "subHeading")!
            
            // Lock screen/banner UI goes here
            VStack {
                Text(heading + " | " + subHeading)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        let t1Name = sharedDefault.string(forKey: "T1_name")!
                        if let t1Image = sharedDefault.string(forKey: "T1_image"), // <-- Put your key here
                          let uiImage = UIImage(contentsOfFile: t1Image) {
                          Image(uiImage: uiImage)
                              .resizable()
                              .frame(width: 53, height: 53)
                              .cornerRadius(13)
                        }
                        Text(t1Name)
                            .font(.subheadline)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        let t2Name = sharedDefault.string(forKey: "T2_name")!
                        if let t2Image = sharedDefault.string(forKey: "T2_image"), // <-- Put your key here
                          let uiImage = UIImage(contentsOfFile: t2Image) {
                          Image(uiImage: uiImage)
                              .resizable()
                              .frame(width: 53, height: 53)
                              .cornerRadius(13)
                        }
                        Text(t2Name)
                            .font(.subheadline)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        let t1Score = sharedDefault.string(forKey: "T1_score")!
                        let t2Score = sharedDefault.string(forKey: "T2_score")!
                        let time = sharedDefault.string(forKey: "time")!
                        
                        Text(t1Score + " : " + t2Score)
                            .font(.largeTitle)
                            .fontWeight(.black)
                        ZStack {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 100, height: 36)
                            
                            Text(time)
                                .font(.body)
                                .foregroundColor(.white)
                            
                        }
                    }
                }
            } compactLeading: {
                HStack {
                    let t1Score = sharedDefault.string(forKey: "T1_score")!
                    if let t1Image = sharedDefault.string(forKey: "T1_image"), // <-- Put your key here
                      let uiImage = UIImage(contentsOfFile: t1Image) {
                      Image(uiImage: uiImage)
                          .resizable()
                          .frame(width: 30, height: 30)
                    }
                    Text(t1Score)
                }
            } compactTrailing: {
                HStack {
                    let t2Score = sharedDefault.string(forKey: "T2_score")!
                    Text(t2Score)
                    
                    if let t2Image = sharedDefault.string(forKey: "T2_image"), // <-- Put your key here
                      let uiImage = UIImage(contentsOfFile: t2Image) {
                      Image(uiImage: uiImage)
                          .resizable()
                          .frame(width: 30, height: 30)
                    }
                }
            } minimal: {
                Text("Min")
            }
            .keylineTint(Color.red)
        }
    }
}

