//
//  Date+Extensions.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/27/23.
//

import Foundation

extension Date {
    var convertToString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self)
        }
}
