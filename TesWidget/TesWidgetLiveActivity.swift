//
//  TesWidgetLiveActivity.swift
//  TesWidget
//
//  Created by Muhammad Satria Dharma on 10/03/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TesWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TesWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TesWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TesWidgetAttributes {
    fileprivate static var preview: TesWidgetAttributes {
        TesWidgetAttributes(name: "World")
    }
}

extension TesWidgetAttributes.ContentState {
    fileprivate static var smiley: TesWidgetAttributes.ContentState {
        TesWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TesWidgetAttributes.ContentState {
         TesWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TesWidgetAttributes.preview) {
   TesWidgetLiveActivity()
} contentStates: {
    TesWidgetAttributes.ContentState.smiley
    TesWidgetAttributes.ContentState.starEyes
}
