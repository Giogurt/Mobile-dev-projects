//
//  ViewController.swift
//  bookstore
//
//  Created by user168029 on 4/3/20.
//  Copyright © 2020 Tec. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
   
    @IBOutlet weak var myTableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var selectedBooksArray : [Book] = []
    
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
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let books: [Book] = loadBooks()
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if selectedBooksArray.contains(books[indexPath.row]) {
                cell.accessoryType = .none
                if let selectedBookIndex = selectedBooksArray.firstIndex(of: books[indexPath.row]) {
                    selectedBooksArray.remove(at: selectedBookIndex)
                }
            } else {
                cell.accessoryType = .checkmark
                selectedBooksArray.append(books[indexPath.row])
            }
        }
        NSLog("You selected cell number: \(indexPath.row)!")
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
    
    @IBAction func deleteBooks(_ sender: UIBarButtonItem) {
        for book in  selectedBooksArray {
            NSLog("Removing: %@", book.title!)
            managedObjectContext.delete(book)
        }
        
        selectedBooksArray.removeAll(keepingCapacity: false)
        myTableView.reloadData()
    }
    
}

