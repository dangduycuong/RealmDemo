//
//  BookTableViewCell.swift
//  RealmDemo
//
//  Created by Cuong on 9/23/19.
//  Copyright © 2019 Cuong. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    private var onToggleCompleted: ((BookItem) -> Void)?
    private var book: BookItem?
    
    func configureWith(_ book: BookItem, onToggleCompleted: ((BookItem) -> Void)? = nil) {
        self.book = book
        self.onToggleCompleted = onToggleCompleted
        self.textLabel?.text = book.tensach
        self.accessoryType = book.xong ? .checkmark : .none
    }
    
    func toggleCompleted() {
        guard let book = book else { fatalError("Book not found")}
        
        onToggleCompleted?(book)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
