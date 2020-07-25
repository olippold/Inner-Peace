//
//  ViewController.swift
//  Inner Peace
//
//  Created by Oliver Lippold on 18/07/2020.
//  Copyright © 2020 Oliver Lippold. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var background: UIImageView!
    @IBOutlet var quote: UIImageView!
    var shareQuote: Quote?
    
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let quote = shareQuote else {
            fatalError("Attempted to share a quote that didn't exist.")
        }
        
        let ac = UIActivityViewController(activityItems: [quote.shareMesswage], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender
        present(ac, animated: true)
    }
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    override func viewDidLoad() {

        super.viewDidLoad()
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if allowed {
                self.configureAlerts()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuote()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuote()
    }
    
    func updateQuote() {
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image")
        }
        
        background.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else {
            fatalError("Unable to read a quote")
        }
        shareQuote = selectedQuote
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: 250, left: 250, bottom: 250, right: 250))
        
        var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude,
                               height: CGFloat.greatestFiniteMagnitude)
        var fontSize: CGFloat = 120
        var font: UIFont!
        
        var attrs: [NSAttributedString.Key: Any]!
        var str: NSAttributedString!
        
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)
            attrs = [.font: font, .foregroundColor: UIColor.white]
            str = NSAttributedString(string: selectedQuote.text, attributes: attrs)
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            
            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
            
            let format = UIGraphicsImageRendererFormat()
            format.opaque = false
            let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)
            quote.image = renderer.image { ctx in
                for i in 1...5 {
                    ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i * 2), color: UIColor.black.cgColor)
                    str.draw(in: quoteRect)
                }

            }
        }
    }
    
    func configureAlerts() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        let shuffled = quotes.shuffled()
        
        for i in 1...5 {
            let content = UNMutableNotificationContent()
            content.title = "Inner Peace"
            content.body = shuffled[i].text
            
            var dateComponents = DateComponents()
            dateComponents.day = i
            
            let alertDate = Date().byAdding(days: 1)
            
            //if let alertDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
                dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
                dateComponents.hour = 10
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request) { error in
                    if let e = error {
                        print("Error: \(e.localizedDescription)")
                    }
                }
            //}
        }
    }


}

