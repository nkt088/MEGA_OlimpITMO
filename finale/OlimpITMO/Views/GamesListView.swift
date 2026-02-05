//
//  MatchDetailViewModel.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//
import SwiftUI

struct GamesListView: View {
    @ObservedObject var vm: GamesListViewModel

    var body: some View {
        List(vm.games) { game in
            NavigationLink(value: game.id) {
                GameRowView(game: game)
            }
        }
        .overlay {
            if vm.isLoading {
                ProgressView()
            } else if let err = vm.errorText {
                ContentUnavailableView(err, systemImage: "exclamationmark.triangle")
            } else if vm.games.isEmpty {
                ContentUnavailableView("Нет матчей", systemImage: "calendar")
            }
        }
        .refreshable { await vm.reloadAsync() }
        .navigationDestination(for: Int.self) { id in
            MatchDetailView(matchId: id)
        }
    }
}
