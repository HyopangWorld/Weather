//
//  ApiClient.swift
//  Ceramics
//
//  Created by 김효원 on 03/08/2019.
//  Copyright © 2019 김효원. All rights reserved.
//

import Foundation
import NetworkExtension


// MARK: - request를 위한 interface
public protocol NetworkRequest {
    func request(
        _ url: String,
        success: @escaping (Data) -> Void,
        fail: @escaping (NSError?) -> Void)
}


public class ApiClient: NetworkRequest {
    
    public func request(_ url: String, success: @escaping (Data) -> Void, fail: @escaping (NSError?) -> Void) {
        do {
            // 인터넷 연결 확인
            let network = NWPath.init()
            if network.status == NWPathStatus.unsatisfied {
                print("testtestset: \(network.status)")
            }
            
            // url 생성
            guard let apiURI = URL(string:"\(WTUrl.prefixUrl)/\(url)") else {
                print("Invalid API URL)")
                return
            }
            NSLog("==========> [Request] URL = \(url)\n\n")
            
            // REST API 호출
            let data = try Data(contentsOf: apiURI)
            
            // 로그 출력
            let log = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "" //NSString으로 인코딩
            NSLog("==========> [Response] Data = \(log)")
            
            success(data)
            
        } catch let err as NSError {
            // error 처리
            NSLog(err.localizedDescription)
            
            fail(err)
        }
    }
}

