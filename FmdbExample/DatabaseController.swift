//
//  DatabaseController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import FMDB

class DatabaseController {

    private let DatabasePath = "/Documents/"
    private let db: FMDatabase!
    private let serialDispatchQueue: dispatch_queue_t!

    init(databaseName: String) {
        db = FMDatabase(path: DatabasePath + databaseName + ".db")
        serialDispatchQueue = dispatch_queue_create(databaseName + "_dbQueue", DISPATCH_QUEUE_SERIAL)
    }

    private func runDatabaseBlockInTransaction(block: Void -> Void) {
        dispatch_async(serialDispatchQueue) {
            autoreleasepool({ 
                self.db.beginTransaction()
                block()
                self.db.commit()
            })
        }
    }
}
