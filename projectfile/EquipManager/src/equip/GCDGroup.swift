//
//  GCDGroup.swift
//  GCD_test
//
//  Created by LY on 16/9/5.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDGroup: NSObject {
    var group: dispatch_group_t;
    var debugInfo: Bool = false
    
    override init() {
        self.group = dispatch_group_create();
        super.init();
    }
    
    func printDebugInfo(message: AnyObject) {
        if(debugInfo){
            print(message);
        }
    }
    
    func regist(message: String = "", _ block: dispatch_block_t) {
        dispatch_group_enter(self.group);
        self.printDebugInfo("当前组:\(self.group) start\n消息(notify):\(message)");
        block();
        self.printDebugInfo("当前组:\(self.group) end")
        dispatch_group_leave(self.group);
    }
    
    func notify(message: String = "", thread: GCDThread, _ block: dispatch_block_t) {
        dispatch_group_notify(self.group, thread.queue){
            self.printDebugInfo("当前组:\(self.group)\n通知消息(notify):\(message)");
            block();
        }
    }
    
    func wait(timeout: dispatch_time_t = DISPATCH_TIME_FOREVER, message: String = "") -> Int {
        self.printDebugInfo("当前组:\(self.group)\n等待消息(notify):\(message)\n等待时间:\(timeout)");
        return dispatch_group_wait(self.group, timeout);
    }
    
    func async(message: String = "", thread: GCDThread, _ block:dispatch_block_t) {
        dispatch_group_async(self.group, thread.queue){
            self.printDebugInfo("当前组:\(self.group)\n异步消息(notify):\(message)");
            block();
        }
    }
    
    
    
}
