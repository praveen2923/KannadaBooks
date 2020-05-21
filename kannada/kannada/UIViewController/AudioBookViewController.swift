//
//  AudioBookViewController.swift
//  kannada
//
//  Created by PraveenH on 04/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import AVFoundation
import AuthenticationServices
import FBSDKLoginKit

class AudioBookViewController: UIViewController {
 
    @IBOutlet weak var padlock: CircleView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ibAudioTitle: UILabel!
    @IBOutlet weak var ibFaceLoginView: UIView!
    @IBOutlet weak var ibcMoveAudioview: NSLayoutConstraint!
    @IBOutlet weak var ibAudioSliderBar: CustomUISlider!
    @IBOutlet weak var ibBooNameLbl: UILabel!
    @IBOutlet weak var ibPlayBtn: UIButton!
    @IBOutlet weak var ibAudioControllerview: UIView!
    
    @IBOutlet weak var ibCurrentplaytTimeLbl: UILabel!
    @IBOutlet weak var ibAudioDurationLbl: UILabel!
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    var player : AVPlayer?
    private var playbackLikelyToKeepUpContext = 0
    var audioBooks = [AudioBook]()
    var timeObserver : Any?
    var playerIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.ibcMoveAudioview.constant = 124
        self.ibPlayBtn.isHidden = true
        self.getAudioFiles()
        self.setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          self.facbookLogin()
    }
    
    //MARK:- Login Maintain
    func facbookLogin()  {
        
        let fbLoginButton = FBLoginButton()
        fbLoginButton.permissions = ["public_profile", "email"]
        fbLoginButton.delegate = self
        fbLoginButton.frame =  CGRect(x: 0, y: 0, width: self.ibFaceLoginView.frame.size.width, height: self.ibFaceLoginView.frame.size.height)
        
        self.ibFaceLoginView.addSubview(fbLoginButton)
        
    }

      func setupProviderLoginView() {
          let authorizationButton = ASAuthorizationAppleIDButton()
          authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
          self.loginProviderStackView.addArrangedSubview(authorizationButton)
      }
      
      /// - Tag: perform_appleid_request
      @objc func handleAuthorizationAppleIDButtonPress() {
          let appleIDProvider = ASAuthorizationAppleIDProvider()
          let request = appleIDProvider.createRequest()
          request.requestedScopes = [.fullName, .email]
          
          let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
      }
    
    func getAudioFiles()  {
      self.showeLoading()
        APIManager.getListOfAudioBooks { (error, result) in
           self.hideLoading()
           if let values = result as? Array<Any> {
               for item in values {
                 if let abook = AudioBook(dictionary: item as! NSDictionary) {
                      self.audioBooks.append(abook)
                  }
               }
               if self.audioBooks.count == 0 {
                   self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
               }else{
                   self.hideLoading()
                   self.tableView.reloadData()
               }
           }else{
               self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
           }
        }
    }
    
    @IBAction func didTapOnPlayBtn(_ sender: Any) {
        
        if ibPlayBtn.isSelected {
            self.ibPlayBtn.isSelected = false
            self.player?.pause()
        }else if self.player != nil {
            self.ibPlayBtn.isSelected = true
            self.player?.play()
        }else{
            self.ibPlayBtn.isSelected = true
            
            if let endpoint = audioBooks[(sender as! UIButton).tag].audiourl {
                
                self.ibAudioTitle.text = audioBooks[(sender as! UIButton).tag].title
                let fullurl = APIList.BOOKBaseUrl + endpoint
                print(fullurl)
                guard let urlS = URL.init(string: fullurl) else { return }

                let playerItem = AVPlayerItem.init(url:urlS)
                playerItem.preferredForwardBufferDuration = 10
                self.player = AVPlayer.init(playerItem: playerItem)
              
                self.player?.automaticallyWaitsToMinimizeStalling = false
                self.player?.playImmediately(atRate: 10)
                self.player?.play()
         
                self.player?.volume = 1.0   
                self.player?.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)
            }
            
        }
    }
    
    @IBAction func playerSeektoSlider(_ sender: Any) {
        let value = self.ibAudioSliderBar.value
          if let totalDuration = self.player?.currentItem?.duration {
            let durationToSeek = Float(CMTimeGetSeconds(totalDuration)) * value
            print(durationToSeek)
          //  self.player?.seek(to:CMTimeMakeWithSeconds(Float64(durationToSeek), preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
    }
    
    func addObserver() {
         if let stime = self.player?.currentItem?.duration {
            self.ibAudioDurationLbl.text = self.getLabelString(CMTimeGetSeconds(stime))
        }
        self.timeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if let duration = self.player?.currentItem?.duration {
                print(duration)
              let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
              let progress = (time/duration)
              self.ibAudioSliderBar.value = Float(progress)
              self.ibCurrentplaytTimeLbl.text = self.getLabelString(time)
                
            }
        })
    }
    
    func getLabelString(_ stime : Float64) -> String {
        if !stime.isNaN {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            let audioDuration = formatter.string(from: TimeInterval(stime))!
            return audioDuration
        }else{
            return ""
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if context == &playbackLikelyToKeepUpContext {
                if self.player?.rate == 0 {
                    print("Stop Playing .startAnimating()")
                    print(self.player?.reasonForWaitingToPlay ?? "")
                    self.padlock.isAnimating = true
                    self.ibPlayBtn.isHidden = true
                }else{
                    self.padlock.isAnimating = false
                    self.padlock.isHidden = true
                    self.ibPlayBtn.isHidden = false
                    self.addObserver()
                }
        
        }
    }
    
    func playaudio(_ index : Int)  {
        self.padlock.isAnimating = true
        self.ibPlayBtn.isHidden = true
        self.ibPlayBtn.isSelected = false
        self.player = nil
        let btn = UIButton()
        btn.tag = index
         self.playerIndex = index
        self.didTapOnPlayBtn(btn)
       
    }
    
    @IBAction func didTapOnForwordBtn(_ sender: Any) {
        if let currentIndex = self.playerIndex {
            let nextPlayerIndex =  currentIndex + 1
            if self.audioBooks.count <= nextPlayerIndex {
                 print("Reached last index")
            }else{
                self.playaudio(nextPlayerIndex)
            }
        }
       
    }
    
    
    @IBAction func didTapOnBackBtn(_ sender: Any) {
        if let currentIndex = self.playerIndex {
            let previousIndex =  currentIndex - 1
            if  previousIndex < 0 {
                 print("Reached first index")
            }else{
                self.playaudio(previousIndex)
            }
        }
    }
    
}

//MARK:- UITableView Delegates
extension AudioBookViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView()  {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.registerCellforTableview()

    }
    
    func registerCellforTableview()  {
        let nib = UINib(nibName: "AudioBookCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AudioBookCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getHistoryCell(indexPath: indexPath)
    }
    
    func getHistoryCell(indexPath: IndexPath) -> AudioBookCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AudioBookCell", for: indexPath) as! AudioBookCell
       
        cell.ibTitleLabel.text = self.audioBooks[indexPath.row].title
        cell.ibSubTitleLabel.text = self.audioBooks[indexPath.row].subtitle
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
                  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.player?.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
        self.timeObserver = nil
        self.view.layoutIfNeeded()
        if  self.ibcMoveAudioview.constant != 0 {
            self.ibcMoveAudioview.constant = 0
            UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
        }
        self.playaudio(indexPath.row)

    }
}

//MARK:- Audio Book CellDelegate
extension AudioBookViewController: AudioBookCellDelegate {
    func didTapOnLikeBtn(_ cell : AudioBookCell) {
        cell.ibLikeBtn.setImage(UIImage(named: "hartfill"), for: .normal)
    }
    
    func didTapOnDownalodBtn(_ cell : AudioBookCell){
        
    }
    
}


//MARK:- Apple Login Delegate
extension AudioBookViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
        
    }
}


extension AudioBookViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//  MARK: - FaceBook LoginButtonDelegate
extension AudioBookViewController: LoginButtonDelegate {

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
         print()
     }
     
     func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
         print()
     }
}
 

