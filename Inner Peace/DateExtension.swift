//
//  DateExtension.swift
//  Inner Peace
//
//  Created by Oliver Lippold on 25/07/2020.
//  Copyright © 2020 Oliver Lippold. All rights reserved.
//

import Foundation

extension Date {
    func byAdding(days: Int, to date: Date = Date()) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        return Calendar.current.date(byAdding: dateComponents, to: date) ?? date
    }
}
