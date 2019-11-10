//
//  MockImageLoader.swift
//  MusicGeekMonthlyTests
//
//  Created by Ceri Hughes on 01/03/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class MockImageLoader: ImageLoader {
    var response = ImageLoaderResponse.failure(NSError())
    func loadImage(url _: URL, _ completion: @escaping (ImageLoaderResponse) -> Void) -> DataLoaderToken? {
        let response = self.response
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
        return MockDataLoaderToken()
    }
}
