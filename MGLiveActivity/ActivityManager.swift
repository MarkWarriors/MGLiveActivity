//
//  ActivityManager.swift
//  MGLiveActivity
//
//  Created by Marco Guerrieri on 07/09/2023.
//

import ActivityKit
import Combine
import Foundation

final class ActivityManager: ObservableObject {
    @MainActor @Published private(set) var activityID: String?
    
    static let shared = ActivityManager()
    
    func start() async {
        await cancelAllRunningActivities()
        await startNewLiveActivity()
    }
    
    func endActivity() async {
        guard let activityID = await activityID,
              let runningActivity = Activity<MatchLiveScoreAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        let initialContentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                        awayTeamScore: 0,
                                                                        lastEvent: "Match Start")

        await runningActivity.end(
            ActivityContent(state: initialContentState, staleDate: Date.distantFuture),
            dismissalPolicy: .immediate
        )
        
        await MainActor.run { self.activityID = nil }
    }
    
    func cancelAllRunningActivities() async {
        for activity in Activity<MatchLiveScoreAttributes>.activities {
            let initialContentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                            awayTeamScore: 0,
                                                                            lastEvent: "Match Start")
            
            await activity.end(
                ActivityContent(state: initialContentState, staleDate: Date()),
                dismissalPolicy: .immediate
            )
        }
        
        await MainActor.run {
            activityID = nil
        }
    }
    
    private func startNewLiveActivity() async {
        let attributes = MatchLiveScoreAttributes(homeTeam: "Badger",
                                                  awayTeam: "Lion",
                                                  date: "12/09/2023")
        
        let initialContentState = ActivityContent(state: MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                                               awayTeamScore: 0,
                                                                                               lastEvent: "Match Start"),
                                                  staleDate: nil)
        
        let activity = try? Activity.request(
            attributes: attributes,
            content: initialContentState,
            pushType: .token
        )
        
        guard let activity = activity else { return }
        
        await MainActor.run { activityID = activity.id }
        
        for await data in activity.pushTokenUpdates {
            let activityToken = data.map {String(format: "%02x", $0)}.joined()
            print("Activity token: \(activityToken)")
            // HERE SEND THE TOKEN TO THE SERVER
        }
    }
    
}
