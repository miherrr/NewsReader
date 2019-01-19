//
//  ListItemTableViewCell.swift
//  NewsReader
//
//  Created by Milkhail Babushkin on 19/01/2019.
//  Copyright © 2019 Mikhail Babushkin. All rights reserved.
//

import UIKit
import SDWebImage

class ListItemTableViewCell: UITableViewCell {
    class var reuseIdentifier: String { return "ListItemTableViewCell" }
    class var nibName: UINib { return UINib(nibName: reuseIdentifier, bundle: nil) }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var unread: Bool = false {
        didSet {
            unreadMarker.backgroundColor = unread ? .cyan : .clear
        }
    }
    
    var url: URL? {
        didSet {
            newsImage.sd_setImage(with: url, placeholderImage: UIImage(named: "magazine"), options: [], completed: nil)
        }
    }

    @IBOutlet private weak var unreadMarker: UIView!
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = ""
        newsImage.image = nil
        unreadMarker.backgroundColor = .clear
    }
}
