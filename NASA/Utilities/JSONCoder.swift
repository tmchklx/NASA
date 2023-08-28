//
//  JSONCoder.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/28/23.
//

import Foundation

final class JSONCoder {
    let encoder: JSONEncoder
    let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
    }

    func encode<T: Encodable>(_ item: T) throws -> Data {
        do {
            return try encoder.encode(item)
        } catch let error as EncodingError {
            switch error {
            case .invalidValue(_, let context):
                Logger.error("Encoding error (invalidValue): \(context.debugDescription)")
            @unknown default:
                Logger.error("Encoding error (unknownError)")
            }

            throw error
        }
    }

    func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(_, let context):
                Logger.error("Decoding error (keyNotFound): \(context.debugDescription)")
            case .valueNotFound(_, let context):
                Logger.error("Decoding error (valueNotFound): \(context.debugDescription)")
            case .typeMismatch(_, let context):
                Logger.error("Decoding error (typeMismatch): \(context.debugDescription)")
            case .dataCorrupted(let context):
                Logger.error("Decoding error (dataCorrupted): \(context.debugDescription)")
            @unknown default:
                Logger.error("Decoding error (unknownError)")
            }

            throw error
        }
    }
}
