//
//  Furniture.swift
//  FMDBWrapper
//
//  Created by Kravchenko, Andrii on 9/28/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

class Furniture: FMDBEntity {
    enum FurnitureType: Int {
        case Table
        case Chair
    }

    var type: FurnitureType!
    var inventoryNumber: String!
    
    override func columnsValues() -> [AnyObject] {
        return [type.rawValue as AnyObject, inventoryNumber as AnyObject]
    }
    
    override func columnTypeByName(name: String) -> FMDBVariableType? {
        switch name {
        case "type":
            return .IntType
            
        case "inventoryNumber":
            return .StringType
            
        default:
            return nil
        }
    }
}
