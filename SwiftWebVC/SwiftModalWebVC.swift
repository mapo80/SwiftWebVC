//
//  SwiftModalWebVC.swift
//
//  Created by Myles Ringle on 24/06/2015.
//  Transcribed from code used in SVWebViewController.
//  Copyright (c) 2015 Myles Ringle & Oliver Letterer. All rights reserved.
//

import UIKit

public class SwiftModalWebVC: UINavigationController {
    
    public enum SwiftModalWebVCTheme {
        case lightBlue, lightBlack, dark
    }
    public enum SwiftModalWebVCDismissButtonStyle {
        case arrow, cross
    }
    
    //public var webViewDelegate: SwiftWebVCDelegate?
    
    public convenience init(urlString: String, bodyString: String? = nil, webViewDelegate: SwiftWebVCDelegate?) {
        var urlString = urlString
        if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
            urlString = "https://"+urlString
        }
        
        //need to use MutableRequest to set HTTPMethod to Post.
        var url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL: url!)
        
        if let body = bodyString {
            request.HTTPMethod = "POST"
            var bodyData: String = bodyString
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        self.init(request: request, webViewDelegate: webViewDelegate)
    }
    public init(request: URLRequest, webViewDelegate: SwiftWebVCDelegate?, theme: SwiftModalWebVCTheme = .lightBlue, dismissButtonStyle: SwiftModalWebVCDismissButtonStyle = .arrow) {
        let webViewController = SwiftWebVC(request: request, delegate: webViewDelegate)
        
        webViewController.storedStatusColor = UINavigationBar.appearance().barStyle
        
        let dismissButtonImageName = (dismissButtonStyle == .arrow) ? "SwiftWebVCDismiss" : "SwiftWebVCDismissAlt"
        let doneButton = UIBarButtonItem(image: SwiftWebVC.bundledImage(named: dismissButtonImageName),
                                         style: UIBarButtonItemStyle.plain,
                                         target: webViewController,
                                         action: #selector(SwiftWebVC.doneButtonTapped))
        
        switch theme {
        case .lightBlue:
            doneButton.tintColor = nil
            webViewController.buttonColor = nil
            webViewController.titleColor = UIColor.black
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        case .lightBlack:
            doneButton.tintColor = UIColor.darkGray
            webViewController.buttonColor = UIColor.darkGray
            webViewController.titleColor = UIColor.black
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        case .dark:
            doneButton.tintColor = UIColor.white
            webViewController.buttonColor = UIColor.white
            webViewController.titleColor = UIColor.groupTableViewBackground
            UINavigationBar.appearance().barStyle = UIBarStyle.black
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            webViewController.navigationItem.leftBarButtonItem = doneButton
        }
        else {
            webViewController.navigationItem.rightBarButtonItem = doneButton
        }
        super.init(rootViewController: webViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
}
