//
//  File 2.swift
//
//
//  Created by Ben Roaman on 3/24/25.
//

import Foundation
import Combine

// MARK: Requirements
public protocol BRSetting {
    associatedtype Value
    
    static var key: String { get }
    static var initial: Value { get }
    static var current: Value { get }
    static func set(_ value: Value)
    static func read() -> Value
    static func clear()
    static var pub: CurrentValueSubject<Value, Never> { get }
    static func subscribe(_ receiveValue: @escaping (Value) -> Void) -> AnyCancellable
}

// MARK: Global Implementations
public extension BRSetting {
    static var current: Value { read() }
    static func clear() { UserDefaults.standard.removeObject(forKey: key) }
    static func subscribe(_ receiveValue: @escaping (Value) -> Void) -> AnyCancellable { pub.sink(receiveValue: receiveValue) }
}

// MARK: String Implementations
public extension BRSetting where Self.Value == String {
    static private func read() -> Value { UserDefaults.standard.string(forKey: key) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
}

// MARK: Int Implementations
public extension BRSetting where Self.Value == Int {
    static func read() -> Value { (UserDefaults.standard.dictionaryRepresentation()[key] as? Int) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
}

// MARK: Float Implementations
public extension BRSetting where Self.Value == Float {
    static func read() -> Value { (UserDefaults.standard.dictionaryRepresentation()[key] as? Float) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
}

// MARK: Double Implementations
public extension BRSetting where Self.Value == Double {
    static func read() -> Value { (UserDefaults.standard.dictionaryRepresentation()[key] as? Double) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
}


// MARK: Bool Implementations
public extension BRSetting where Self.Value == Bool {
    static func read() -> Value { (UserDefaults.standard.dictionaryRepresentation()[key] as? Bool) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
}

public extension BRSetting where Self.Value == Bool {
    static func toggle() { set(!current) }
}

// MARK: RawRepresentable<String> Implementations
public extension BRSetting where Self.Value: RawRepresentable<String> {
    static func read() -> Value { Value(UserDefaults.standard.string(forKey: key)) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value.rawValue, forKey: key)
        pub.send(value)
    }
}

public extension BRSetting where Self.Value: RawRepresentable<String> & Codable {
    static func read() -> Value { Value(UserDefaults.standard.string(forKey: key)) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value.rawValue, forKey: key)
        pub.send(value)
    }
}

// MARK: RawRepresentable<Int> Implementations
public extension BRSetting where Self.Value: RawRepresentable<Int> {
    static func read() -> Value { Value((UserDefaults.standard.dictionaryRepresentation()[key] as? Int)) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value.rawValue, forKey: key)
        pub.send(value)
    }
}

// MARK: Set<Int> Convenience
public extension BRSetting where Self.Value == Set<Int> {
    static func insert(_ value: Int) {
        var result = current
        result.insert(value)
        set(result)
    }
    
    static func insert(_ values: any Sequence<Int>) {
        set(current.union(values))
    }
    
    static func remove(_ values: any Sequence<Int>) {
        set(current.subtracting(values))
    }
    
    static func remove(_ value: Int) {
        var result = current
        result.remove(value)
        set(result)
    }
}

// MARK: Set<String> Convenience
public extension BRSetting where Self.Value == Set<String> {
    static func insert(_ value: String) {
        var result = current
        result.insert(value)
        set(result)
    }
    
    static func insert(_ values: any Sequence<String>) {
        set(current.union(values))
    }
    
    static func remove(_ values: any Sequence<String>) {
        set(current.subtracting(values))
    }
    
    static func remove(_ value: String) {
        var result = current
        result.remove(value)
        set(result)
    }
}

// MARK: Date Implementations
public extension BRSetting where Self.Value == Date {
    static func read() -> Value { (UserDefaults.standard.object(forKey: key) as? Date) ?? initial }
    static func set(_ value: Value) {
        UserDefaults.standard.set(value, forKey: key)
        pub.send(value)
    }
    static func setNow() { set(Date()) }
}

// MARK: Codable Implementations
public extension BRSetting where Self.Value: Codable {
    static func read() -> Value {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let object = try? JSONDecoder().decode(Value.self, from: data) {
                return object
            } else {
                print("BRSetting :: Failed to decode \(Value.self) for key \(key)")
            }
        }
        return initial
    }
    
    static func set(_ value: Value) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
            pub.send(value)
        } else {
            print("BRSetting :: Failed to encode \(Value.self) for key \(key)")
        }
    }
}

public extension BRSetting {
    static func reset() { set(initial) }
}

internal extension RawRepresentable {
    init?(_ raw: RawValue?) {
        guard let raw = raw else { return nil }
        self.init(rawValue: raw)
    }
}
