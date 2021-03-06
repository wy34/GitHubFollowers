//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by William Yeung on 3/19/21.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: - Properties
    var isUsernameEntered: Bool { return !userNameTextField.text!.isEmpty }
    
    // MARK: - Views
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, userNameTextField, callToActionButton)
        createKeyboardTapGesture()
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextField.text = ""
    }
    
    // MARK: - UI
    func createKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        userNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Selector
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for ????.", buttonTitle: "OK")
            return
        }
        
        userNameTextField.resignFirstResponder()
        
        let followerListVC = FollowerListVC(username: userNameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

// MARK: - UITextField Delegate
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
