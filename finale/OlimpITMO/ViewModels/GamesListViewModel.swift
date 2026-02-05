//
//  MatchDetailViewModel.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//
import SwiftUI
import Combine


@MainActor
final class GamesListViewModel: ObservableObject {
    @Published var leagues: [League] = []
    @Published var selectedLeague: League?
    @Published var selectedSeason: Season?
    @Published var games: [GameListItem] = []
    @Published var isLoading = false
    @Published var errorText: String?
    @Published var isLeaguePickerPresented = false

    private let api: SStatsAPI
    private var didBootstrap = false

    init(api: SStatsAPI = .shared) { self.api = api }

    var contextTitle: String {
        if let l = selectedLeague, let s = selectedSeason { return "\(l.name) · \(s.year)" }
        if let l = selectedLeague { return l.name }
        return "Лига"
    }

    func bootstrapIfNeeded() async {
        guard !didBootstrap else { return }
        didBootstrap = true
        await loadLeaguesAndDefaultContext()
        await reloadAsync()
    }

    func reload() { Task { await reloadAsync() } }

    func reloadAsync() async {
        guard let league = selectedLeague, let season = selectedSeason else { return }
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            var q = GamesListQuery()
            q.leagueId = league.id
            q.year = season.year
            q.seasonUid = season.uid

            let res: APIEnvelope<[GameListItem]> = try await api.gamesList(q)
            games = res.data.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
        } catch {
            errorText = error.localizedDescription
            games = []
        }
    }

    func loadLeaguesAndDefaultContext() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let res: APIEnvelope<[League]> = try await api.leagues()
            leagues = res.data.sorted { ($0.country.name, $0.name) < ($1.country.name, $1.name) }

            if selectedLeague == nil { selectedLeague = leagues.first }
            if let league = selectedLeague, selectedSeason == nil {
                selectedSeason = league.seasons.max(by: { $0.year < $1.year })
            }
        } catch {
            errorText = error.localizedDescription
        }
    }

    func setContext(league: League, season: Season) {
        selectedLeague = league
        selectedSeason = season
        reload()
    }
}

