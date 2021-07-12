//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoLogging
import SudoApiClient

/// Queue to handle the result events from AWS.
private let dispatchQueue = DispatchQueue(label: "com.sudoplatform.query-result-handler-queue")

/// Perform an App Sync Query as an operation.
///
/// ** Generic Types **
///  - Query: GraphQLQuery subclass that is to be performed by the operation.
open class PlatformQueryOperation<Query: GraphQLQuery>: PlatformOperation {

    // MARK: - Properties

    /// Result of the operation. This will return the `Data` of the `Query`.
    open var result: Query.Data?

    /// Query performed by the operation.
    public let query: Query

    /// Cache Policy of the operation.
    public let cachePolicy: CachePolicy

    /// GraphQL client instance to perform the query.
    private unowned let graphQLClient: SudoApiClient

    /// Function used to perform service context specific error transformation of the mutation result for a service specific error.
    private let serviceErrorTransformations: [ServiceErrorTransformationCompletion]?

    // MARK: - Lifecycle

    /// Initialize a PlatformQueryOperation.
    public init(
        graphQLClient: SudoApiClient,
        serviceErrorTransformations: [ServiceErrorTransformationCompletion]? = nil,
        query: Query,
        cachePolicy: CachePolicy,
        logger: Logger
    ) {
        self.graphQLClient = graphQLClient
        self.serviceErrorTransformations = serviceErrorTransformations
        self.query = query
        self.cachePolicy = cachePolicy
        super.init(logger: logger)
    }

    // MARK: - Overrides

    open override func execute() {
        let cachePolicy = self.cachePolicy.toAWSCachePolicy()
        do {
            try self.graphQLClient.fetch(
                query: query,
                cachePolicy: cachePolicy,
                queue: dispatchQueue,
                resultHandler: { [weak self] (queryResult, error) in
                    guard let self = self else {
                        return
                    }
                    if let error = error {
                        switch error {
                        case ApiOperationError.graphQLError(let cause):
                            if let serviceErrorTransformations = self.serviceErrorTransformations,
                               let serviceError = serviceErrorTransformations.compactMap({$0(cause)}).first {
                                self.finishWithError(serviceError)
                            } else {
                                self.finishWithError(SudoPlatformError(cause))
                            }
                        default:
                            self.finishWithError(error)
                        }
                        return
                    }
                    self.result = queryResult?.data
                    self.finish()
                }
            )
        } catch {
            self.finishWithError(error)
        }
    }

}
