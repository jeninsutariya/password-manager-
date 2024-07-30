//
//  ViewController.swift
//  Password Manager
//
//  Created by Apple on 29/07/24.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.75)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(navigateToNewScreen), userInfo: nil, repeats: false)
     }
    @objc func navigateToNewScreen() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        {
            let reason = "Touch ID for appName"
                    view.addSubview(blurView)
                    NSLayoutConstraint.activate([
                        blurView.topAnchor.constraint(equalTo: self.view.topAnchor),
                        blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        blurView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                    ])
                    
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    self?.blurView.removeFromSuperview()
                    if success {
                        self?.navigateToHome()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func navigateToHome() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "PasswordManagerHomeVC")
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

func width(text: String, height: CGFloat = 30) -> CGFloat {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "AltoneTrial-Regular", size: 16) ?? .systemFont(ofSize: 16)
    ]
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
    let textWidth = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).width.rounded(.up)
    
    return textWidth
}

func topMostViewController() -> UIViewController {
    return (UIApplication.shared.delegate as! AppDelegate).visibleViewController ?? UIViewController()
}
func showToast(message : String) {
    
    let width = width(text: message) + 50
    
    let toastLabel = UILabel(frame: CGRect(x: topMostViewController().view.frame.size.width / 2 - (width / 2), y: topMostViewController().view.frame.size.height - 80, width: width, height: 35))
    toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    toastLabel.textColor = UIColor.black
    toastLabel.font = UIFont(name: "AltoneTrial-Regular", size: 16)
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    topMostViewController().view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 0.2, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
