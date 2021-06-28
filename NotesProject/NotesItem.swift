//
//  NotesItem.swift
//  NotesProject
//
//  Created by Aleksandr on 04/06/2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import Foundation

struct NoteItem {
    let title: String
    let text: String
    let date: String
    let id: String
    let password: String
}

extension NoteItem {
    
    var hasPassword: Bool {
        return !password.isEmpty
    }
    
}
