//
//  GameRowView.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI

struct GameRowView: View {
    let game: GameListItem

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(game.homeTeam.name) — \(game.awayTeam.name)")
                    .lineLimit(1)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(scoreText)
                .monospacedDigit()
        }
    }

    private var subtitle: String {
        let dt = game.date?.shortDateTime ?? "—"
        return "\(dt) · \(statusText(game.status))"
    }

    private var scoreText: String {
        if let h = game.homeResult, let a = game.awayResult { return "\(h):\(a)" }
        return "—"
    }

    private func statusText(_ code: Int) -> String {
        switch code {
        case 1: return "TBD"
        case 2: return "Не начался"
        case 3: return "1-й тайм"
        case 4: return "Перерыв"
        case 5: return "2-й тайм"
        case 8: return "Завершён"
        case 19: return "Идёт"
        default: return "Статус \(code)"
        }
    }
}
