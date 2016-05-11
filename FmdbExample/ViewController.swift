//
//  ViewController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dbController = FMDBController(databaseName: FMDBController.DefaultDatabaseName)

    override func viewDidLoad() {
        super.viewDidLoad()

        dbController.open()

        fetchAllWorkers()
        //addWorker()
    }

    func addWorker() {
        dbController.open()

        let worker = Worker()
        worker.name = "Adam"
        worker.age = 22
        worker.position = "QA"

        dbController.addEntity(worker) { (success) in
            print("Added Worker result: \(success)")
        }
    }

    func fetchAllWorkers() {
        dbController.fetchAllEntities(Worker.self) { (workers) in
            if let worker = workers.first {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
            else {
                print("No workers")
            }
        }
    }
}

