//
//  ViewController.swift
//  SportNews
//
//  Created by マフディ　ハリス on 14/07/24.
//

import UIKit

struct News {
    let title: String
    let text: String
    let image: String
}

let newsDummy: [News] = [
    News(title: "NFL Rankings Teams 1 through 6", text: "Harrison Butker makes a 35 yard field goal and trade season is coming through", image: "https://images.seattletimes.com/wp-content/uploads/2023/11/11232023_Kraken_211222.jpg"),
    News(title: "NHL Pipeline Rankings Teams 1 through 6", text: "Harrison Butker makes a 35 yard field goal and trade season is coming through", image: "https://a57.foxsports.com/statics.foxsports.com/www.foxsports.com/content/uploads/2024/08/1294/728/jordan-love.jpg"),
    News(title: "NFL Rankings Teams 1 through 6", text: "Harrison Butker makes a 35 yard field goal and trade season is coming through", image: "https://a57.foxsports.com/statics.foxsports.com/www.foxsports.com/content/uploads/2024/08/1294/728/5b59a782-jalen-hurts-16x9-1.jpg"),
    News(title: "NBA Rankings Teams 1 through 6", text: "Harrison Butker makes a 35 yard field goal and trade season is coming through", image: "https://e0.365dm.com/22/12/2048x1152/skysports-jae-crowder-nba-phoenix-suns_5995073.jpg"),
]

class ViewController: UIViewController, UITableViewDelegate {
    let titleLabel = UILabel()
    let previewText = UILabel()
    
    var newsRowViewModel: [NewsRowCell.ViewModel] = []
    let newsList: [News] = newsDummy
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("controller called")
        view.backgroundColor = .systemBackground
        self.configureTableCells(with: self.newsList)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsRowCell.self, forCellReuseIdentifier: NewsRowCell.reuseID)
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableCells(with list: [News]) {
        newsRowViewModel = newsList.map {
            NewsRowCell.ViewModel(title: $0.title, text: $0.text, image: $0.image)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !newsRowViewModel.isEmpty else { return UITableViewCell() }
        let row = newsRowViewModel[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsRowCell.reuseID, for: indexPath) as! NewsRowCell
        cell.configure(with: row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsRowViewModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
