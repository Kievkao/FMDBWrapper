//
//  Worker.swift
//  CoreDataStacksExample
//
//  Created by Andrii Kravchenko on 12/22/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import Foundation

class Worker: FMDBEntity {
    var age: Int = 0
    var name: String!
    var position: String!

    override func columnsValues() -> [AnyObject] {
        return [age as AnyObject, name as AnyObject, position as AnyObject]
    }

    override func columnTypeByName(name: String) -> FMDBVariableType? {
        switch name {
        case "age":
            return .IntType

        case "name", "position":
            return .StringType

        default:
            return nil
        }
    }
}
