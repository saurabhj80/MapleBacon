//
// Copyright (c) 2015 Zalando SE. All rights reserved.
//

import UIKit

public protocol Storage {

    func storeImage(image: UIImage, data: NSData?, forKey key: String)

    func image(forKey key: String) -> UIImage?

    func removeImage(forKey key: String)

    func clearStorage()

}

public protocol CombinedStorage {

    func clearMemoryStorage()

}

public final class MapleBaconStorage: Storage, CombinedStorage {

    private let inMemoryStorage: Storage
    private let diskStorage: Storage

    public static let sharedStorage = MapleBaconStorage()

    init() {
        inMemoryStorage = InMemoryStorage.sharedStorage
        diskStorage = DiskStorage.sharedStorage
    }

    public func storeImage(image: UIImage, data: NSData?, forKey key: String) {
        inMemoryStorage.storeImage(image, data: data, forKey: key)
        diskStorage.storeImage(image, data: data, forKey: key)
    }

    public func image(forKey key: String) -> UIImage? {
        if let image = inMemoryStorage.image(forKey: key) {
            return image
        }
        if let image = diskStorage.image(forKey: key) {
            inMemoryStorage.storeImage(image, data: nil, forKey: key)
            return image
        }
        return nil
    }

    public func removeImage(forKey key: String) {
        inMemoryStorage.removeImage(forKey: key)
        diskStorage.removeImage(forKey: key)
    }

    public func clearStorage() {
        inMemoryStorage.clearStorage()
        diskStorage.clearStorage()
    }

    public func clearMemoryStorage() {
        inMemoryStorage.clearStorage()
    }

}
