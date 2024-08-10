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
    let imagePlaceholder = UIView()
    let placeholderText = UILabel()
    
    static let reuseID = "NewsRowCell"
    
    struct ViewModel {
        let title: String
        let text: String
        let image: String
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Cell Called")
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
//        thumbnail.layer.cornerRadius = 8
        thumbnail.contentMode = .scaleAspectFill
//        thumbnail.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleLabel.text
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        titleLabel.textColor = UIColor.systemGray
        titleLabel.numberOfLines = 3
        
        previewText.translatesAutoresizingMaskIntoConstraints = false
        previewText.text = previewText.text
        previewText.numberOfLines = 4
        previewText.font = UIFont.preferredFont(forTextStyle: .footnote)
        previewText.textColor = UIColor.systemGray
        
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.backgroundColor = .systemGray
        
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.text = "Preview Image Unavailable"
        placeholderText.textAlignment = .center
    }
    
    private func layout(showImage: Bool) {
        if (showImage) {
            contentView.addSubview(thumbnail)
            // thumbnail
            NSLayoutConstraint.activate([
                thumbnail.topAnchor.constraint(equalTo: topAnchor),
                thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
                thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor),
                thumbnail.heightAnchor.constraint(equalToConstant: 180)
            ])
        } else {
            contentView.addSubview(imagePlaceholder)
            contentView.addSubview(placeholderText)
            // image placeholder
            NSLayoutConstraint.activate([
                imagePlaceholder.topAnchor.constraint(equalTo: topAnchor),
                imagePlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor),
                imagePlaceholder.trailingAnchor.constraint(equalTo: trailingAnchor),
                imagePlaceholder.heightAnchor.constraint(equalToConstant: 180),
                imagePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
            ])
            NSLayoutConstraint.activate([
                placeholderText.widthAnchor.constraint(equalTo: widthAnchor),
                placeholderText.topAnchor.constraint(equalTo: imagePlaceholder.centerYAnchor)
            ])
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(previewText)
    
        let imageElement = showImage ? thumbnail : imagePlaceholder
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageElement.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        // previewText
        NSLayoutConstraint.activate([
            previewText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            previewText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            previewText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

extension NewsRowCell {
    func configure(with vm: ViewModel) {
//        print(vm.image, "vm", vm.title)
        setup()
        if vm.image.isEmpty {
            layout(showImage: false)
        } else {
            self.loadImage(from: vm.image)
            layout(showImage: true)
        }
        titleLabel.text = vm.title
        previewText.text = vm.text
    }
}
