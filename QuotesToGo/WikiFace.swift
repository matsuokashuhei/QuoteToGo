/*
The MIT License (MIT)

Copyright (c) 2015 Daniel Autenrieth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
import UIKit
import ImageIO

class WikiFace: NSObject {

     enum WikiFaceError:ErrorType {
        case CouldNotDownloadImage
    }
    
    class func faceForPerson(person:String, size:CGSize, completion:(image:UIImage?, imageFound:Bool!)->()) throws {

        let escapedString = person.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

        
        // Determening the image size that should be requested
        var multiplier = 2
        
        if (UIScreen.mainScreen().bounds.size.height > 667 && UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait) || UIScreen.mainScreen().bounds.size.height > 375 && UIApplication.sharedApplication().statusBarOrientation != UIInterfaceOrientation.Portrait {
            multiplier = 3
        }
        
        let pixelsForAPIRequest = Int(max(size.width,size.height)) * multiplier
        
        // Wikipedia API Request URL
        let url = NSURL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=\(escapedString!)&prop=pageimages&format=json&pithumbsize=\(pixelsForAPIRequest)")
        
        guard let task:NSURLSessionTask? = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil {
                // API result
                let wikiDict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            
                // navigating through JSON structure
                if let query = wikiDict.objectForKey("query") as? NSDictionary {
                    if let pages = query.objectForKey("pages") as? NSDictionary {
                        if let pageContent = pages.allValues.first as? NSDictionary {
                            if let thumbnail = pageContent.objectForKey("thumbnail"){
                                if let thumbURL = thumbnail.objectForKey("source") as? String{ // thumbnail found

                                    let faceImage = UIImage(data: NSData(contentsOfURL: NSURL(string: thumbURL)!)!)
                                    
                                    completion(image: faceImage, imageFound: true)
  
                                }
                            }else{
                                completion(image: nil, imageFound: false)
                            }
                        }
                    }
                }
                
            }
        })else {
            throw WikiFaceError.CouldNotDownloadImage
        }
            
        task!.resume()
    }
    
    class func centerImageViewOnFace (imageView:UIImageView) {
    
        
        // Detecting face with CoreImage
        // https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_detect_faces/ci_detect_faces.html
        let context = CIContext(options: nil)
        let opts = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: opts)
        
        let faceImage = imageView.image
        let ciImage = CIImage(CGImage: faceImage!.CGImage!)
        
        let features = detector.featuresInImage(ciImage)
        
        if features.count > 0 {
            var face:CIFaceFeature!
            
            for rect in features {
                face = rect as! CIFaceFeature
                NSLog("Face found at (%f,%f) of dimensions %fx%f", face.bounds.origin.x, face.bounds.origin.y, face.bounds.width, face.bounds.height);
            }
            
            // increasing the frame size to see a little more than the face rect
            var faceRectWithExtendedBounds = face.bounds
            faceRectWithExtendedBounds.origin.x = faceRectWithExtendedBounds.origin.x - 20
            faceRectWithExtendedBounds.origin.y = faceRectWithExtendedBounds.origin.y - 30
            
            faceRectWithExtendedBounds.size.width = faceRectWithExtendedBounds.size.width + 40
            faceRectWithExtendedBounds.size.height = faceRectWithExtendedBounds.size.height + 60
            
            
            // Face coordinates in percent and conversion from CI Coordinates to UIKit coordinates
            let x = (faceRectWithExtendedBounds.origin.x)  / faceImage!.size.width
            let y = (faceImage!.size.height - faceRectWithExtendedBounds.origin.y - faceRectWithExtendedBounds.height) / faceImage!.size.height
            
            
            // Face size in percent
            let widthFace = faceRectWithExtendedBounds.width / faceImage!.size.width
            let heightFace = faceRectWithExtendedBounds.height / faceImage!.size.height
            
            // Centering image arround face
            imageView.layer.contentsRect = CGRectMake(x, y, widthFace, heightFace)
            
        }
    

    
    }
}