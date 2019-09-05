//
//  WTSQLite3.swift
//  weather
//
//  Created by 김효원 on 02/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

class DBManager {
    var stmt: OpaquePointer? = nil  // 컴파일된 SQL을 담을 객체
    var fileMgr: FileManager!
    var docPathURL: URL!
    var dbPath: String!
    
    func initDB(){
        fileMgr = FileManager()
        docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        // dbPath 경로에 db.sqlite 파일이 없다면 앱 번들에 만들어 둔 db.sqlite를 가져와 복사한다.
        if !fileMgr.fileExists(atPath: dbPath) {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")!
            try! fileMgr.copyItem(atPath: dbSource, toPath: dbPath)
        }
    }
    
    func sendDB(_ sql: String) -> Bool {
        var db: OpaquePointer? = nil  // SQLite 연결 정보를 담을 객체
        
        // db 객체 생성
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            return false
        }
        
        defer{
            sqlite3_close(db)
        }
        
        // 구문 컴파일
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            return false
        }
        
        defer {
            sqlite3_finalize(stmt)
        }
        
        // 생성완료
        if sqlite3_step(stmt) != SQLITE_DONE {
            return false
        }
        
        return true
    }
    
    
    // MARK: - 테이블 값 insert
    func insert(tbNm: String, columns: Dictionary<String, String>) -> Bool {
        var sql = "CREATE TABLE IF NOT EXISTS \(tbNm) ("
        for col in columns.keys {
            sql += "\(col) \(columns[col]!)"
            if columns.count > 1 {
                sql += ", "
            }
        }
        sql += ")"
        
        print(sql)
        return sendDB(sql)
    }
    
    
    // MARK: - 테이블 생성
    func create(tbNm: String, columns: Dictionary<String, String>) -> Bool {
        var sql = "CREATE TABLE IF NOT EXISTS \(tbNm) ("
        for col in columns.keys {
            sql += "\(col) \(columns[col]!)"
            if columns.count > 1 {
                sql += ", "
            }
        }
        sql += ")"
        
        print(sql)
        return sendDB(sql)
    }
}
