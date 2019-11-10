import Foundation

class MockDataLoaderToken: DataLoaderToken {
    var cancelled = false

    func cancel() {
        cancelled = true
    }
}

private typealias DataLoaderTuple = (response: DataLoaderResponse, token: DataLoaderToken)

class MockDataLoader: DataLoader {
    var delay: TimeInterval = 0

    private var urlResponses: [URL: DataLoaderTuple] = [:]
    var requestedURLs: [URL] = []

    // MARK: DataLoader

    func loadData(url: URL, _ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        requestedURLs.append(url)
        return fire(completion, with: urlResponses[url])
    }

    // MARK: "Mocking" API

    func expectLoadData(with url: URL, completeWith response: DataLoaderResponse, andReturn token: DataLoaderToken) {
        urlResponses[url] = (response: response, token: token)
    }

    // MARK: Private

    private func fire(_ completion: @escaping (DataLoaderResponse) -> Void, with tuple: DataLoaderTuple?) -> DataLoaderToken? {
        guard let tuple = tuple else {
            return nil
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(tuple.response)
        }

        return tuple.token
    }
}
