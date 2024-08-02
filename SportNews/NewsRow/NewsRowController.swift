//
//  NewsRowController.swift
//  SportNews
//
//  Created by マフディ　ハリス on 30/07/24.
//

import Foundation
import UIKit

class NewsRowCell: UITableViewCell {
    let titleLabel = UILabel()
    let previewText = UILabel()
    var thumbnail = UIImageView()
    
    static let reuseID = "NewsRowCell"
    
    struct ViewModel {
        let title: String
        let text: String
        let image: String
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Cell Called")
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from imageURL: String) {
        guard let imageUrl = URL(string: imageURL) else { return }

        // Fetch image data from the URL
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Create an image object
            let image = UIImage(data: data)
            
            // Update UI on the main thread
            DispatchQueue.main.async {
                self.thumbnail.image = image
            }
        }
        task.resume()
    }

    private func setup() {
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.layer.cornerRadius = 12
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleLabel.text
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = UIColor.systemGray
        titleLabel.numberOfLines = 2
        
        previewText.translatesAutoresizingMaskIntoConstraints = false
        previewText.text = previewText.text
        previewText.numberOfLines = 3
        previewText.font = UIFont.preferredFont(forTextStyle: .footnote)
        previewText.textColor = UIColor.systemGray2
    }
    
    private func layout() {
        contentView.addSubview(thumbnail)
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewText)
        
        // thumbnail
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            thumbnail.widthAnchor.constraint(equalToConstant: 50),
            thumbnail.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
        ])
        
        // previewText
        NSLayoutConstraint.activate([
            previewText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            previewText.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 8),
            previewText.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}

extension NewsRowCell {
    func configure(with vm: ViewModel) {
//        print(vm, "vm")
        titleLabel.text = vm.title
        previewText.text = vm.text
        self.loadImage(from: vm.image)
//        thumbnail.image = self.loadImage(from: vm.image)
    }
}
