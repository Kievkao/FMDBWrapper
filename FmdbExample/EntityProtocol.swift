//
//  EntityProtocol.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

protocol EntityProtocol {
    var tableName: String { get }
    var rowsNames: String { get }
    var rowsPattern: String { get }
    var rowsValues: [AnyObject] { get }
}
