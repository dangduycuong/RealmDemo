//
//  BookTableViewController.swift
//  RealmDemo
//
//  Created by Cuong on 9/23/19.
//  Copyright © 2019 Cuong. All rights reserved.
//

import UIKit

import RealmSwift

class BookTableViewController: UITableViewController {
    
    private var token: NotificationToken?
    
    private var books: [BookItem]? {
        get {
//            return realm.objects(BookItem.self).sorted(byKeyPath: "name", ascending: true).toArray(ofType: BookItem.self)
            return realm.objects(BookItem.self).toArray(ofType: BookItem.self)
        }
    }
    
    private lazy var realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        token = BookItem.getAll().observe({ [weak tableView] changes in
//            guard let tableView = tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let updates):
//                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
//            case .error:
//                break
//            }
//        })
//        let temp: Results<BookItem>?
//        temp = BookItem.getAll()
//        token = temp?.observe({ [weak tableView] changes in
//            guard let tableView = tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let updates):
//                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
//            case .error:
//                break
//            }
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        token?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BookTableViewCell,
            let book = books?[indexPath.row] else {
                return BookTableViewCell(frame: .zero)
        }
        

        // Configure the cell...
        cell.configureWith(book) { [weak self] book in
            book.toggleCompleted()
            self?.tableView.reloadData()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell else {
//            return
//        }
//
//        cell.toggleCompleted()
        let book = BookItem()
        book.tensach = "Sua roi"
        realm.beginWrite()
        books?[indexPath.row].tensach = book.tensach
        try! realm.commitWrite()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    

    
    func showInputBookAlert(_ title: String, isSecure: Bool = false, text: String? = nil, callback: @escaping(String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { field in
          field.isSecureTextEntry = isSecure
            field.text = text
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                //userInputAlert(title, callback: callback)
                return
            }
            callback(text)
            self.tableView.reloadData()
        })
        
        let root = UIApplication.shared.keyWindow?.rootViewController
        root?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func onAddButtonClicked(_ sender: UIBarButtonItem) {
        showInputBookAlert("Add book name") { name in
            BookItem.add(name: name)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let books = books {
            try! realm.write {
                realm.delete(books[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }
    
    
    
    
}

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        beginUpdates()
        deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: updates.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}


