//
//  DetailViewController.swift
//  RRNMetering
//
//  Created by Vlad Ralovich on 1.07.21.
//

import UIKit
import Kanna
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceTableView: UITableView!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var updateButtonOutlet: UIButton!
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var webViewSwitch: UISwitch!
    
    
    var titleForLabel = ""
    var ipPost = ""
    let activiti = UIActivityIndicatorView()
    var deviceArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.uiDelegate = self
        myWebView.navigationDelegate = self
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        
        myWebView.isHidden = true
        
        view.addSubview(activiti)
        activiti.translatesAutoresizingMaskIntoConstraints = false
        activiti.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activiti.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activiti.isHidden = false
        activiti.startAnimating()
        updateButtonOutlet.isHidden = true
        
        titleLabel.text = titleForLabel
        ipLabel.text = ipPost
        load()
        activitiSetup()
    }

    func load() {
        
        let request = URLRequest(url: URL(string: "http://192.168.1.1")!)
        
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
        deviceArray = []
        activitiSetup()
        
    }
        
    func activitiSetup() {
        activiti.isHidden = false
        self.updateButtonOutlet.isHidden = true
        self.deviceTableView.isHidden = true
        self.webViewSwitch.isHidden = true
        self.myWebView.isHidden = true
        
        activiti.startAnimating()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            DispatchQueue.main.async { [weak self] in
                self?.updateButtonOutlet.isHidden = false
                self?.deviceTableView.isHidden = false
                self?.webViewSwitch.isHidden = false
                self?.webviewHiden()
                self?.activiti.stopAnimating()
                self?.activiti.isHidden = true
                let urlTable = URL(string: "http://192.168.1.1/html/advance.html#arp_table")
                self?.myWebView.load(URLRequest(url: urlTable!))
            }
        })
    }
    
    func webviewHiden() {
        if webViewSwitch.isOn {
            myWebView.isHidden = false
        } else {
            myWebView.isHidden = true
        }
    }
    
    @IBAction func webViewSwitchAction(_ sender: Any) {
        webviewHiden()
    }
}

extension DetailViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async { [weak self] in
                self?.myWebView.evaluateJavaScript("arp_table_info_view_data_edit.children[0].children[0].children[1].innerHTML") { res, error in
                   
                    if res != nil {
                        let ppp: String = res as! String
                        
                        if let kanna = try? Kanna.HTML(html: ppp, encoding: String.Encoding.utf8) {
                            
                            for (index, link) in kanna.xpath("//td").enumerated() {
                                
                                if index == 0 || index % 5 == 0 {
                                    self?.deviceArray.append(link.text!)
                                }
                            }
                            self?.deviceTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            guard let body = message.body as? [String: Any] else {
                return
            }
            
            guard (body["payload"] as? String) != nil else {
                return
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = deviceArray[indexPath.row]
        return cell
    }
}
