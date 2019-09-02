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
    
    func initDB(){
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPathURL?.appendingPathComponent("db.sqlite").path
        
    }
}
