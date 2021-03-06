//
//  NetworkOperation.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/8/4.
//  Copyright © 2016年 liguagua. All rights reserved.
//

import UIKit
import Alamofire

class NetworkOperation {
  
    internal struct NetConstant{
        static var serverURL:String{
            get{
                return EquipServer.sharedInstance().getServer();
            }
        }
        //static let serverURL = "weblib.scn.cn/"
        //static let serverURL = "202.38.254.197:9090/"
        
        static let serverProtocol = "http://"
        static let defaultQueue:GCDThread = GCDThread(label: "NetworkOperation", attr: .concurrent);
     
        struct DictKey {
           
            struct Authenticate {
                struct Query {
                    static let username     = "account"
                    static let password     = "password"
                }
                struct Response {
                    static let members      = "members"
                    static let memberId     = "id"
                }
            }
           
            struct SelectMember{
                struct Query {
                    static let memberId     = "memberId"
                }
            }
           
            struct GetResources{
                struct Query {
                    static let parentId     = "parentId";
                    static let type         = "type";
                    static let start        = "start";
                    static let limit        = "limit";
                }
                struct Response {
                    static let categorys    = "categorys";
                    static let dirAmout     = "dirAmout";
                    static let fileAmout    = "fileAmout";
                    static let isGroupManager = "isGroupManager";
                    static let parentId     = "parentId";
                    static let path         = "path";
                    struct PathKey {
                        static let displayName  = "displayName";
                        static let id           = "id";
                        static let name         = "name";
                    }
                    static let recyclerId   = "recyclerId";
                    static let resources    = "resources";
                    struct ResourcesKey {
                        static let checkCode    = "checkCode";
                        static let contentType  = "contentType";
                        static let creationDate = "creationDate";
                        static let desc         = "desc";
                        static let displayName  = "displayName";
                        static let documentType = "documentType";
                        static let filePath     = "filePath";
                        static let groupId      = "groupId";
                        static let groupName    = "groupName";
                        static let icon         = "icon";
                        static let id           = "id";
                        static let leaf         = "leaf";
                        static let memberId     = "memberId";
                        static let name         = "name";
                        static let owner        = "owner";
                        static let paiban       = "paiban";
                        static let parentId     = "parentId";
                        static let priority     = "priority";
                        static let rate         = "rate";
                        static let remark       = "remark";
                        static let size         = "size";
                        static let type         = "type";
                    }
                    
                    static let totalCount   = "totalCount";
                }
            }
        
            struct GetResourceInfo{
                struct Query {
                    static let resourceId   = "resourceId";
                }
                struct Response {
                    static let contentType  = "contenType";
                    static let creationDate = "creationDate";
                    static let desc         = "desc";
                    static let displayName  = "displayName";
                    static let filePath     = "filePath";
                    static let groupName    = "groupName";
                    static let id           = "id";
                    static let memberId     = "memberId";
                    static let memberName   = "memberName";
                    static let name         = "name";
                    static let size         = "size";
                    static let type         = "type";
                }
            }
         
            struct GetSimpleResources{
                struct Query {
                    static let parentId     = "parentId";
                    static let type         = "type";
                    static let start        = "start";
                    static let limit        = "limit";
                }
                struct Response {
                    static let dirAmout     = "dirAmout";
                    static let fileAmout    = "fileAmout";
                    static let isGroupManager   = "isGroupManager";
                    static let parentId     = "parentId";
                    static let path         = "path";
                    struct pathKey {
                        static let displayName  = "displayName";
                        static let id           = "id";
                        static let name         = "name";
                    }
                    static let resources    = "resources";
                    struct resourcesKey {
                        static let desc         = "desc";
                        static let displayName  = "displayName";
                        static let groupId      = "groupId";
                        static let groupName    = "groupName";
                        static let id           = "id";
                        static let leaf         = "leaf";
                        static let memberName   = "memberName";
                        static let name         = "name";
                        static let parentId     = "parentId";
                        static let size         = "size";
                        static let type         = "type";
                    }
                    static let totalCount   = "totalCount";
                }
            }
         
            struct CreateDir{
                struct Query{
                    static let groupId      = "groupId";
                    static let name         = "name";
                    static let parentId     = "parentId";
                }
                struct Response {
                    static let id           = "id";
                }
            }
          
            struct DownloadResource{
                struct Query {
                    static let id       = "id";
                }
                struct Response {
                    
                }
            }
         
            struct UploadResource {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let fileData     = "Filedata";
                    static let fileName     = "Filename";
                    static let documentType = "documentType";
                }
                struct Response {
                    
                }
            }
            struct UploadResourceReturnId {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let fileData     = "Filedata";
                    static let fileName     = "Filename";
                    static let documentType = "documentType";
                }
                struct Response {
                    static let file         = "file";
                    struct FileKey {
                        static let id           = "id";
                        static let no           = "no"
                    }
                    static let total        = "total";
                }
            }
           
            struct CopyResource {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let id           = "id";
                }
                struct Response {
                    
                }
            }
          
            struct MoveResource {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let id           = "id";
                }
                struct Response {
                    
                }
            }
            //修改资源
            struct ModifyResource {
                struct Query {
                    static let id           = "id";
                    static let name         = "name";
                    static let desc         = "desc";
                }
                struct Response {
                    
                }
            }
            
            struct GetThumbnail {
                struct Query {
                    static let id           = "id";
                    static let width        = "width";
                    static let height       = "height";
                }
                struct Response {
                    static let id           = "id";
                    static let thumbUrl     = "thumbUrl"
                }
            }
            //通讯录
            struct GetAccounts {
                struct Query {
                    static let start        = "start"
                    static let limit        = "limit"
                }
                struct Response {
                    static let totalCount   = "totalCount"
                    static let accounts     = "accounts"
                    struct AccountsKey {
                        static let account      = "account"
                        static let name         = "name"
                        static let department   = "department"
                        static let position     = "position"
                        static let email        = "email"
                        static let im           = "im"
                        static let phone        = "phone"
                        static let mobile       = "mobile"
                        static let status       = "status"
                        static let members      = "members"
                        struct MembersKey {
                            static let id           = "id"
                            static let name         = "name"
                        }
                    }
                }
            }
            struct DeleteResource {
                struct Query {
                    static let id           = "id";
                }
                struct Response {
                }
            }
            struct Status {
                struct Query {}
                struct Response {
                    static let status       = "status";
                    static let isAdmin      = "isAdmin";
                    static let isApplicationAdmin   = "isApplicationAdmin";
                    static let isProjectManager = "isProjectManager";
                    static let addGroup     = "addGroup";
                    static let memberId     = "memberId";
                    static let largeAttachId    = "largeAttachId";
                    static let personGroupId    = "personGroupId";
                    static let memberName   = "memberName";
                    static let name         = "name";
                    static let account      = "account";
                    static let memberIp     = "memberIp";
                }
            }
        }
        
        struct API {
            static let Authenticate         = "login/authenticate.action"
            static let SelectMember         = "login/selectMember.action"
            static let Status               = "user/status.action"
            static let GetAlbumRoot         = "simple-group/ablumTrees.action"
            static let LogOut               = "login/logout.action"
            static let getVersion           = "global/getSystemVersion.action"
            //resource set
            static let GetResources         = "group/getResources.action"
            static let GetResourceInfo      = "group/getResourceInfo.action"
            static let GetSimpleResources   = "group/getSimpleResources.action"
            static let GetThumbnail         = "group/getThumbnail.action"
            static let Download             = "group/downloadResource.action"
            static let Upload               = "group/uploadResource.action"
            static let UploadReturnId       = "group/uploadResourceReturnId.action"
            static let CreateDIR            = "group/createDir.action"
            static let DeleteResource       = "group/deleteResource.action"
            static let CopyResource         = "group/copyResource.action"
            static let MoveResource         = "group/moveResource.action"
            static let GetResourceURL       = "webmail/getResourceUrl.action"
            static let GetTokenDownloadURL  = "webmail/getTokenDownloadUrl.action"
            static let GetDownloadURL       = "webmail/getDownloadUrl.action"
            static let ModifyResource       = "group/modifyResource.action"
            //public and watch set
            static let GetTrees             = "group/trees.action"
            static let AddWatch             = "user/addWatch.action"
            static let DeleteWatch          = "user/deleteWatch.action"
            static let GetWatches           = "user/getWatches.action"
            static let GetWatchByGroup      = "user/getWatchByGroup.action"
            //shared to me
            static let GetSharedToMe        = "group/getMyReceiveResources.action"
            static let GetSharedChild       = "group/getSharedChildResources.action"
            static let GetReceived          = "group/getReceiveResource.action"
            static let GetMembers           = "group/getReceiveMembers.action"
            static let RemoveReceived       = "group/deleteReceivedResource.action"
            //my shared
            static let GetMyShared          = "group/getMySharedResources.action"
            static let GetSharedResources   = "group/getShareResource.action"
            static let ModifySharedResource = "group/modifyShareResource.action"
            static let UnshareResource      = "group/deleteSharedResource.action"
            static let ShareToMember        = "group/shareResourceToMember.action"
            //contact set
            static let GetAccounts          = "user/getAccounts.action"
            static let GetGroupTree         = "grouper/grouperTree.action"
        }
    }
    
    fileprivate static let _sharedInstance = NetworkOperation()
    fileprivate init(){
    }
   
    class func sharedInstance() -> NetworkOperation {
        return _sharedInstance
    }
    
    func postRequest(url: String,dict: [String: Any], queue: GCDThread, handler: @escaping (AnyObject) -> Void) -> GCDSemaphore {
        let sema: GCDSemaphore = GCDSemaphore(count: 0);
        let request = Alamofire.request(url, method: .post, parameters: dict, headers: nil);
        request.responseJSON{(response) in
            queue.async{
                switch response.result{
                case .success(let data):
                    handler(data as AnyObject);
                case .failure(let error):
                    print(error);
                }
                _ = sema.unlock(message: "post: \(Thread.current)");
            }
        }
        return sema;
    }
    
    func download(url: String, dict: [String: Any], fileURL: URL, queue: GCDThread, handler: @escaping (AnyObject) -> Void) -> GCDSemaphore {
        let sema: GCDSemaphore = GCDSemaphore(count: 0)
        queue.async {
            let downloadURL = "\(url)?id=\(dict["id"]!)";
            let fileData = try! Data(contentsOf: URL(string: downloadURL)!);
            if !(FileManager.default.fileExists(atPath: fileURL.deletingLastPathComponent().path)){
                try! FileManager.default.createDirectory(atPath: fileURL.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil);
            }
            (fileData as NSData).write(toFile: fileURL.path, atomically: true);
            handler(fileData as AnyObject);
            _ = sema.unlock(message: "download: \(Thread.current)");
        }
        return sema;
    }
    
    func upload(dict: [String: Any], fileDict: [String: Data], fileName: String, mimeType: String, url: String, queue: GCDThread, handler: @escaping (AnyObject) -> Void) -> GCDSemaphore {
        let sema = GCDSemaphore(count: 0);
        
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in
            for (key, value) in dict{
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key);
            }
            multipartFormData.append(fileDict.first!.value, withName: fileDict.first!.key, fileName: fileName, mimeType: mimeType)
            
            
            }, to: url, method: .post, headers: nil, encodingCompletion: {
                (encodingResult) in
                switch encodingResult{
                case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                    request.responseJSON{ response in
                        queue.async {
                            switch response.result{
                            case .success(let data):
                                handler(data as AnyObject);
                            case .failure(let error):
                                print(error)
                            }
                            _ = sema.unlock(message: "upload: \(Thread.current)");
                        }
                    }
                case .failure(let error):
                    print(error);
                }
        })
        return sema;
    }
    
    //登陆
    func Login(_ userName : String, passwd: String, queue:GCDThread = NetConstant.defaultQueue,handler:@escaping (AnyObject)->Void){
        var dict = [NetConstant.DictKey.Authenticate.Query.username : userName,
                    NetConstant.DictKey.Authenticate.Query.password : passwd];
        _ = self.postRequest(url: NetworkOperation.NetConstant.API.Authenticate.asURLConvertible, dict: dict, queue: queue){
            (responseDict) in
            if let memberID = ((responseDict.object(forKey: NetConstant.DictKey.Authenticate.Response.members) as! NSArray)[0] as AnyObject).object(forKey: NetConstant.DictKey.Authenticate.Response.memberId){
                dict = [NetConstant.DictKey.SelectMember.Query.memberId : "\(memberID)"];
                _ = self.postRequest(url: NetworkOperation.NetConstant.API.SelectMember.asURLConvertible, dict: dict, queue: queue){ (responseDict) in
                    print(responseDict);
                    handler(responseDict);
                }
            }
        }
    }
    
    func Status(_ queue: GCDThread = NetConstant.defaultQueue, handler: @escaping (AnyObject)->Void) -> GCDSemaphore {
        let rtn = self.postRequest(url: NetworkOperation.NetConstant.API.Status.asURLConvertible, dict: [:], queue: queue){
            (responseDict) in
            handler(responseDict);
        }
        return rtn;
    }
    
   
    func getResources(_ parentID:Int,type:Int = 0,start:Int = 0,limit:Int = 1000,queue:GCDThread = NetConstant.defaultQueue,handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.GetResources.Query.parentId : parentID];
        return self.postRequest(url: NetworkOperation.NetConstant.API.GetResources.asURLConvertible, dict: dict, queue: queue,handler: handler);
    }
    
    
    func getResourceInfo(_ resourceID:Int, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.GetResourceInfo.Query.resourceId : resourceID];
        return self.postRequest(url: NetworkOperation.NetConstant.API.GetResourceInfo.asURLConvertible, dict: dict, queue: queue){ (responseDict) in
            handler(responseDict)
        }
    }
    
   
    func getSimpleResources(_ parentID:Int,type:Int,start:Int,limit:Int, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.GetSimpleResources.Query.parentId : parentID];
        
        return self.postRequest(url: NetworkOperation.NetConstant.API.GetSimpleResources.asURLConvertible, dict: dict, queue: queue){
            (responseDict) in
            handler(responseDict);
        }
    }
    
    func deleteResource(_ id:Int, queue:GCDThread = NetConstant.defaultQueue, handler: @escaping (AnyObject)->Void) -> GCDSemaphore {
        let dict = [NetConstant.DictKey.DeleteResource.Query.id : "\(id)"];
        return self.postRequest(url: NetworkOperation.NetConstant.API.DeleteResource.asURLConvertible, dict: dict, queue: queue){
            (responseDict) in
            handler(responseDict);
        }
    }
   
    func createDir(_ groupID:Int,name:String,parentID:Int,queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.CreateDir.Query.groupId : "\(groupID)",
            NetConstant.DictKey.CreateDir.Query.name : name,
            NetConstant.DictKey.CreateDir.Query.parentId : "\(parentID)"] as [String : Any];
        return self.postRequest(url: NetworkOperation.NetConstant.API.CreateDIR.asURLConvertible, dict: dict, queue: queue){
            (responseDict) in
            handler(responseDict);
        }
    }
    
    
    func downloadResource(_ id:Int, url:URL, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.DownloadResource.Query.id : "\(id)"];
        
        return self.download(url: NetworkOperation.NetConstant.API.Download.asURLConvertible, dict: dict, fileURL: url, queue: queue, handler: { (responseDict) in
            handler(responseDict);
        })
    }
    
    
    func uploadResource(_ groupID:Int,parentID:Int,fileURL:URL,fileName:String,fileDataContentType:String = "multipart/form-data",documentType:String = "", queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let data:Data = try! Data(contentsOf: URL(fileURLWithPath: fileURL.path));
        return self.uploadResource(groupID, parentID: parentID, fileData: data, fileName: fileName, fileDataContentType: fileDataContentType, documentType: documentType, queue: queue, handler: handler);
    }
    
    
    func uploadResource(_ groupID:Int,parentID:Int,fileData:Data,fileName:String,fileDataContentType:String = "multipart/form-data",documentType:String = "", queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.UploadResource.Query.groupId : "\(groupID)",
            NetConstant.DictKey.UploadResource.Query.parentId : "\(parentID)"];
        let fileDict = [NetConstant.DictKey.UploadResource.Query.fileData: fileData];
        return self.upload(dict: dict, fileDict: fileDict, fileName: fileName, mimeType: fileDataContentType, url: NetworkOperation.NetConstant.API.Upload.asURLConvertible, queue: queue, handler: handler);
        
    }
    
   
    func uploadResourceReturnId(_ groupID:Int,parentID:Int,fileURL:URL,fileName:String,fileDataContentType:String = "multipart/form-data",documentType:String = "", queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let data:Data = try! Data(contentsOf: URL(fileURLWithPath: fileURL.path));
        return self.uploadResourceReturnId(groupID, parentID: parentID, fileData: data, fileName: fileName, fileDataContentType: fileDataContentType, documentType: documentType, queue: queue, handler: handler);
    }
    
   
    func uploadResourceReturnId(_ groupID:Int,parentID:Int,fileData:Data,fileName:String,fileDataContentType:String = "multipart/form-data",documentType:String = "", queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        
        let dict = [NetConstant.DictKey.UploadResourceReturnId.Query.groupId : "\(groupID)",
            NetConstant.DictKey.UploadResourceReturnId.Query.parentId : "\(parentID)"];
        let fileDict = [NetConstant.DictKey.UploadResourceReturnId.Query.fileData : fileData];
        return self.upload(dict: dict, fileDict: fileDict, fileName: fileName, mimeType: fileDataContentType, url: NetConstant.API.UploadReturnId.asURLConvertible, queue: queue, handler: handler);
    }
    
  
    func copyResource(_ groupID:Int,parentID:Int,id:Int, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.CopyResource.Query.groupId : "\(groupID)",
            NetConstant.DictKey.CopyResource.Query.parentId : "\(parentID)",
            NetConstant.DictKey.CopyResource.Query.id : "\(id)"];
        return self.postRequest(url: NetConstant.API.CopyResource.asURLConvertible, dict: dict, queue: queue, handler: handler);
    }
    
  
    func moveResource(_ groupID:Int,parentID:Int,id:Int, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.MoveResource.Query.groupId : "\(groupID)",
            NetConstant.DictKey.MoveResource.Query.parentId : "\(parentID)",
            NetConstant.DictKey.MoveResource.Query.id : "\(id)"];
        return self.postRequest(url: NetConstant.API.MoveResource.asURLConvertible, dict: dict, queue: queue, handler: handler);
    }
    
   
    func modifyResource(_ id:Int, name:String, desc:String = "", queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> GCDSemaphore{
        let dict = [NetConstant.DictKey.ModifyResource.Query.id : "\(id)",
            NetConstant.DictKey.ModifyResource.Query.name : "\(name)",
            NetConstant.DictKey.ModifyResource.Query.desc : "\(desc)"];
        return self.postRequest(url: NetConstant.API.ModifyResource.asURLConvertible, dict: dict, queue: queue, handler: handler);
    }
    
  
    func getThumbnail(_ id:Int,width:Int = 100,height:Int = 100,queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject?)->Void) -> GCDSemaphore{
        
        let dict = [NetConstant.DictKey.GetThumbnail.Query.id : "\(id)",
            NetConstant.DictKey.GetThumbnail.Query.width : "\(width)",
            NetConstant.DictKey.GetThumbnail.Query.height : "\(height)"];
        return self.postRequest(url: NetConstant.API.GetThumbnail.asURLConvertible, dict: dict, queue: queue){
            (any) in
            if let url = ((any as! NSArray)[0] as AnyObject).object(forKey: NetConstant.DictKey.GetThumbnail.Response.thumbUrl) as? String{
                print(url);
                let data = try? Data(contentsOf: URL(string: url.asURLConvertible)!);
                handler(data as AnyObject?);
            }
        }
    }

    func getAccounts_blocking(start:Int, limit:Int, queue:GCDThread = NetConstant.defaultQueue, handler:@escaping (AnyObject)->Void) -> NSDictionary{
        let dict = [NetConstant.DictKey.GetAccounts.Query.start : "\(start)",
            NetConstant.DictKey.GetAccounts.Query.limit : "\(limit)"]
        var rtn:NSDictionary!
        
        let s = self.postRequest(url: NetConstant.API.GetAccounts.asURLConvertible, dict: dict, queue: queue){
            (any) in
            handler(any)
            rtn = any as! NSDictionary
        }
       
        let group: GCDGroup = GCDGroup()
        group.async(thread: NetConstant.defaultQueue){
            _ = s.lock()
        }
        //print(Thread.current)
        _ = group.wait()
        
        return rtn
    }

    
}
