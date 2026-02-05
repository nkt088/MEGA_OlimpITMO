//
//  MatchHeaderView.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI

struct MatchHeaderView: View {
    let game: GameListItem

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.season.league.name)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(game.roundName ?? "")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(game.homeTeam.name)
                    Text(game.awayTeam.name)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(score(game.homeResult, game.awayResult))
                        .font(.title2)
                        .monospacedDigit()
                    Text(game.date?.shortDateTime ?? "—")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }

    private func score(_ h: Int?, _ a: Int?) -> String {
        if let h, let a { return "\(h):\(a)" }
        return "—"
    }
}
