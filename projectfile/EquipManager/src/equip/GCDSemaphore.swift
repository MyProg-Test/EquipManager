//
//  GCDSemaphore.swift
//  GCD_test
//
//  Created by LY on 16/9/6.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDSemaphore: NSObject {
    private var semaphore:dispatch_semaphore_t;
    private let semaphore_count:Int;
    var debugInfo: Bool = false;
    var errorInfo: Bool = true;
    var count: Int{
        get{
            return semaphore_count;
        }
    }
    
    override init() {
        semaphore_count = 1;
        semaphore = dispatch_semaphore_create(semaphore_count);
        super.init();
    }
    
    init(count: Int) {
        semaphore_count = count
        semaphore = dispatch_semaphore_create(semaphore_count);
        super.init();
    }
    
    override var description: String{
        get{
            return semaphore.description
        }
    }
    
    func printDebugInfo(message: AnyObject) {
        if(debugInfo) {
            print(message);
        }
    }
    
    func printErrorInfo(message: AnyObject) {
        if(errorInfo) {
            print(message);
        }
    }
    
    func enter(timeout: dispatch_time_t, message: String = "") -> Int {
        let rtn: Int = dispatch_semaphore_wait(self.semaphore, timeout)
        self.printDebugInfo("当前信号: \(self.semaphore.description)\n等待时间: \(timeout)\n进入消息: \(message)");
        return rtn;
    }
    
    func exit(message: String = "") -> Int {
        let rtn: Int = dispatch_semaphore_signal(self.semaphore)
        self.printDebugInfo("当前信号: \(self.semaphore.description)\n离开消息: \(message)");
        return rtn;
    }
    
}
