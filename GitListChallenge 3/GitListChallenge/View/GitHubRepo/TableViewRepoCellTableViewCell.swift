//
//  TableViewRepoCellTableViewCell.swift
//  GitListChallenge
//
//

import UIKit

class TableViewRepoCellTableViewCell: UITableViewCell {

    let repoNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let forkLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let textStackView = UIStackView(arrangedSubviews: [forkLabel, starLabel])
        textStackView.axis = .vertical
        //textStackView.alignment = .fill
        textStackView.distribution = .fillEqually
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textStackView)
        self.contentView.addSubview(repoNameLabel)
        
        NSLayoutConstraint.activate([
            
            repoNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            repoNameLabel.trailingAnchor.constraint(equalTo: textStackView.leadingAnchor, constant: 8),
            repoNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
//            textStackView.leadingAnchor.constraint(equalTo: repoNameLabel.trailingAnchor, constant: 8),
            textStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
            ])
        
        let constraint = repoNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        constraint.priority = .defaultHigh
        constraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
