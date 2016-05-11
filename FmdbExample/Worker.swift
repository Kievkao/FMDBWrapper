//
//  Worker.swift
//  CoreDataStacksExample
//
//  Created by Andrii Kravchenko on 12/22/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import Foundation

class Worker: NSObject, FMDBEntityProtocol {
    var age: Int = 0
    var name: String!
    var position: String!

    // MARK: FMDBEntityProtocol
    override required init() {
        super.init()
    }

    var rowsValues: [AnyObject] { return [name, age, position] }

    static func rowTypeByName(name: String) -> FMDBVariableType? {
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
