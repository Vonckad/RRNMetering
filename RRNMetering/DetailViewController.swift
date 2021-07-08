//
//  DetailViewController.swift
//  RRNMetering
//
//  Created by Vlad Ralovich on 1.07.21.
//

import UIKit
import Alamofire
import WebKit

class DetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
                    guard let body = message.body as? [String: Any] else {
                        print("could not convert message body to dictionary: \(message.body)")
                        return
                    }

                    guard let payload = body["payload"] as? String else {
                        print("Could not locate payload param in callback request")
                        return
                    }

                    print(payload)
        }
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txLabel: UILabel!
    @IBOutlet weak var rxLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var updateButtonOutlet: UIButton!
    
    @IBOutlet weak var myWebView: WKWebView!
    
    var titleForLabel = ""
    var ipPost = ""
    let activiti = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.uiDelegate = self
        myWebView.navigationDelegate = self
        
        view.addSubview(activiti)
        activiti.translatesAutoresizingMaskIntoConstraints = false
        activiti.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activiti.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activiti.isHidden = true
        
        titleLabel.text = titleForLabel
        ipLabel.text = ipPost
        load()

        
        
       
    }

    func load() {
        
        let request = URLRequest(url: URL(string: "http://192.168.1.1")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let url = response?.url,
                let httpResponse = response as? HTTPURLResponse,
                let fields = httpResponse.allHeaderFields as? [String: String]
            else { return }

            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey: Any]()
                cookieProperties[.name] = cookie.name
                cookieProperties[.value] = cookie.value
                cookieProperties[.domain] = cookie.domain
                cookieProperties[.path] = cookie.path
                cookieProperties[.version] = cookie.version
                cookieProperties[.expires] = Date().addingTimeInterval(31536000)

                let newCookie = HTTPCookie(properties: cookieProperties)
                HTTPCookieStorage.shared.setCookie(newCookie!)

                print("name: \(cookie.name) value: \(cookie.value)")
            }
        }
        .resume()
        
        myWebView.load(request)
        
        
        let javaScript = """
        $(document).ready(function() {
         jQuery("#index_username").val("!!Huawei");
         jQuery("#password").val("@HuaweiHgw");
         jQuery("#loginbtn").click();
        console.log("ss");
        });
        """
        
        let script = WKUserScript(
                    source: javaScript,
                    injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                    forMainFrameOnly: true
        )
        
        myWebView.configuration.userContentController.add(self, name: "callbackHandler")
        myWebView.configuration.userContentController.addUserScript(script)

        
    }
    
    @IBAction func updateAtcion(_ sender: Any) {
       activitiSetup()
        
        
        
    }
    
    func activitiSetup() {
        activiti.isHidden = false
        self.updateButtonOutlet.isHidden = true
        activiti.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async { [weak self] in
                self?.updateButtonOutlet.isHidden = false
                self?.activiti.stopAnimating()
                self?.activiti.isHidden = true
                
                self?.myWebView.load(URLRequest(url: URL(string: "https://192.168.1.1/html/advance.html#arp_table")!))
                self?.myWebView.reload()
            }
        })
    }
}


struct Root: Codable {
//    var csrf: Csrf
    var data: MyData
}

struct Csrf: Codable {
    var csrf_param: String
    var csrf_token: String
    
}

struct MyData: Codable {
    var UserName: String
    var Password: String
}
