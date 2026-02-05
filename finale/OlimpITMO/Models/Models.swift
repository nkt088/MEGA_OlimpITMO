//
//  Models.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import Foundation

struct APIEnvelope<T: Decodable>: Decodable {
    let status: String
    let data: T
    let count: Int?
    let offset: Int?
}

struct Country: Decodable, Hashable {
    let name: String
    let code: String
}

struct League: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let flashScoreId: String?
    let country: Country
    let seasons: [Season]

    static func == (lhs: League, rhs: League) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Season: Decodable, Identifiable, Hashable {
    var id: String { uid }
    let uid: String
    let year: Int
    let dateStart: Date?
    let dateEnd: Date?
    let flashScoreId: String?

    static func == (lhs: Season, rhs: Season) -> Bool { lhs.uid == rhs.uid }
    func hash(into hasher: inout Hasher) { hasher.combine(uid) }
}

struct TeamRef: Decodable, Hashable {
    let id: Int
    let name: String
    let flashId: String?
}

struct LeagueRef: Decodable, Hashable {
    let id: Int
    let name: String
    let country: Country
}

struct SeasonRef: Decodable, Hashable {
    let uid: String
    let year: Int
    let league: LeagueRef
}

struct GameListItem: Decodable, Identifiable, Hashable {
    let dateUtc: Int?
    let id: Int
    let flashId: String?
    let date: Date?
    let status: Int
    let homeResult: Int?
    let awayResult: Int?
    let homeHTResult: Int?
    let awayHTResult: Int?
    let homeFTResult: Int?
    let awayFTResult: Int?
    let homeTeam: TeamRef
    let awayTeam: TeamRef
    let season: SeasonRef
    let roundName: String?
}

struct GameDetailPayload: Decodable, Hashable {
    let game: GameListItem
}

struct GamesListQuery: Hashable {
    var leagueId: Int?
    var year: Int?
    var seasonUid: String?
    var from: Date?
    var to: Date?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let leagueId { items.append(.init(name: "leagueid", value: String(leagueId))) }
        if let year { items.append(.init(name: "year", value: String(year))) }
        if let seasonUid { items.append(.init(name: "seasonUid", value: seasonUid)) }
        if let from { items.append(.init(name: "from", value: from.yyyyMMdd)) }
        if let to { items.append(.init(name: "to", value: to.yyyyMMdd)) }
        return items
    }
}
