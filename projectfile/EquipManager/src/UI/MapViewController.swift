//
//  MapViewController.swift
//  EquipManager
//
//  Created by 李呱呱 on 2016/11/13.
//  Copyright © 2016年 LY. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        menuToolbar()
        
        requestLocation()
        
        //用户位置追踪
        mapView.userTrackingMode = .followWithHeading
        //标准地图type
        mapView.mapType =  .standard
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        //是否显示用户当前位置 ios8之后才有，默认为false
        
        if #available(iOS 9.0, *){
            //指南针 比例尺 交通
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        //建筑物 兴趣点 用户跟踪
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //请求定位
    func requestLocation(){
        self.locationManager = CLLocationManager()
        //判断定位服务是否开启
        if CLLocationManager.locationServicesEnabled(){
            if #available(iOS 8.0, *){//判断不同平台下做不同的逻辑处理，这里是8.0以上
                if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))||self.locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
                    if(Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil){
                        self.locationManager.requestAlwaysAuthorization()
                    }else if(Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil){
                        self.locationManager.requestWhenInUseAuthorization()
                    }else{
                        print("Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription")
                    }
                }
            }else{
                print("ios8以下系统！")
            }
        }else{
            print("定位服务未开启！")
        }
    }

    //MapView的代理
    //地图的显示区域即将发生改变的时候调用
    func mapView(_ mapView:MKMapView, regionWillChangeAnimated animated:Bool) {
        print("当显示的区域即将改变时调用！")
    }
    
    //地图的显示区域已经发生改变的时候调用
    func mapView(_ mapView:MKMapView, regionDidChangeAnimated animated:Bool) {
        print("当显示的区域发生变化时调用！")
    }
    
    //地图控件即将开始加载地图数据
    func mapViewWillStartLoadingMap(_ mapView:MKMapView){
        print("地图控件开始加载地图数据")
    }
    
    //当MKMapView加载数据完成时激发该方法
    func mapViewDidFinishLoadingMap(_ mapView:MKMapView){
        print("当MKMapView加载数据完成时激发该方法")
    }
    
    //当MKMapView加载数据失败时激发该方法如：无网络
    func mapViewDidFailLoadingMap(mapView:MKMapView, withError error:NSError){
        print("加载地图数据失败:\(error.userInfo)")
    }
    
    //当MKMapView即将开始渲染地图时激发该方法
    func mapViewWillStartRenderingMap(_ mapView:MKMapView){
        print("MKMapView即将开始渲染地图时")
    }
    
    //当MKMapView渲染地图完成时激发该方法
    func mapViewDidFinishRenderingMap(_ mapView:MKMapView, fullyRendered:Bool){
        print("MKMapView渲染地图完成时")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        NSLog("error : %@", error.localizedDescription)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "PIN_ANNOTATION") as? MKPinAnnotationView
        //        if annotationView == nil{
        //            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_ANNOTATION")
        //        }
        //
        //        annotationView!.pinTintColor = UIColor.red
        //        annotationView!.animatesDrop = true
        //        annotationView!.canShowCallout = true
        //
        //        return annotationView!
        
        let identifier = "MKPinAnnotationView"
        //从缓存池中取出可以循环利用的大头针view.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if  (annotationView == nil){
            //MKAnnotationView：可以用指定的图片作为大头针的样式，但显示的时候没有动画效果，如果没有给图片的话会什么都不显示,使用MKAnnotationView子类MKPinAnnotationView创建系统样式大头针
            annotationView =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //显示子标题和标题
            annotationView!.canShowCallout = true
            //设置大头针描述的偏移量
            annotationView!.calloutOffset = CGPoint(x:0, y: -10)
            //设置大头针描述左边的控件
            //annotationView!.leftCalloutAccessoryView = UIButton(type: .contactAdd)
            //设置大头针描述右边的控件
            //annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        annotationView!.annotation = annotation
        return annotationView
    }
    
    //当大头针被添加到地图上时调用
    func mapView(_ mapView:MKMapView, didAdd views: [MKAnnotationView]){
        print("添加大头针！")
    }
    
    //当点击左边或者右边附属视图的时候方法被调用
    func mapView(_ mapView:MKMapView, annotationView view:MKAnnotationView, calloutAccessoryControlTapped control:UIControl){
        print("calloutAccessoryControlTapped")
    }
    
    //点击选中大头针
    func mapView(_ mapView:MKMapView, didSelect view:MKAnnotationView){
        print("didSelectAnnotationView")
    }
    
    //当大头针被反选，即取消选中的时候调用，可以通过该方法改变选中大头针视图的姿态
    func mapView(_ mapView:MKMapView, didDeselect view:MKAnnotationView){
        print("didDeselectAnnotationView")
    }
    
    //当showsUserLocation属性被设置为true，该方法会被调用，即将开始跟踪定位用户位置
    func mapViewWillStartLocatingUser(_ mapView:MKMapView){
        print("即将开始跟踪定位用户位置")
    }
    
    //当showsUserLocation属性被设置为false，该方法会被调用，停止跟踪用户的位置
    func mapViewDidStopLocatingUser(_ mapView:MKMapView){
        print("停止跟踪用户的位置")
    }
    
    //当用户位置发生变化时调用,调用非常频繁，不断监测用户的当前位置,每次调用，都会把用户的最新位置（userLocation参数）传进来。
    func mapView(_ mapView:MKMapView, didUpdate userLocation:MKUserLocation){
        print("didUpdateUserLocation!\(userLocation.coordinate)\(userLocation.title)\(userLocation.subtitle)")
        //在用户定位成功之后，使大头针显示用户当前的位置。注意：建议使用真机查看效果，这里会随着位置改变多次调用。
        addAnnotaionToMapView(coorinate2D: userLocation.coordinate)
    }
    
    //无法定位或者用户不允许定位时，即定位失败，触发代理方法
    func mapView(_ mapView:MKMapView, didFailToLocateUserWithError error:Error){
        print(error.localizedDescription)
    }
    
    //当拖动大头针的姿态改变的时候触发代理方法
    func mapView(_ mapView:MKMapView, annotationView view:MKAnnotationView, didChange newState:MKAnnotationViewDragState, fromOldState oldState:MKAnnotationViewDragState){
        print("didChangeDragStat")
    }
    
    //当用户的跟踪模式改变会触发代理方法
    func mapView(_ mapView:MKMapView, didChange mode:MKUserTrackingMode, animated:Bool){
        print("用户的跟踪模式改变")
    }
    
    //MARK:添加大头针
    func addAnnotaionToMapView(coorinate2D:CLLocationCoordinate2D){
        
        //创建MKPointAnnotation对象——代表一个大头针
        //        let pointAnnotation = MKPointAnnotation()
        //        //设置大头针的经纬度
        //        pointAnnotation.coordinate = coorinate2D
        //        pointAnnotation.title = "hello"
        //        pointAnnotation.subtitle = "hello"
        //        //添加大头针
        //        self.mapView.addAnnotation(pointAnnotation)
        
        //设置地图显示的范围，地图显示范围越小，细节越清楚
        let span = MKCoordinateSpan(latitudeDelta:0.005, longitudeDelta:0.005)
        //创建MKCoordinateRegion对象，该对象代表了地图的显示中心和显示范围。
        let region = MKCoordinateRegion(center: coorinate2D, span: span)
        //设置当前地图的显示中心和显示范围
        self.mapView.setRegion(region, animated:true)
    }
    
    //根据textFiled里面的文字搜索地点在哪里
//    @IBAction func geocodeQuery(sender:AnyObject){
//        if(self.txtQueryKey.text == nil) {
//            return
//        }
//        
//        let geocoder = CLGeocoder()
//        
//        geocoder.geocodeAddressString(self.txtQueryKey.text!, completionHandler:
//            {(placemarks, error) -> Void in
//                
//                if (placemarks?.count)! > 0 {
//                    self.mapView.removeAnnotations(self.mapView.annotations)
//                }
//                
//                for item in placemarks! {
//                    print("查询记录数:", placemarks?.count)
//                    let placemark = item as CLPlacemark
//                    
//                    let viewRegion = MKCoordinateRegionMakeWithDistance((placemark.location?.coordinate)!, 10000, 10000)
//                    self.mapView.setRegion(viewRegion, animated: true)
//                    
//                    let annotation = MyAnnotation(coordinate: (placemark.location?.coordinate)!)
//                    annotation.city = placemark.locality
//                    annotation.state = placemark.administrativeArea
//                    annotation.streetAddress = placemark.thoroughfare
//                    annotation.zip = placemark.postalCode
//                    
//                    self.mapView.addAnnotation(annotation)
//                }
//                self.txtQueryKey.resignFirstResponder()
//                
//        })
//    }
    
    func menuToolbar(){
        let backButton = UIBarButtonItem(image: UIImage.init(named:"back"), style: .plain, target: self, action: #selector(EquipListTableViewController.backPressed))
        let flexItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeItem = UIBarButtonItem(image: UIImage.init(named: "home"), style: .plain, target: self, action: #selector(EquipListTableViewController.homePressed))
        let menuItem = UIBarButtonItem(image: UIImage.init(named: "new"), style: .plain, target: self, action: #selector(EquipListTableViewController.menuPressed))
        let items = [backButton, flexItem, homeItem, flexItem, flexItem, flexItem, menuItem]
        self.setToolbarItems(items, animated: true)
    }
    
    func backPressed(){
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func homePressed(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        _ = self.navigationController?.popToRootViewController(animated: true)
        //        CurrentInfo.sharedInstance.backToHome()
    }

    func menuPressed(){
        
    }
}
