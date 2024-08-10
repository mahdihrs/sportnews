//
//  ViewController+Networking.swift
//  SportNews
//
//  Created by マフディ　ハリス on 03/08/24.
//

import Foundation
import UIKit

struct Source: Codable {
    let id: String?
    let name: String
}

// Define the Article struct
struct Article: Codable {
    let source: Source
    let author: String
    let title: String
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String
    let content: String?
}

struct NewsApi: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

enum NetworkError: Error {
    case serverError
    case decodingError
}

extension ViewController {
    func fetchNews(completion: @escaping (Result<[News],NetworkError>) -> Void) {
        let url = URL(string: "https://newsapi.org/v2/everything?apiKey=\(Variables.newsKey)&pageSize=10&q=olympics")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error!, "Error here")
                    completion(.failure(.serverError))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let newsFetched = try decoder.decode(NewsApi.self, from: data)
                    let news = newsFetched.articles.map { article in
                        return News(
                            title: article.title,
                            text: article.description ?? "",
                            image: article.urlToImage?.absoluteString ?? "")
                    }
                    completion(.success(news))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
