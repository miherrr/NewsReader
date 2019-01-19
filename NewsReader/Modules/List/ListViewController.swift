//
//  ViewController.swift
//  NewsReader
//
//  Created by Milkhail Babushkin on 19/01/2019.
//  Copyright © 2019 Mikhail Babushkin. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class ListViewController: UIViewController {
    
    private var dataSource: [NewsListItem] {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: realmConfig)
        return Array(realm.objects(NewsListItem.self))
    }

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListItemTableViewCell.nibName, forCellReuseIdentifier: ListItemTableViewCell.reuseIdentifier)
    }
    
    private func loadNews(search q: String) {
        guard let newsUrl = URL(string: "https://newsapi.org/v2/everything?q=\(q)&sortBy=publishedAt&apiKey=b59bc1f13f884301a259ebc4a7c68af2") else {
            return
        }
        let session = URLSession.shared
        let request = URLRequest(url: newsUrl)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                    let articles = json["articles"] as? [Any] else {
                    return
                }
                let items = NewsListItem.from(array: articles)
                do {
                    let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                    let realm = try Realm(configuration: realmConfig)
                    
                    let dataToRemove = realm.objects(NewsListItem.self)
                    try realm.write {
                        realm.delete(dataToRemove)
                        realm.add(items)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                } catch {
                    return
                }
                print(json)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let item = sender as? NewsListItem,
            let vc = segue.destination as? DetailsViewController else {
                return
        }
        vc.item = item
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListItemTableViewCell.reuseIdentifier, for: indexPath) as? ListItemTableViewCell else {
            return UITableViewCell()
        }
        let data = dataSource[indexPath.row]
        cell.title = data.title
        cell.url = data.imageUrl
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        performSegue(withIdentifier: "details", sender: item)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadNews(search: searchText)
    }
}
