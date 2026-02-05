//
//  JSONDecoder.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import Foundation


// MARK: - Decoder / Dates

extension JSONDecoder {
    static var sstats: JSONDecoder {
        let d = JSONDecoder()

        let isoFrac = ISO8601DateFormatter()
        isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]

        let plain = DateFormatter()
        plain.locale = Locale(identifier: "en_US_POSIX")
        plain.timeZone = TimeZone(secondsFromGMT: 0)
        plain.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        d.dateDecodingStrategy = .custom { decoder in
            let c = try decoder.singleValueContainer()
            let s = try c.decode(String.self)
            if let dt = isoFrac.date(from: s) { return dt }
            if let dt = iso.date(from: s) { return dt }
            if let dt = plain.date(from: s) { return dt }
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "Bad date: \(s)")
        }

        return d
    }
}
