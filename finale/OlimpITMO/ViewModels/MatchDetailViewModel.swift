//
//  MatchDetailViewModel.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI
import Combine

@MainActor
final class MatchDetailViewModel: ObservableObject {
    @Published var model: GameDetailPayload?
    @Published var isLoading = false
    @Published var errorText: String?

    private let api: SStatsAPI
    private let matchId: Int

    init(matchId: Int, api: SStatsAPI = .shared) {
        self.matchId = matchId
        self.api = api
    }

    func load() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let res: APIEnvelope<GameDetailPayload> = try await api.game(id: matchId)
            model = res.data
        } catch {
            errorText = error.localizedDescription
            model = nil
        }
    }
}
