//
//  DetailsViewController.swift
//  NewsReader
//
//  Created by Milkhail Babushkin on 19/01/2019.
//  Copyright © 2019 Mikhail Babushkin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var titleView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var item: NewsListItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = titleView
        
        guard let item = item else { return }
        captionLabel.text = item.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateLabel.text = dateFormatter.string(from: item.publishedAt)
        imageView.sd_setImage(with: item.imageUrl, placeholderImage: UIImage(named: "magazine"), options: [])
        linkTextView.text = item.url.absoluteString
        descriptionTextView.text = item.text
    }

}
