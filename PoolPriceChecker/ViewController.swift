//
//  ViewController.swift
//  PoolPriceChecker
//
//  Created by Akilesh Bapu on 6/27/16.
//  Copyright © 2016 SimpleEconomics. All rights reserved.
//

import UIKit
import UberRides
import MapKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var atokens: String = ""
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let scopes: [RidesScope] = [.Profile, .Places, .Request]
        let loginManager = LoginManager(loginType: .Native)
        let loginButton = LoginButton(frame: CGRectMake(100, 100, 200, 40), scopes: scopes, loginManager: loginManager)
        loginButton.presentingViewController = self
        loginButton.delegate = self
        view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
//        let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
        // Optional, defaults to using the user’s current location for pickup
//        let location = CLLocation(latitude: 37.787654, longitude: -122.402760)
//        let parameters = RideParametersBuilder().setPickupLocation(location).build()
//        let button = RideRequestButton(rideParameters: parameters, requestingBehavior: behavior)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
//        startLoading()
//        self.view.addSubview(button)
//        let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
        // Optional, defaults to using the user’s current location for pickup
//        let pickupLocation = CLLocation(latitude: 37.323474, longitude: -122.021607)
//        let dropOffLocation = CLLocation(latitude: 37.332096, longitude: -121.912716)
//        let parameters = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropOffLocation).build()
//        let button = RideRequestButton(rideParameters: parameters, requestingBehavior: behavior)
//        self.view.addSubview(button)
        
    }
    public func countdown() {
        if (count == 0) {
            startLoading()
            count = 10
            countLabel.text = String(count)
        }
        else {
            count -= 1
            countLabel.text = String(count)
        }
    }
    public func startLoading() {
        print("being run")
        var addressString: String = "https://api.uber.com/v1/estimates/price?start_latitude=37.323474&start_longitude=-122.021607&end_latitude=37.332096&end_longitude=-121.912716&server_token=KlyzcU5AyECxYfU79hgdIrKVcza8wvaR--3_wIex"
        let url: NSURL = NSURL(string: addressString)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    var concat: String! = jsonResult["prices"]![0]!["estimate"] as! String
//                    print(concat)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.priceLabel.text = concat
                    })
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        })
        beMoreAccurate()
    }
    
    public func beMoreAccurate() {
        print("LET's BE MORE ACCURATE")
        let ridesClient = RidesClient(accessTokenIdentifier: self.atokens)
        let pickupLocation = CLLocation(latitude: 37.323474, longitude: -122.021607)
        let dropOffLocation = CLLocation(latitude: 37.332096, longitude: -121.912716)
    let parameters = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropOffLocation).setProductID("ee3ab307-e340-4406-b5ec-9f8c3b43075a").build()

        ridesClient.fetchRideRequestEstimate(parameters) { (estimate, response) in
            print(response.error?.code)
            print(estimate?.priceEstimate?.estimate)
        }
        
        let button = RideRequestButton()
        var builder = RideParametersBuilder().setPickupLocation(pickupLocation).setDropoffLocation(dropOffLocation)
//        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
//            product, response in
//            if let productID = product?.productID {
//                builder = builder.setProductID(productID)
//                button.rideParameters = builder.build()
//                button.loadRideInformation()
//            }
//        })
//        builder = builder.setProductID("ee3ab307-e340-4406-b5ec-9f8c3b43075a")
//        button.rideParameters = builder.build()
//        button.loadRideInformation()
//        var cons: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 300.0)
//        button.addConstraint(cons)
//        cons.active = true
////        self.view.addSubview(button)
//        
//        
//        ridesClient.fetchPriceEstimates(pickupLocation: pickupLocation, dropoffLocation: dropOffLocation) { (priceEstimates, response) in
//            if let error = response.error {
//                return
//            }
//            for price in priceEstimates {
//                print(price.estimate)
//            }
//        }
//        ridesClient.fetchProducts(pickupLocation: pickupLocation, completion:{ products, response in
//            if let error = response.error {
//                // Handle error
//                return
//            }
//            for product in products {
//                // Use product
//                
//            }
//        })
    }
    public func loginButton(button: LoginButton, didLogoutWithSuccess success: Bool) {
        // success is true if logout succeeded, false otherwise
    }
    public func loginButton(button: LoginButton, didCompleteLoginWithToken accessToken: AccessToken?, error: NSError?) {
//        if let baller = accessToken?.tokenString {
//            self.atokens = baller
//            print("ACCESS TOKEN BABE")
//            print(self.atokens)
//            // AccessToken Saved
//        } else if let error = error {
//            // An error occured
//            print(error)
//        }
        print(accessToken!.tokenString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

