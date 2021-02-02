//
//  LoginDataPreprocessor.swift
//  idJack
//
//  Created by Martin Daum on 10.09.20.
//

import Foundation
import Alamofire

public protocol JSONDataPreprocessor: DataPreprocessor {
    func preprocessJSON(_ jsonData: [String: Any]) -> [String: Any]
}

extension JSONDataPreprocessor {
    public func preprocess(_ data: Data) throws -> Data {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return data
        }
        
        let processedJSON = preprocessJSON(json)
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: processedJSON, options: .prettyPrinted) else {
            return data
        }
        
        return jsonData
    }
}

// MARK: Dictionary helpers

extension Dictionary {
    public subscript(keyPath string: String) -> Value? {
        get {
            return self[keyPath: Dictionary.keyPath(for: string)]
        }
        set {
            self[keyPath: Dictionary.keyPath(for: string)] = newValue
        }
    }
    
    public subscript(keyPath keyPath: Key...) -> Value? {
        get {
            return self[keyPath: keyPath]
        }
        set {
            self[keyPath: keyPath] = newValue
        }
    }
    
    public subscript(keyPath keyPath: [Key]) -> Value? {
        get {
            guard !keyPath.isEmpty else { return nil }
            return getValue(forKeyPath: keyPath)
        }
        set {
            guard !keyPath.isEmpty else { return }
            self.setValue(newValue, forKeyPath: keyPath)
            if newValue == nil {
                cleanUp(forKeyPath: keyPath)
            }
        }
    }
    
    @discardableResult
    public mutating func remove(keyPath: [Key]) -> Value? {
        guard !keyPath.isEmpty else { return nil }
        let value = getValue(forKeyPath: keyPath)
        setValue(nil, forKeyPath: keyPath)
        return value
    }
    
    static private func keyPath(for keyPathString: String) -> [Key] {
        let keys = keyPathString.components(separatedBy: ".")
        return keys.compactMap({ $0 as? Key })
    }
    
    private func getValue(forKeyPath keyPath: [Key]) -> Value? {
        guard let value = self[keyPath.first!] else { return nil }
        return keyPath.count == 1 ? value : (value as? [Key: Value])
            .flatMap { $0.getValue(forKeyPath: Array(keyPath.dropFirst())) }
    }
    
    private mutating func setValue(_ value: Value?, forKeyPath keyPath: [Key]) {
        if let first = keyPath.first, keyPath.count == 1 {
            self[first] = value
        } else {
            guard let first = keyPath.first else { return }
            var subDict = self[first] as? [Key: Value] ?? [Key: Value]()
            subDict.setValue(value, forKeyPath: Array(keyPath.dropFirst()))
            self[first] = subDict as? Value
        }
    }
    
    private mutating func cleanUp(forKeyPath keyPath: [Key]) {
        guard !keyPath.isEmpty else { return }
        
        if let value = getValue(forKeyPath: keyPath) {
            guard let dict = value as? [Key: Value], dict.isEmpty else {
                return
            }
            setValue(nil, forKeyPath: keyPath)
        }
        cleanUp(forKeyPath: Array(keyPath.dropLast()))
    }
}
