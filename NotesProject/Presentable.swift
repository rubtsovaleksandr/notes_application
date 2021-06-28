//
//  Presentable.swift
//  NotesProject
//
//  Created by Максим Данько on 27.06.2021.
//  Copyright © 2021 Aleksandr. All rights reserved.
//

import UIKit

protocol Presentable {

    var toPresent: UIViewController { get }
}

extension Presentable where Self: UIViewController {
    
    var toPresent: UIViewController {
        return self
    }
}
