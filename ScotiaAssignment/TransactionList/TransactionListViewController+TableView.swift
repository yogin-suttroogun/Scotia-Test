//
//  TransactionListViewController+TableView.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-23.
//

import UIKit

// MARK: - Data source
extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.response.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? TransactionListTableViewCell
        else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.configure(with: viewModel.response.transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Delegate
extension TransactionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionModel = viewModel.response.transactions[indexPath.row]
        let detailsViewModel = TransactionDetailsViewModel(model: transactionModel)
        let viewController = TransactionDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
