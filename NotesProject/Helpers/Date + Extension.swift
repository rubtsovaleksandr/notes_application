//
//  Date + Extension.swift
//  NotesProject
//
//  Created by Aleksandr on 22/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import Foundation

extension Date {
    var toUTC: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
