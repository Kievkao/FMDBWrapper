//
//  FMDBEntityProtocol.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

enum FMDBVariableType: Int {
    case IntType
    case BoolType
    case DoubleType
    case StringType
    case DateType
}

protocol FMDBEntityProtocol {
    static var tableName: String { get }
    var rowsNames: String { get }
    var rowsPattern: String { get }
    var rowsNamesArray: [String] { get }

    var rowsValues: [AnyObject] { get }
    static func rowTypeByName(name: String) -> FMDBVariableType?
    func setValue(value: AnyObject, key: String)

    init()
}

extension FMDBEntityProtocol where Self: NSObject {
    static var tableName: String { return String(self) }

    var rowsNamesArray: [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
    }

    var rowsNames: String {
        return self.rowsNamesArray.joinWithSeparator(",")
    }

    var rowsPattern: String {
        return String(byRepeatingString: "?,", count: self.rowsNamesArray.count)
    }

    func setValue(value: AnyObject, key: String) {
        self.setValue(value, forKey: key)
    }
}

extension String {
    public init(byRepeatingString str: String, count: Int) {
        var newString = ""

        for _ in 0 ..< count {
            newString += str
        }
        
        self.init(newString)
    }
}
