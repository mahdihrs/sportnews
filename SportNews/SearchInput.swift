//
//  SearchInput.swift
//  SportNews
//
//  Created by マフディ　ハリス on 11/08/24.
//

import Foundation
import UIKit

protocol SearchInputDelegate: AnyObject {
    func searchQuery(q: String)
}

class NewsSearchInput: UIView {
    let searchInput = UITextField()
    
    weak var delegate: SearchInputDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        searchInput.delegate = self
        searchInput.translatesAutoresizingMaskIntoConstraints = false
        searchInput.placeholder = "Search"
        searchInput.backgroundColor = .cyan
    }
    
    private func layout() {
        addSubview(searchInput)
        NSLayoutConstraint.activate([
            searchInput.topAnchor.constraint(equalTo: topAnchor),
            searchInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInput.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}


extension NewsSearchInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchQuery(q: textField.text!)
        searchInput.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
