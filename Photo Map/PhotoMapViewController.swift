//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,LocationsViewControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var latitude: NSNumber = 0.0
    var longitude:  NSNumber = 0.0
    var imageSelected : UIImage!
    var imageTapped : UIImage!
    let vc = UIImagePickerController()
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vc.delegate = self
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
            MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        //uncomment the line below to shoe the image
      mapView.delegate = self
        
     
    }

    @IBAction func onCamera(sender: AnyObject) {
        
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false{
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
//            vc.dismissViewControllerAnimated(true, completion: nil)
        }
            
        else {
        
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(vc, animated: true, completion: nil)
//            vc.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageSelected = image
        //print(self.imageSelected)
        picker.dismissViewControllerAnimated(true, completion:  go )
    
    }
    
    func go(){
        self.performSegueWithIdentifier("tagSegue",
            sender: self)

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            
            let detailsButton = UIButton(type: UIButtonType.DetailDisclosure)
            annotationView!.rightCalloutAccessoryView = detailsButton
            var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            annotationView!.image = thumbnail
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = self.imageSelected
        
        var resizeRenderImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
        resizeRenderImageView.layer.borderColor = UIColor.whiteColor().CGColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        
        UIGraphicsEndImageContext()
       
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.imageTapped = (view.leftCalloutAccessoryView as! UIImageView).image
        performSegueWithIdentifier("fullImageSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tagSegue" {
            let vc = segue.destinationViewController as! LocationsViewController
            vc.delegate = self
        }
        else  {
            if let fullImageVC = segue.destinationViewController as? FullImageViewController {
                fullImageVC.image = self.imageTapped
            }
            
        }
    }
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        print(latitude)
        print(longitude)
        
        self.latitude = latitude
        self.longitude = longitude
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
        annotation.coordinate = coordinate
        annotation.title = "Picture!"
        self.mapView.addAnnotation(annotation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
