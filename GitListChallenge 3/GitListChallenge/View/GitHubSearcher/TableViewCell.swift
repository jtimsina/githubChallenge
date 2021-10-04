//
//  TableViewCell.swift
//
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let gitImageView : LazyLoading = {
        let image = LazyLoading(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Image")
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.clipsToBounds = true
        return image
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let detailLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fillEqually
        textStackView.spacing = 5
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textStackView)
        self.contentView.addSubview(gitImageView)
        
        NSLayoutConstraint.activate([
            
            gitImageView.trailingAnchor.constraint(equalTo: textStackView.leadingAnchor, constant: -8),
            gitImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            gitImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            textStackView.centerYAnchor.constraint(equalTo: gitImageView.centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            ])
        
        let constraint = gitImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        constraint.priority = .defaultHigh
        constraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gitImageView.image = UIImage(named: "Image")
        titleLabel.text = nil
        detailLabel.text = nil
    }
    
}
