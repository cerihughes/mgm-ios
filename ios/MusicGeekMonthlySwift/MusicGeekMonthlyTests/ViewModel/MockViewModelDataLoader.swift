//
//  MockViewModelDataLoader.swift
//  MusicGeekMonthlyTests
//
//  Created by Ceri Hughes on 01/03/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class MockViewModelDataLoader: ViewModelDataLoader {
    var response: GCPDataConverterResponse = .failure(NSError())
    func loadData(_ completion: @escaping (GCPDataConverterResponse) -> Void) -> DataLoaderToken? {
        let response = self.response
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
        return MockDataLoaderToken()
    }
}
