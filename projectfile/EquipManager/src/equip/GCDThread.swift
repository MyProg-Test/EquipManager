//
//  File.swift
//  GCD_test
//
//  Created by LY on 16/9/5.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDThread: NSObject {
    
    var queue:dispatch_queue_t;
    var debugInfo:Bool = false;
    var errorInfo:Bool = true;
    var queueInfo:String{
        get{
            return queue.description;
        }
    };
    var onceFlag:dispatch_once_t = 0;
    
    init(global:Int, flags: UInt) {
        queue = dispatch_get_global_queue(global, flags);
        super.init();
    }
    
    override init() {
        queue = dispatch_get_main_queue();
        super.init();
    }
    
    init(label: String, attr: dispatch_queue_attr_t) {
        queue = dispatch_queue_create(label, attr);
        super.init();
    }
    
    func printDebugInfo(message: AnyObject){
        if(debugInfo) {
            print(message);
        }
    }
    
    func printErrorInfo(message: AnyObject) {
        if(errorInfo) {
            print(message);
        }
    }
    
    func async(message:String = "",_ block:dispatch_block_t!) {
        dispatch_async(self.queue){
            self.printDebugInfo("当前队列:\(self.queueInfo)\n异步消息(async):\(message)");
            block();
        };
    }
    
    func sync(message:String = "",_ block:dispatch_block_t!) {
        dispatch_sync(self.queue){
            self.printDebugInfo("当前队列:\(self.queueInfo)\n同步消息(sync):\(message)");
            block();
        };
    }
    
    func after(delay:Double, message:String = "",_ block:dispatch_block_t!){
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            self.queue){
                self.printDebugInfo("当前队列:\(self.queueInfo)\n延迟消息(after):\(message)");
                block();
        }
    }
    
    func apply(iterations:Int, message:String = "", _ block:((Int) -> Void)!){
        self.printDebugInfo("当前队列: \(queueInfo)\n多次消息(apply): \(message)");
        dispatch_apply(iterations, self.queue, block);
    }
    
    func once(message:String = "",_ block:dispatch_block_t) {
        if(self.onceFlag != 0){
            printErrorInfo("已经执行过,请重设当前状态(resetOnceState)");
        }
        dispatch_once(&self.onceFlag){
            self.printDebugInfo("当前队列: \(self.queueInfo)\n只执行一次消息(once): \(message)");
            block();
        };
    }
    
    func resetOnce() {
        self.printDebugInfo("当前状态(once): \(self.onceFlag)\n重设状态为0");
        self.onceFlag = 0;
    }
    
    
}
