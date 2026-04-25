//
//  TransactionListViewModel.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-22.
//

import Foundation
import Combine

protocol TransactionListViewProtocol: AnyObject {
    func fetchTransactions()
}

@MainActor
final class TransactionListViewModel: TransactionListViewProtocol {
    
    @Published var response: TransactionResponse = TransactionResponse(transactions: [])
    @Published private(set) var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var isLoading = false
    
    private var transactionListService: TransactionListServiceProtocol
    
    lazy var navigationTitle: String = "Transactions"
    
    init(transactionListService: TransactionListServiceProtocol) {
        self.transactionListService = transactionListService
    }
    
    func fetchTransactions() {
        self.isLoading = true
        errorMessage = nil
        
        self.transactionListService.fetchTransactions()
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case let .failure(error) = completion {
                    self?.errorMessage = NetworkError.dataLoadFailed(error: error).errorDescription
                }
            } receiveValue: { [weak self] transactions in
                self?.response = transactions
            }.store(in: &cancellables)
    }
}
