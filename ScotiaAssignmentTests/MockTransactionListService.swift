//
//  MockTransactionListService.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-25.
//

import XCTest
import Combine
@testable import ScotiaAssignment

// MARK: - Mock Service

final class MockTransactionListService: TransactionListServiceProtocol {
    var result: Result<TransactionResponse, Error> = .success(TransactionResponse(transactions: []))
    var fetchCallCount = 0

    func fetchTransactions() -> AnyPublisher<TransactionResponse, Error> {
        fetchCallCount += 1
        return result.publisher.eraseToAnyPublisher()
    }
}
