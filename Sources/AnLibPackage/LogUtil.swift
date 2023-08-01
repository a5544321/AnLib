//
//  LogUtil.swift
//  AnLib
//
//  Created by Andy on 2022/11/22.
//

import Foundation

public class LogUtil {
    static let shared: LogUtil = LogUtil()
    var directoryPath: URL {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("log", isDirectory: true)
    }
    var fileName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter.string(from: Date()) + ".txt"
    }
    public static func initialized() {
        let fm = FileManager.default
        let path = shared.directoryPath
        try? fm.createDirectory(at: path, withIntermediateDirectories: true)
        record("App initialized")
    }
    
    public static func record(_ string: String) {
        
        let file = shared.directoryPath.appendingPathComponent(shared.fileName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
//        formatter.timeZone = TimeZone(identifier: "GMT")
        let record = formatter.string(from: Date()) + "  " + string + "\n"
        
        if let handle = try? FileHandle(forWritingTo: file) {
            handle.seekToEndOfFile()
            handle.write(record.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? record.data(using: .utf8)?.write(to: file)
        }
        
        print(record)
        
    }
}
