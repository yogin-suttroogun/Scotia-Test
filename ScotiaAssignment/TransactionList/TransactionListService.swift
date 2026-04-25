//
//  TransactionListService.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-22.
//

import Foundation
import Combine

protocol TransactionListServiceProtocol {
    func fetchTransactions() -> AnyPublisher<TransactionResponse, Error>
}

final class TransactionListService: TransactionListServiceProtocol {
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func fetchTransactions() -> AnyPublisher<TransactionResponse, Error> {
        return Deferred {
            Future { [self] promise in
                guard
                    let url = bundle.url(forResource: "transaction-list", withExtension: "json")
                else {
                    promise(.failure(NetworkError.fileNotFound(name: "transaction-list")))
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .formatted(TransactionFormatters.apiDateFormatter)
                    
                    let response = try decoder.decode(TransactionResponse.self, from: data)
                    let sortedResponse = response.transactions.sorted(by: {$0.postedDate > $1.postedDate})
                    
                    promise(.success(TransactionResponse(transactions: sortedResponse)))
                } catch {
                    promise(.failure(NetworkError.decodingFailed(error: error)))
                }
            }
        }.eraseToAnyPublisher()
    }
}
