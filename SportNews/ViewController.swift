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

class ViewController: UIViewController, UITableViewDelegate {
    let searchInput = NewsSearchInput()
    
    var newsRowViewModel: [NewsRowCell.ViewModel] = []
    var newsList: [News] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("controller called")
        searchInput.delegate = self
        view.backgroundColor = .systemBackground
        getNews(group: DispatchGroup(), q: "")
        layout()
    }
    
    private func layout() {
        view.addSubview(searchInput)
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchInput.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func getNews(group: DispatchGroup, q: String?) {
        group.enter()
        fetchNews(query: q ?? "") { result in
            switch result {
            case .success(let newsFetched):
//                print(newsFetched, "News List")
                self.newsList = newsFetched
                self.setupTableView()
                self.configureTableCells(with: newsFetched)
            case .failure(let error):
                print(error, "Error GetNews")
//                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsRowCell.self, forCellReuseIdentifier: NewsRowCell.reuseID)
        tableView.rowHeight = .maximum(300, 350)
//        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        print(indexPath.row, "<<<<<")
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

extension ViewController: SearchInputDelegate {
    @objc func searchQuery(q: String) {
        getNews(group: DispatchGroup(), q: q)
    }
}
