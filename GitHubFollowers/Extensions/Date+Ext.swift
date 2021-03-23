//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by William Yeung on 3/23/21.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
