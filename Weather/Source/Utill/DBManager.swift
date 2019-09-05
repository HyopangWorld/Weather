//
//  WTSQLite3.swift
//  weather
//
//  Created by 김효원 on 02/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
// 사용하지 않음.

import Foundation
import FMDB

class DBManager {
    var db: FMDatabase!
    var fileMgr: FileManager!
    var docPathURL: URL!
    var dbPath: String!
    
    func initDB(){
        fileMgr = FileManager()
        docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        dbPath = docPathURL.appendingPathComponent("db.sqlite").path
    }
    
    func selectAll(tbNm: String) -> FMResultSet? {
        db = FMDatabase(path: dbPath)
        
        // db 객체 생성
        if !db.open() {
            return nil
        }
        
        defer {
            db.close()
        }
        
        let sql = "SELECT * FROM \(tbNm)"
        print(">>>>>>>> QUARY <<<<<<<<\n\(sql)")
        
        do {
            let result  = try db.executeQuery(sql, values: nil)
            return result
            
        } catch let err as NSError {
            print(err.description)
            return nil
        }
    }
    
    
    func insert(tbNm: String, columns: Array<String>, values: Array<String>) -> Bool {
        db = FMDatabase(path: dbPath)
        
        // db 객체 생성
        if !db.open() {
            return false
        }
        
        defer {
            db.close()
        }
        
        var sql = "INSERT INTO \(tbNm) ("
        var val = ""
        for col in columns {
            sql += "\(col)"
            val += "?"
            if columns.count > 1 && !((columns.count - 1) < (columns.firstIndex(of: col)!)) {
                sql += ", "
                val += ", "
            }
        }
        sql += ") VALUES (\(val))"
        print(">>>>>>>> QUARY <<<<<<<<\n\(sql)")
        
        guard db.executeUpdate(sql, withArgumentsIn: values) else {
            return false
        }
        
        return true
    }
    
    func create(tbNm: String, columns: Dictionary<String, String>) -> Bool {
        db = FMDatabase(path: dbPath)
        
        // db 객체 생성
        if !db.open() {
            return false
        }
        
        defer {
            db.close()
        }
        
        var sql = "CREATE TABLE IF NOT EXISTS \(tbNm) ("
        for col in columns.keys {
            sql += "\(col) \(columns[col]!)"
            if columns.count > 1 && !((columns.count - 1) < (columns.index(forKey: col)!).hashValue) {
                sql += ", "
            }
        }
        sql += ")"
        print(">>>>>>>> QUARY <<<<<<<<\n\(sql)")
        
        guard db.executeStatements(sql) else {
            return false
        }
        
        return true
    }
}
