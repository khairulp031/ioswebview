import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var title: String
    var url: URL
    var loadStatusChanged: ((Bool, Error?) -> Void)? = nil

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let unwrappedUserAgent = result as? String {
                view.customUserAgent = unwrappedUserAgent+" webview"
            }
        }
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("decidePolicyFor")
            let url=navigationAction.request.url
            let scheme=url?.scheme
            
            if (url?.absoluteString=="about:blank" || scheme=="abc") {
                print(url?.absoluteString)
                print("abc://")
                let query=url?.query
                let body=navigationAction.request.httpBody
                
                if let action = url?.host as? String {
                    
                    /*
                     let jsonObject: [String: Any] = [
                         "type_id": 1,
                         "model_id": 1,
                         "transfer": [
                             "startDate": "10/04/2015 12:45",
                             "endDate": "10/04/2015 16:00"
                         ]
                     ]
                     */
                     
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
