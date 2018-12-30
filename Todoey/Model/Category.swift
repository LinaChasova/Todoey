//
//  Category.swift
//  Todoey
//
//  Created by Алина Часова on 30/12/2018.
//  Copyright © 2018 LinaChasova. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
