//
//  TransactionListTableViewCell.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-23.
//

import UIKit

final class TransactionListTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "TransactionListTableViewCell"
    
    // MARK: - UI element
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.separator.cgColor
        view.backgroundColor = .lightGray.withAlphaComponent(0.15)
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var leftSideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        contentStackView.addArrangedSubview(leftSideStackView)
        contentStackView.addArrangedSubview(amountLabel)
        
        leftSideStackView.addArrangedSubview(titleLabel)
        leftSideStackView.addArrangedSubview(subtitleLabel)
        leftSideStackView.addArrangedSubview(dateLabel)
        
        cardView.addSubview(contentStackView)
        contentView.addSubview(cardView)
        
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure data
    func configure(with model: TransactionModel?) {
        guard
            let model = model
        else {
            return
        }
        titleLabel.text = model.merchantName
        subtitleLabel.text = model.description
        dateLabel.text = TransactionFormatters.displayDate(model.postedDate)
        amountLabel.textColor = model.transactionType == .credit ? .systemGreen : .systemRed
        amountLabel.text = TransactionFormatters.amountWithTransactionType(transaction: model)
        
    }
}
