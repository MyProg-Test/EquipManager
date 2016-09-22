//
//  GCDSemaphore.swift
//  GCD_test
//
//  Created by LY on 16/9/6.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDSemaphore: NSObject {
    fileprivate var semaphore:DispatchSemaphore;
    fileprivate let semaphore_count:Int;
    var debugInfo: Bool = false;
    var errorInfo: Bool = true;
    var count: Int{
        get{
            return semaphore_count;
        }
    }
    
    override init() {
        semaphore_count = 1;
        semaphore = DispatchSemaphore(value: semaphore_count);
        super.init();
    }
    
    init(count: Int) {
        semaphore_count = count
        semaphore = DispatchSemaphore(value: semaphore_count);
        super.init();
    }
    
    override var description: String{
        get{
            return semaphore.description
        }
    }
    
    func printDebugInfo(_ message: Any) {
        if(debugInfo) {
            print(message);
        }
    }
    
    func printErrorInfo(_ message: Any) {
        if(errorInfo) {
            print(message);
        }
    }
    
    func enter(timeout: DispatchTime = .distantFuture, message: Any = "") -> DispatchTimeoutResult {
        let rtn: DispatchTimeoutResult = self.semaphore.wait(timeout: timeout)
        self.printDebugInfo("当前信号: \(self.semaphore.description)\n等待时间: \(timeout)\n进入消息: \(message)");
        return rtn;
    }
    
    func exit(message: Any = "") -> Int {
        let rtn: Int = self.semaphore.signal()
        self.printDebugInfo("当前信号: \(self.semaphore.description)\n离开消息: \(message)");
        return rtn;
    }
    
}
