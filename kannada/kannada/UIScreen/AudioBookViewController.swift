//
//  AudioBookViewController.swift
//  kannada
//
//  Created by PraveenH on 04/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import AVFoundation


class AudioBookViewController: UIViewController {

    @IBOutlet weak var ibAudioSliderBar: CustomUISlider!
    @IBOutlet weak var ibBooNameLbl: UILabel!
    @IBOutlet weak var ibPlayBtn: UIButton!
    var player : AVPlayer?
    private var playbackLikelyToKeepUpContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapOnPlayBtn(_ sender: Any) {
        
        if ibPlayBtn.isSelected {
            self.ibPlayBtn.isSelected = false
            self.player?.pause()
        }else if player != nil {
            self.ibPlayBtn.isSelected = true
            self.player?.play()
        }else{
            self.ibPlayBtn.isSelected = true
            let urlString = "http://softwaresolutionpvt.com/bookapp/audiobooks/%E0%B2%B5%E0%B3%86%E0%B2%82%E0%B2%95%E0%B2%9F%E0%B2%B6%E0%B2%BE%E0%B2%AE%E0%B2%BF%E0%B2%AF%20%E0%B2%AA%E0%B3%8D%E0%B2%B0%E0%B2%A3%E0%B2%AF.mp3"
             guard let url = URL.init(string: urlString) else { return }
             let playerItem = AVPlayerItem.init(url: url)
             self.player = AVPlayer.init(playerItem: playerItem)
             self.player?.play()
             self.player?.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)
          
        }
    }
    
    func addObserver() {
       // print(self.player?.volume)
         if let stime = self.player?.currentItem?.duration {
            let total = CMTimeGetSeconds(stime)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            let formattedString = formatter.string(from: TimeInterval(total))!
            print(formattedString)
        }
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            if let duration = self.player?.currentItem?.duration {
                print(duration)
              let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                
                
              let progress = (time/duration)
              self.ibAudioSliderBar.value = Float(progress)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &playbackLikelyToKeepUpContext {
            if  self.player?.currentItem?.isPlaybackLikelyToKeepUp ?? false {
               // loadingIndicatorView.stopAnimating() or something else
                 self.addObserver()
                print("loadingIndicatorView.stopAnimating()")
            } else {
               // loadingIndicatorView.startAnimating() or something else
                print("loadingIndicatorView.startAnimating()")
               
            }
        }
    }
    
    @IBAction func didTapOnForwordBtn(_ sender: Any) {
    }
    
    
    @IBAction func didTapOnBackBtn(_ sender: Any) {
    }
    
     
}

class CustomUISlider : UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {

        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "sliderthumb"), for: .normal)
        super.awakeFromNib()
    }
}


