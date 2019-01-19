//
//  ListItem.swift
//  NewsReader
//
//  Created by Milkhail Babushkin on 19/01/2019.
//  Copyright © 2019 Mikhail Babushkin. All rights reserved.
//

import Foundation
import RealmSwift

class NewsListItem: Object {
    static var dateFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return format
    }

    @objc dynamic var title: String = ""
    @objc private dynamic var imageUrlString: String? = nil
    @objc dynamic var seen: Bool = false
    @objc dynamic var publishedAt: Date = Date()
    @objc dynamic var text: String = ""
    @objc dynamic var urlString: String = ""

    var imageUrl: URL? {
        get {
            return URL(string: imageUrlString ?? "")
        }
        set {
            imageUrlString = newValue?.absoluteString
        }
    }
    var url: URL {
        get {
            return URL(string: urlString)!
        }
        set {
            urlString = newValue.absoluteString
        }
    }
    
    static func from(array json: [Any]) -> [NewsListItem] {
        var result: [NewsListItem] = []
        for item in json {
            guard let item = item as? [String: Any],
                let title = item["title"] as? String,
                let text = item["description"] as? String,
                let publishedAtString = item["publishedAt"] as? String,
                let publishedAt = dateFormat.date(from: publishedAtString),
                let urlString = item["url"] as? String
            else { continue }
            
            let newItem = NewsListItem()
            newItem.title = title
            newItem.imageUrlString = item["urlToImage"] as? String
            newItem.text = text
            newItem.publishedAt = publishedAt
            newItem.urlString = urlString
            
            result.append(newItem)
        }
        return result
    }
}
