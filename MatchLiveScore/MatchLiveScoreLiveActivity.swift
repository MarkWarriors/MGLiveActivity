//
//  MatchLiveScoreLiveActivity.swift
//  MatchLiveScore
//
//  Created by Marco Guerrieri on 31/08/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct MatchLiveScoreLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchLiveScoreAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text(context.attributes.date)
                    .font(.caption2)
                    .padding(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.tertiary)
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(context.attributes.homeTeam)")
                        Text("\(context.state.homeTeamScore)")
                            .font(.headline)
                    }
                    Text(" - ")
                    HStack {
                        Text("\(context.state.awayTeamScore)")
                            .font(.headline)
                        Text("\(context.attributes.awayTeam)")
                        Spacer()
                    }
                    Spacer()
                }
                HStack {
                    Spacer(minLength: 4)
                    Text(context.state.lastEvent)
                        .font(.subheadline)
                    Spacer(minLength: 4)
                }
                .padding(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.mint)
            }
            .activityBackgroundTint(Color.white)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.attributes.homeTeam) \(context.state.homeTeamScore)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.awayTeamScore) \(context.attributes.awayTeam)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Spacer(minLength: 4)
                        Text(context.state.lastEvent)
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Spacer(minLength: 4)
                    }
                    .padding(4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.mint)
                    Text(context.attributes.date)
                        .font(.caption2)
                        .padding(4)
                }
            } compactLeading: {
                Text("\(context.attributes.homeTeam) \(context.state.homeTeamScore)")
            } compactTrailing: {
                Text("\(context.state.awayTeamScore) \(context.attributes.awayTeam)")
            } minimal: {
                Text("⚽")
            }
            .widgetURL(URL(string: "https://markwarriors.github.io/"))
            .keylineTint(Color.red)
        }
    }
}

struct MatchLiveScoreLiveActivity_Previews: PreviewProvider {
    static let attributes = MatchLiveScoreAttributes(homeTeam: "Badger",
                                                     awayTeam: "Lion",
                                                     date: "12/09/2023")
    static let contentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                    awayTeamScore: 0,
                                                                    lastEvent: "Match start")
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
