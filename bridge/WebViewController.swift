import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www")!
   
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        print("url::\(url)")
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent="webview"
        let pref:WKWebpagePreferences=WKWebpagePreferences()
        let pf:WKPreferences=WKPreferences()
        let wDBSetWebSecurity = WDBSetWebSecurity()
        wDBSetWebSecurity.prefs = pf
        wDBSetWebSecurity.enabled = false
        wDBSetWebSecurity.update()
        webConfiguration.preferences=pf
        webConfiguration.defaultWebpagePreferences=pref
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            view.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        view.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        view.loadFileURL(url, allowingReadAccessTo: url)
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let url=navigationAction.request.url
            let scheme=url?.scheme
            
            if (url?.absoluteString=="about:blank" || scheme=="abc") {
                let query=url?.query
                let body=navigationAction.request.httpBody
                
                if let action = url?.host as? String {
                    let jsonObject: NSMutableDictionary = NSMutableDictionary()
                    jsonObject.setValue("10/04/2015 12:45", forKey: "startDate")
                    jsonObject.setValue("10/04/2015 16:00", forKey: "endDate")
                    jsonObject.setValue(1, forKey: "model_id")
                    jsonObject.setValue(2, forKey: "type_id")
                    
                    do {
                        let jsonData: NSData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
                        let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                            
                        webView.evaluateJavaScript(action+"('\(jsonString)')") { (result, error) in
                            if let res = result as? String {
                                print("res::"+res)
                            }
                        }
                    } catch _ {
                        print ("JSON Failure")
                    }
                }
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
            return
        }
    }
}
