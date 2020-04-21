//
//  ViewController.swift
//  bookstore
//
//  Created by user168036 on 4/3/20.
//  Copyright © 2020 Tec. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
   
     @IBOutlet weak var myTableView: UITableView!
     var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
        
    }
    
    func loadBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        var result: [Book] = []
        
        do {
            result = try managedObjectContext.fetch(fetchRequest)
        } catch {
            NSLog("My Error: %@",error as NSError)
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadBooks().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            else {
            return UITableViewCell()
        }
        
        let book: Book = loadBooks()[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }
    
    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let book: Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedObjectContext) as! Book
        book.title = "My Book" + String(loadBooks().count)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            NSLog("My Error: %@", error)
        }
        
        myTableView.reloadData()
    }
}

