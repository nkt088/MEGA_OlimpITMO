//
//  DateExt.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import Foundation

extension Date {
    var shortDateTime: String {
        let f = DateFormatter()
        f.locale = .current
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: self)
    }

    var yyyyMMdd: String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: self)
    }
}
