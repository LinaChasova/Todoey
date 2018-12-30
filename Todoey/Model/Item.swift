//
//  Item.swift
//  Todoey
//
//  Created by Алина Часова on 30/12/2018.
//  Copyright © 2018 LinaChasova. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var todoey : String = ""
    @objc dynamic var isChecked : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
