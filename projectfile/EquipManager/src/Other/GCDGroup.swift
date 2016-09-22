//
//  GCDGroup.swift
//  GCD_test
//
//  Created by LY on 16/9/5.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDGroup: NSObject {
    var group: DispatchGroup;
    var debugInfo: Bool = false
    
    override init() {
        self.group = DispatchGroup();
        super.init();
    }
    
    func printDebugInfo(_ message: Any) {
        if(debugInfo){
            print(message);
        }
    }
    
    func regist(message: String = "", block: ()->Void) {
        self.group.enter();
        self.printDebugInfo("当前组:\(self.group) start\n消息(notify):\(message)" as AnyObject);
        block();
        self.printDebugInfo("当前组:\(self.group) end" as AnyObject)
        self.group.leave();
    }
    
    func notify(message: String = "", thread: GCDThread, block: @escaping ()->Void) {
        self.group.notify(queue: thread.queue){
            self.printDebugInfo("当前组:\(self.group)\n通知消息(notify):\(message)");
            block();
        }
    }
    
    func wait(timeout: DispatchTime = DispatchTime.distantFuture, message: String = "") -> DispatchTimeoutResult {
        self.printDebugInfo("当前组:\(self.group)\n等待消息(notify):\(message)\n等待时间:\(timeout)" as AnyObject);
        return self.group.wait(timeout: timeout);
    }
    
    func async(message: String = "", thread: GCDThread, block:@escaping ()->Void) {
        thread.queue.async(group: self.group){
            self.printDebugInfo("当前组:\(self.group)\n异步消息(notify):\(message)");
            block();
        }
    }
    
    
    
}
