//
//  BookItem.swift
//  RealmDemo
//
//  Created by Cuong on 9/23/19.
//  Copyright © 2019 Cuong. All rights reserved.
//

import Foundation

import RealmSwift

class DataBaseManager: NSObject {
    static let instance = DataBaseManager()
    let realm = try! Realm()
}

@objcMembers class BookItem: Object {
    enum Property: String {
        case id, name, isCompleted
    }
    
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return BookItem.Property.id.rawValue
    }
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
    
    //get list book: lấy object trong realm database
    static func getAll(in realm: Realm = try! Realm()) -> Results<BookItem> {
        return realm.objects(BookItem.self).sorted(byKeyPath: BookItem.Property.isCompleted.rawValue)
    }
    
    // edit book, sửa các BookItem object và lưu vào Database
    func toggleCompleted() {
        guard let realm = realm else { return }
        try! realm.write {
            isCompleted = !isCompleted
        }
        // việc thay đổi propertyisCompleted thực thi trong closure của hàm write(_:)
    }
    
    //delete
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}

// thêm book
extension BookItem {
    static func add(name: String, in realm: Realm = try! Realm()) -> BookItem {
        let book = BookItem(name)
        try! realm.write {
            realm.add(book)
        }
        return book
    }
    

}
