//
//  String+Extensions.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/28/23.
//

import Foundation

extension String {
    var convertToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}
