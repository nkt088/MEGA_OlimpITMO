//
//  SstatsAPI.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import Foundation

final class SStatsAPI {
    static let shared = SStatsAPI()

    private let baseURL = URL(string: "https://api.sstats.net")!
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String = "ВАШ_КЛЮЧ_API", session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    struct APIError: Error, LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }

    func get<T: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> T {
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        var components = URLComponents(url: baseURL.appendingPathComponent(cleanPath), resolvingAgainstBaseURL: false)
        if !query.isEmpty { components?.queryItems = query }
        guard let url = components?.url else { throw APIError(message: "Bad URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw APIError(message: "No HTTP response") }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError(message: "HTTP \(http.statusCode) url=\(url.absoluteString) body=\(body)")
        }

        do { return try JSONDecoder.sstats.decode(T.self, from: data) }
        catch {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError(message: "Decode failed: \(error.localizedDescription) url=\(url.absoluteString) body=\(body)")
        }
    }

    func leagues() async throws -> APIEnvelope<[League]> { try await get("leagues") }
    func gamesList(_ q: GamesListQuery) async throws -> APIEnvelope<[GameListItem]> { try await get("games/list", query: q.queryItems) }
    func game(id: Int) async throws -> APIEnvelope<GameDetailPayload> { try await get("games/\(id)") }
}
