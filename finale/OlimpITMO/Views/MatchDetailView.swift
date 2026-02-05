//
//  MatchDetailView.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI

struct MatchDetailView: View {
    let matchId: Int
    @StateObject private var vm: MatchDetailViewModel

    init(matchId: Int) {
        self.matchId = matchId
        _vm = StateObject(wrappedValue: MatchDetailViewModel(matchId: matchId))
    }

    var body: some View {
        Group {
            if let model = vm.model {
                VStack(spacing: 12) {
                    MatchHeaderView(game: model.game)

                    VStack(alignment: .leading, spacing: 10) {
                        row("Лига", model.game.season.league.name)
                        row("Сезон", "\(model.game.season.year)")
                        row("Раунд", model.game.roundName ?? "—")
                        row("Дата", model.game.date?.shortDateTime ?? "—")
                        row("Статус", "\(model.game.status)")
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical)
            } else if vm.isLoading {
                ProgressView()
            } else if let err = vm.errorText {
                ContentUnavailableView(err, systemImage: "exclamationmark.triangle")
            } else {
                ContentUnavailableView("Нет данных", systemImage: "exclamationmark.triangle")
            }
        }
        .task { await vm.load() }
        .navigationTitle("Матч")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ k: String, _ v: String) -> some View {
        HStack {
            Text(k).foregroundStyle(.secondary)
            Spacer()
            Text(v)
        }
    }
}
