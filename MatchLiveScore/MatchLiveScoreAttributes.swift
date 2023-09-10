//
//  MatchLiveScoreAttributes.swift
//  MGLiveActivity
//
//  Created by Marco Guerrieri on 7/09/2023.
//

import Foundation
import ActivityKit

struct MatchLiveScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var lastEvent: String
    }
    
    var homeTeam: String
    var awayTeam: String
    var date: String
}
