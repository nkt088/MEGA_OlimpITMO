//
//  LeagueSeasonPickerView.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI

struct LeagueSeasonPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: GamesListViewModel

    @State private var league: League?
    @State private var season: Season?

    var body: some View {
        NavigationStack {
            List {
                Section("Лига") {
                    Picker("Лига", selection: $league) {
                        Text("—").tag(Optional<League>.none)
                        ForEach(vm.leagues) { l in
                            Text("\(l.country.name) · \(l.name)").tag(Optional(l))
                        }
                    }
                }

                Section("Сезон") {
                    Picker("Сезон", selection: $season) {
                        Text("—").tag(Optional<Season>.none)
                        ForEach(currentSeasons) { s in
                            Text("\(s.year)").tag(Optional(s))
                        }
                    }
                    .disabled(league == nil)
                }
            }
            .navigationTitle("Контекст")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Применить") {
                        guard let league, let season else { return }
                        vm.setContext(league: league, season: season)
                        dismiss()
                    }
                    .disabled(league == nil || season == nil)
                }
            }
            .task {
                if vm.leagues.isEmpty { await vm.loadLeaguesAndDefaultContext() }
                league = vm.selectedLeague ?? vm.leagues.first
                normalizeSeason()
            }
            .onChange(of: league) { _, _ in
                normalizeSeason()
            }
            .onChange(of: vm.leagues) { _, _ in
                if let league, vm.leagues.contains(where: { $0.id == league.id }) == false {
                    self.league = vm.leagues.first
                }
                normalizeSeason()
            }
        }
    }

    private var currentSeasons: [Season] {
        guard let league else { return [] }
        return league.seasons.sorted(by: { $0.year > $1.year })
    }

    private func normalizeSeason() {
        guard let league else {
            season = nil
            return
        }
        if let season, league.seasons.contains(where: { $0.uid == season.uid }) { return }
        season = league.seasons.max(by: { $0.year < $1.year })
    }
}
