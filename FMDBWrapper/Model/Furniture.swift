//
//  Furniture.swift
//  FMDBWrapper
//
//  Created by Kravchenko, Andrii on 9/28/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

class Furniture: FMDBEntity {

    var type: String!
    var inventoryNumber: Int = 0
    
    override func columnsValues() -> [AnyObject] {
        return [type as AnyObject, inventoryNumber as AnyObject]
    }
    
    override func columnTypeByName(name: String) -> FMDBVariableType? {
        switch name {
        case "type":
            return .StringType
            
        case "inventoryNumber":
            return .IntType
            
        default:
            return nil
        }
    }
}
