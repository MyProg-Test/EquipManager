//
//  NetworkOperation.swift
//  EquipManager
//
//  Created by 李呱呱 on 16/8/4.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
import Alamofire

class NetworkOperation {
    let thread: GCDThread = GCDThread(label: "NetworkOperation", attr: DISPATCH_QUEUE_SERIAL)
    //网络常数
    internal struct NetConstant{
        static let serverURL = "weblib.ccnl.scut.edu.cn/"
        static let serverProtocol = "http://"
        //网络接口使用的询问key和回答key
        struct DictKey {
            //登录时使用的key
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
            //选择member
            struct SelectMember{
                struct Query {
                    static let memberId     = "memberId"
                }
            }
            //获取资源使用的key
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
            //获取资源信息的key
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
            //获取简单资源使用的key
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
            //新建文件夹使用的key
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
            //下载资源使用的key
            struct DownloadResource{
                struct Query {
                    static let id       = "id";
                }
                struct Response {
                    
                }
            }
            //上传资源使用的key
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
            //复制资源使用的key
            struct CopyResource {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let id           = "id";
                }
                struct Response {
                    
                }
            }
            //移动资源使用的key
            struct MoveResource {
                struct Query {
                    static let groupId      = "groupId";
                    static let parentId     = "parentId";
                    static let id           = "id";
                }
                struct Response {
                    
                }
            }
            //修改资源使用的key
            struct ModifyResource {
                struct Query {
                    static let id           = "id";
                    static let name         = "name";
                    static let desc         = "desc";
                }
                struct Response {
                    
                }
            }
            //获取缩略图使用的key
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
        //网络端调用的application interface
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
    let deleteResourceQueue:NSMutableArray;
    let getResourcesQueue:NSMutableArray;
    let downloadQueue:NSMutableArray;
    let getThumbnailQueue:NSMutableArray;
    let uploadQueue:NSMutableArray;
    
    //获取资源完成
    var getResourcesComplete:Bool{
        get{
            return getResourcesQueue.count == 0;
        }
    }
    //下载完成
    var downloadComplete:Bool{
        get{
            return downloadQueue.count == 0;
        }
    }
    //缩略图完成
    var getThumbnailComplete:Bool{
        get{
            return getThumbnailQueue.count == 0;
        }
    }
    //上传完成
    var uploadComplete:Bool{
        get{
            return uploadQueue.count == 0;
        }
    }
    
    var deleteResourceComplete: Bool{
        get{
            return deleteResourceQueue.count == 0;
        }
    }
    
    private static let _sharedInstance = NetworkOperation()
    private init(){
        getResourcesQueue = NSMutableArray();
        downloadQueue = NSMutableArray();
        getThumbnailQueue = NSMutableArray();
        uploadQueue = NSMutableArray();
        deleteResourceQueue = NSMutableArray();
    }
    //单例模式
    class func sharedInstance() -> NetworkOperation {
        return _sharedInstance
    }
    //时间戳
    func getTimeStamp(message:AnyObject) -> NSString {
        let time = NSDate();
        let timeFormatter = NSDateFormatter();
        timeFormatter.dateFormat = "yyyyMMddHHmmss";
        return "\(message)\(timeFormatter.stringFromDate(time))";
    }
    //登陆
    func Login(userName : NSString, passwd: NSString, handler:(AnyObject)->Void){
        thread.async(){
            var dict = [NetConstant.DictKey.Authenticate.Query.username : userName,
                NetConstant.DictKey.Authenticate.Query.password : passwd];
            let request = Alamofire.request(.POST, NetworkOperation.NetConstant.API.Authenticate.asURLConvertible, parameters: dict, encoding: .URL, headers: nil);
            request.progress({ (a, b, c) in
                print(a,b,c);
            })
            request.responseJSON{ (response) in
                switch response.result{
                case .Success(let data):
                    let responseDict:NSMutableDictionary = data as! NSMutableDictionary;
                    if let memberID = responseDict.objectForKey(NetConstant.DictKey.Authenticate.Response.members)?.firstObject??.objectForKey(NetConstant.DictKey.Authenticate.Response.memberId){
                        dict = [NetConstant.DictKey.SelectMember.Query.memberId : "\(memberID)"];
                        Alamofire.request(.POST, NetworkOperation.NetConstant.API.SelectMember.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON{ (response) in
                            switch response.result{
                            case .Success(let data):
                                print("Login Success");
                                handler(data);
                                
                            case .Failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func Status(handler: (AnyObject)->Void) {
        thread.async{
            Alamofire.request(.POST, NetConstant.API.Status.asURLConvertible, parameters: nil, encoding: .URL, headers: nil).responseJSON{
                (response) in
                switch response.result{
                case .Success(let data):
                    let responseDict:NSMutableDictionary = data as! NSMutableDictionary;
                    handler(responseDict);
                case .Failure(let error):
                    print(error);
                }
            }
        }
    }
    
    // group/getResources.action  获取文件树节点信息
    func getResources(parentID:Int,type:Int = 0,start:Int = 0,limit:Int = 1000, handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(parentID);
        thread.async{
            objc_sync_enter(self.getResourcesQueue);
            self.getResourcesQueue.addObject(stamp);
            objc_sync_exit(self.getResourcesQueue);
            let dict = [NetConstant.DictKey.GetResources.Query.parentId : parentID];
            Alamofire.request(.POST, NetworkOperation.NetConstant.API.GetResources.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON{ (response) in
                switch response.result{
                case .Success(let data):
                    let responseDict:NSMutableDictionary = data as! NSMutableDictionary;
                    handler(responseDict)
                case .Failure(let error):
                    print(error)
                }
                objc_sync_enter(self.getResourcesQueue);
                self.getResourcesQueue.removeObject(stamp);
                objc_sync_exit(self.getResourcesQueue);
            }
        }
        return stamp;
    }
    
    //group/getResourceInfo.action  获取资源信息
    func getResourceInfo(resourceID:Int, handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(resourceID);
        thread.async{
            objc_sync_enter(self.getResourcesQueue);
            self.getResourcesQueue.addObject(stamp);
            objc_sync_exit(self.getResourcesQueue);
            let dict = [NetConstant.DictKey.GetResourceInfo.Query.resourceId : resourceID];
            Alamofire.request(.POST, NetworkOperation.NetConstant.API.GetResourceInfo.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON{ (response) in
                switch response.result{
                case .Success(let data):
                    let responseDict:NSMutableDictionary = data as! NSMutableDictionary;
                    handler(responseDict)
                case .Failure(let error):
                    print(error)
                }
                objc_sync_enter(self.getResourcesQueue);
                self.getResourcesQueue.removeObject(stamp);
                objc_sync_exit(self.getResourcesQueue);
            }
        }
        return stamp;
    }
    
    //group/getSimpleResources.action  获取文件树节点简要信息
    func getSimpleResources(parentID:Int,type:Int,start:Int,limit:Int, handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(parentID);
        thread.async {
            objc_sync_enter(self.getResourcesQueue);
            self.getResourcesQueue.addObject(stamp);
            objc_sync_exit(self.getResourcesQueue);
            let dict = [NetConstant.DictKey.GetSimpleResources.Query.parentId : parentID];
            Alamofire.request(.POST, NetworkOperation.NetConstant.API.GetSimpleResources.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON { (response) in
                switch response.result{
                case .Success(let data):
                    let responseDict:NSMutableDictionary = data as! NSMutableDictionary;
                    handler(responseDict);
                case .Failure(let error):
                    print(error);
                }
                objc_sync_enter(self.getResourcesQueue);
                self.getResourcesQueue.removeObject(stamp);
                objc_sync_exit(self.getResourcesQueue);
            }
            
        }
        return stamp;
    }
    
    func deleteResource(id:Int, handler: (AnyObject)->Void) -> NSString {
        let stamp = self.getTimeStamp(id);
        thread.async{
            objc_sync_enter(self.deleteResourceQueue);
            self.deleteResourceQueue.addObject(stamp);
            objc_sync_exit(self.deleteResourceQueue);
            let dict = [NetConstant.DictKey.DeleteResource.Query.id : "\(id)"];
            Alamofire.request(.POST, NetworkOperation.NetConstant.API.DeleteResource.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON{ (response) in
                switch response.result{
                case .Success(let data):
                    handler(data)
                case .Failure(let error):
                    print(error);
                }
                objc_sync_enter(self.deleteResourceQueue);
                self.deleteResourceQueue.removeObject(stamp);
                objc_sync_exit(self.deleteResourceQueue);
            }
        }
        return stamp;
    }
    
    //group/createDir.action  新建文件夹
    func createDir(groupID:Int,name:NSString,parentID:Int, handler:(AnyObject)->Void){
        thread.async {
            let dict = [NetConstant.DictKey.CreateDir.Query.groupId : "\(groupID)",
                NetConstant.DictKey.CreateDir.Query.name : name,
                NetConstant.DictKey.CreateDir.Query.parentId : "\(parentID)"];
            Alamofire.request(.POST, NetworkOperation.NetConstant.API.CreateDIR.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON { (response) in
                switch response.result{
                case .Success(let data):
                    handler(data);
                case .Failure(let error):
                    print(error);
                }
            }
            
        }
    }
    
    //group/downloadResource.action  下载文件或打包下载
    func downloadResource(id:Int, url:NSURL, handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(id);
        thread.async{
            objc_sync_enter(self.downloadQueue);
            self.downloadQueue.addObject(stamp);
            objc_sync_exit(self.downloadQueue);
            let dict = [NetConstant.DictKey.DownloadResource.Query.id : "\(id)"];
            Alamofire.download(.POST, NetConstant.API.Download.asURLConvertible, parameters: dict, encoding: .URL, headers: nil, destination: { (tempurl, response) -> NSURL in
                handler(response);
                if(!NSFileManager.defaultManager().fileExistsAtPath(url.URLByDeletingLastPathComponent!.path!)){
                    try! NSFileManager.defaultManager().createDirectoryAtPath(url.URLByDeletingLastPathComponent!.path!, withIntermediateDirectories: true, attributes: nil);
                }
                let fileName:NSString = url.lastPathComponent!;
                print(fileName);
                return url.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(fileName as String);
            }).responseData { (response) in
                print(response);
                objc_sync_enter(self.downloadQueue);
                self.downloadQueue.removeObject(stamp);
                objc_sync_exit(self.downloadQueue);
                
            }
        }
        return stamp;
    }
    
    //group/uploadResource.action   上传资源
    func uploadResource(groupID:Int,parentID:Int,fileURL:NSURL,fileName:NSString,fileDataContentType:NSString = "multipart/form-data",documentType:NSString = "", handler:(AnyObject)->Void) -> NSString{
        let data:NSData = NSData(contentsOfFile: fileURL.path!)!;
        return self.uploadResource(groupID, parentID: parentID, fileData: data, fileName: fileName, fileDataContentType: fileDataContentType, documentType: documentType, handler: handler);
    }
    
    //group/uploadResource.action   上传资源
    func uploadResource(groupID:Int,parentID:Int,fileData:NSData,fileName:NSString,fileDataContentType:NSString = "multipart/form-data",documentType:NSString = "", handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(parentID);
        thread.async{
            objc_sync_enter(self.uploadQueue);
            self.uploadQueue.addObject(stamp);
            objc_sync_exit(self.uploadQueue);
            let dict = [NetConstant.DictKey.UploadResource.Query.groupId : "\(groupID)",
                NetConstant.DictKey.UploadResource.Query.parentId : "\(parentID)"];
            Alamofire.upload(.POST, NetConstant.API.Upload.asURLConvertible, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: fileData, name: NetConstant.DictKey.UploadResource.Query.fileData, fileName: fileName as String, mimeType: fileDataContentType as String);
                for (key,value) in dict{
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key);
                }
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            switch response.result{
                            case .Success(let data):
                                handler(data);
                            case .Failure(let error):
                                print(error);
                            }
                            objc_sync_enter(self.uploadQueue);
                            self.uploadQueue.removeObject(stamp);
                            objc_sync_exit(self.uploadQueue);
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
        return stamp;
    }
    
    //group/uploadResourceReturnId.action   上传资源并返回ID
    func uploadResourceReturnId(groupID:Int,parentID:Int,fileURL:NSURL,fileName:NSString,fileDataContentType:NSString = "multipart/form-data",documentType:NSString = "", handler:(AnyObject)->Void) -> NSString{
        let data:NSData = NSData(contentsOfFile: fileURL.path!)!;
        return self.uploadResourceReturnId(groupID, parentID: parentID, fileData: data, fileName: fileName, fileDataContentType: fileDataContentType, documentType: documentType, handler: handler);
    }
    
    //group/uploadResourceReturnId.action   上传资源并返回ID
    func uploadResourceReturnId(groupID:Int,parentID:Int,fileData:NSData,fileName:NSString,fileDataContentType:NSString = "multipart/form-data",documentType:NSString = "", handler:(AnyObject)->Void) -> NSString{
        let stamp = self.getTimeStamp(parentID);
        thread.async{
            objc_sync_enter(self.uploadQueue);
            self.uploadQueue.addObject(stamp);
            objc_sync_exit(self.uploadQueue);
            let dict = [NetConstant.DictKey.UploadResourceReturnId.Query.groupId : "\(groupID)",
                NetConstant.DictKey.UploadResourceReturnId.Query.parentId : "\(parentID)"];
            Alamofire.upload(.POST, NetConstant.API.UploadReturnId.asURLConvertible, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: fileData, name: NetConstant.DictKey.UploadResourceReturnId.Query.fileData, fileName: fileName as String, mimeType: fileDataContentType as String);
                for (key,value) in dict{
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key);
                }
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            switch response.result{
                            case .Success(let data):
                                handler(data);
                            case .Failure(let error):
                                print(error);
                            }
                            objc_sync_enter(self.uploadQueue);
                            self.uploadQueue.removeObject(stamp);
                            objc_sync_exit(self.uploadQueue);
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
        return stamp;
    }
    
    //group/copyResource.action  复制资源
    func copyResource(groupID:Int,parentID:Int,id:Int, handler:(AnyObject)->Void){
        thread.async {
            let dict = [NetConstant.DictKey.CopyResource.Query.groupId : "\(groupID)",
                NetConstant.DictKey.CopyResource.Query.parentId : "\(parentID)",
                NetConstant.DictKey.CopyResource.Query.id : "\(id)"];
            Alamofire.request(.POST, NetConstant.API.CopyResource.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .Success(let data):
                    handler(data);
                case .Failure(let error):
                    print(error);
                }
            })
            
        }
    }
    
    //group/moveResource.action  移动资源
    func moveResource(groupID:Int,parentID:Int,id:Int, handler:(AnyObject)->Void){
        thread.async {
            let dict = [NetConstant.DictKey.MoveResource.Query.groupId : "\(groupID)",
                NetConstant.DictKey.MoveResource.Query.parentId : "\(parentID)",
                NetConstant.DictKey.MoveResource.Query.id : "\(id)"];
            Alamofire.request(.POST, NetConstant.API.MoveResource.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .Success(let data):
                    handler(data);
                case .Failure(let error):
                    print(error);
                }
            })
            
        }
    }
    
    //group/modifyResource.action 修改资源文件夹
    func modifyResource(id:Int, name:NSString, desc:NSString = "", handler:(AnyObject)->Void){
        thread.async{
            let dict = [NetConstant.DictKey.ModifyResource.Query.id : "\(id)",
                NetConstant.DictKey.ModifyResource.Query.name : name as String,
                NetConstant.DictKey.ModifyResource.Query.desc : desc];
            Alamofire.request(.POST, NetConstant.API.ModifyResource.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .Success(let data):
                    handler(data);
                case .Failure(let error):
                    print(error);
                }
            })
        }
    }
    
    //group/getThumbnail.action  缩略图
    func getThumbnail(id:Int,width:Int = 100,height:Int = 100, handler:(AnyObject?)->Void) -> NSString{
        let stamp = self.getTimeStamp(id);
        thread.async {
            objc_sync_enter(self.getThumbnailQueue);
            self.getThumbnailQueue.addObject(stamp);
            objc_sync_exit(self.getThumbnailQueue);
            let dict = [NetConstant.DictKey.GetThumbnail.Query.id : "\(id)",
                        NetConstant.DictKey.GetThumbnail.Query.width : "\(width)",
                        NetConstant.DictKey.GetThumbnail.Query.height : "\(height)"];
            Alamofire.request(.POST, NetConstant.API.GetThumbnail.asURLConvertible, parameters: dict, encoding: .URL, headers: nil).responseJSON(completionHandler: { (response) in
                var imageData:NSData? = nil;
                switch response.result{
                case .Success(let data):
                    if let URL = data.firstObject??.objectForKey("thumbUrl") as? String{
                        print(data);
                        print(URL.asURLConvertible);
                        imageData = NSData(contentsOfURL: NSURL(string: URL.asURLConvertible)!);
                    }
                case .Failure(let error):
                    print(error)
                }
                handler(imageData);
                objc_sync_enter(self.getThumbnailQueue);
                self.getThumbnailQueue.removeObject(stamp);
                objc_sync_exit(self.getThumbnailQueue);
            })
        }
        return stamp;
    }
    
    
}



















