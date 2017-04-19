//
//  MySafeMutableMethod.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/9/13.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit
//保护线程安全
//写优先
class MySafeMutableMethod<T> {
    var subject: T;
    var debugInfo:Bool{
        didSet{
            writeLock.debugInfo = debugInfo;
            readLock.debugInfo = debugInfo;
            mutexReader.debugInfo = debugInfo;
            mutexWriter.debugInfo = debugInfo;
        }
    };
    private let writeLock:GCDSemaphore
    private let readLock: GCDSemaphore
    private let mutexWriter: GCDSemaphore
    private let mutexReader: GCDSemaphore
    private var readerCount = 0;
    private var writerCount = 0;
    
    init(subject: T){
        self.subject = subject;
        writeLock = GCDSemaphore(count: 1);
        readLock = GCDSemaphore(count: 1);
        mutexReader = GCDSemaphore(count: 1);
        mutexWriter = GCDSemaphore(count: 1);
        debugInfo = false;
    }
    
    fileprivate func lock(_ semaphore: GCDSemaphore) {
        _ = semaphore.lock();
    }
    
    fileprivate func unlock(_ semaphore: GCDSemaphore) {
        _ = semaphore.unlock();
    }
    
    func printDebugInfo(_ message: Any){
        if(debugInfo){
            print(message);
        }
    }
    //读写之前先请求，读写完要End
    //写者优先
    func writeRequest() {
        printDebugInfo("start writeRequest");
        lock(mutexWriter);
        if(writerCount == 0){
            lock(writeLock);
            printDebugInfo("writeLock lock writeRequest");
        }
        writerCount += 1;
        printDebugInfo("writerCount: \(writerCount) writeRequest");
        unlock(mutexWriter)
        lock(readLock)
        printDebugInfo("readLock lock writeRequest");
        printDebugInfo("writeRequest end");
    }
    
    func writeEnd() {
        printDebugInfo("writeEnd start");
        unlock(readLock)
        printDebugInfo("readLock unlock writeEnd");
        lock(mutexWriter)
        writerCount -= 1;
        printDebugInfo("writerCount: \(writerCount) writeEnd");
        if(writerCount == 0){
            unlock(writeLock)
            printDebugInfo("writeLock unlock writeEnd");
        }
        unlock(mutexWriter)
        printDebugInfo("writeEnd end");
    }
    
    func readRequest() {
        printDebugInfo("                                                        readRequest start");
        lock(writeLock);
        printDebugInfo("                                                        writeLock lock readRequest");
        unlock(writeLock)
        printDebugInfo("                                                        writeLock unlock readRequest");
        lock(mutexReader)
        if(readerCount == 0){
            lock(readLock)
            printDebugInfo("                                                        readLock lock readRequest");
        }
        readerCount += 1;
        printDebugInfo("                                                        readerCount: \(readerCount) readRequest");
        unlock(mutexReader)
        printDebugInfo("                                                        readRequest end");
    }
    
    func readEnd() {
        printDebugInfo("                                                        readEnd start");
        lock(mutexReader)
        readerCount -= 1;
        printDebugInfo("                                                        readEnd readerCount: \(readerCount)");
        if(readerCount == 0){
            unlock(readLock)
            printDebugInfo("                                                        readLock unlock readEnd");
        }
        unlock(mutexReader)
        printDebugInfo("                                                        readEnd end");
    }
}
