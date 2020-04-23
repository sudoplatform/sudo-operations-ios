//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync

/// Cache policy that determines how data is accessed when performing a `PlatformQueryOperation`.
public enum CachePolicy {
    /// Use the device cached data.
    case useCache
    /// Query and use the data on the server.
    case useOnline

    // MARK: - Internal

    /// Converts `Self` to the matching AWS `CachePolicy`.
    func toAWSCachePolicy() -> AWSAppSync.CachePolicy {
        switch self {
        case .useCache:
            return AWSAppSync.CachePolicy.returnCacheDataDontFetch
        case .useOnline:
            return AWSAppSync.CachePolicy.fetchIgnoringCacheData
        }
    }
}
