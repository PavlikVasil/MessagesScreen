//
//  Date+dateOfWeek.swift
//  MessagesScreen
//
//  Created by Павел on 01.06.2021.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
    }
}
