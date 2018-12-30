//
//  ViewController.swift
//  Todoey
//
//  Created by Алина Часова on 29/12/2018.
//  Copyright © 2018 LinaChasova. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            loadItems(with: request)
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].todoey
        
        cell.accessoryType = itemArray[indexPath.row].isChecked ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do List Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when alert is actioned
            
            let newItem = Item(context: self.context)
            newItem.todoey = textField.text!
            newItem.isChecked = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item>, predicate: NSPredicate? = nil) {
        
        let compundPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compundPredicate, additionalPredicate])
        } else {
            request.predicate = compundPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data, \(error)")
        }
        tableView.reloadData()
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "todoey CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "todoey", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            loadItems(with: request)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

