//
//  File.swift
//  GCD_test
//
//  Created by LY on 16/9/5.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit

class GCDThread: NSObject {
    
    var queue:DispatchQueue;
    var debugInfo:Bool = false;
    var errorInfo:Bool = true;
    var queueInfo:String{
        get{
            return queue.description;
        }
    };
    var onceFlag:Int = 0;
    
    init(qos:DispatchQoS.QoSClass = .default) {
        queue = DispatchQueue.global(qos: qos);
        super.init();
    }
    
    override init() {
        queue = DispatchQueue.main;
        super.init();
    }
    
    init(label: String, attr: DispatchQueue.Attributes) {
        queue = DispatchQueue(label: label, attributes: attr);
        super.init();
    }
    
    func printDebugInfo(message: Any){
        if(debugInfo) {
            print(message);
        }
    }
    
    func printErrorInfo(message: Any) {
        if(errorInfo) {
            print(message);
        }
    }
    
    func async(message:String = "", block:@escaping ()->()!) {
        self.queue.async{
            self.printDebugInfo(message: "当前队列:\(self.queueInfo)\n异步消息(async):\(message)");
            block();
        };
    }
    
    func sync(message:String = "", block:()->()!) {
        self.queue.sync{
            self.printDebugInfo(message: "当前队列:\(self.queueInfo)\n同步消息(sync):\(message)");
            block();
        };
    }
    
    func after(delay:Double, message:String = "", block:@escaping ()->()!){
        self.queue.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)){
            self.printDebugInfo(message: "当前队列:\(self.queueInfo)\n延迟消息(after):\(message)");
            block();
        }
    }
    
    func apply(iterations:Int, message:String = "", block:((Int) -> Void)!){
        self.printDebugInfo(message: "当前队列: \(queueInfo)\n多次消息(apply): \(message)");
        DispatchQueue.concurrentPerform(iterations: iterations, execute: block);
    }
    
    
}
