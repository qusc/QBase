//
//  UUID+data.swift
//  VoiceBeam
//
//  Created by Quirin Schweigert on 02.12.21.
//

import Foundation

public extension UUID {
    public var data: Data {
        return withUnsafePointer(to: self) {
            Data(bytes: $0, count: MemoryLayout.size(ofValue: self))
        }
    }

    public init?(data: Data) throws {
        guard data.count == MemoryLayout<UUID>.size else {
            return nil
        }

        var uuid = UUID()

        _ = withUnsafeMutableBytes(of: &uuid) { unsafeMutableRawBufferPointer in
            data.copyBytes(to: unsafeMutableRawBufferPointer)
        }

        self = uuid
    }
}
