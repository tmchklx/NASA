//
//  Logger.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import Foundation

class Logger {
    private enum LogLevel: String {
        case error = "[❌ ERROR]"
        case warning = "[⚠️ WARNING]"
        case info = "[ℹ️ INFO]"
        case debug = "[🔧 DEBUG]"
    }

    private static func log<T>(
        _ level: LogLevel,
        _ message: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line)] \(function) - \(message)"
        NSLog("%@", logMessage)
    }

    static func error<T>(
        _ message: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.error, message, file: file, function: function, line: line)
    }

    static func warning<T>(
        _ message: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.warning, message, file: file, function: function, line: line)
    }

    static func info<T>(
        _ message: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.info, message, file: file, function: function, line: line)
    }

    static func debug<T>(
        _ message: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.debug, message, file: file, function: function, line: line)
    }
}
