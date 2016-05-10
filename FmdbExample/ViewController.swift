//
//  ViewController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dbController = DatabaseController(databaseName: DatabaseController.DefaultDatabaseName)

    override func viewDidLoad() {
        super.viewDidLoad()

        dbController.open()

        fetchAllWorkers()
    }

    func addWorker() {
        dbController.open()

        let worker = Worker()
        worker.name = "John"
        worker.age = 30
        worker.position = "Engineer"

        dbController.addWorker(worker) { (success) in
            print("Added Worker result: \(success)")
        }
    }

    func fetchAllWorkers() {
        dbController.fetchAllWorkers { (workers) in
            if let worker = workers.first {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
            else {
                print("No workers")
            }
        }
    }
}

