//
//  ViewController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dbController = DatabaseController(databaseName: DatabaseController.DefaultDatabaseName)

        let worker = Worker()
        worker.name = "John"
        worker.age = 30
        worker.position = "Engineer"

        dbController.open()
//        dbController.addWorker(worker) { (success) in
//            print("Added Worker result: \(success)")
//        }

        dbController.fetchAllWorkers { (workers) in
            if let worker = workers.first {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
            else {
                print("No workers")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

