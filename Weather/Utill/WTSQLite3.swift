//
//  WTSQLite3.swift
//  weather
//
//  Created by 김효원 on 02/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

class WTSQLite3 {
    var db: OpaquePointer? = nil  // SQLite 연결 정보를 담을 객체
    var stmt: OpaquePointer? = nil  // 컴파일된 SQL을 담을 객체
    var fileMgr: FileManager!
    var docPathURL: URL!
    var dbPath: String!
    
    func initDB(){
        fileMgr = FileManager()
        docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        dbPath = docPathURL?.appendingPathComponent("db.sqlite").path
    }
    
    func createTable(tbNm: String, columns: Dictionary<String, String>) -> Bool {
        var sql = "CREATE TABLE IF NOT EXISTS \(tbNm) ("
        for col in columns.keys {
            sql += "\(col) \(columns[col]!)"
            if columns.count > 1 {
                sql += ", "
            }
        }
        sql += ")"
        
        print(sql)
        
        // db 객체 생성
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            return false
        }
        
        // 구문 컴파일
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            sqlite3_close(db)
            return false
        }
        
        // 생성완료
        if sqlite3_step(stmt) != SQLITE_DONE {
            return false
        }
        sqlite3_finalize(stmt)
        sqlite3_close(db)
        
        return true
    }
}
