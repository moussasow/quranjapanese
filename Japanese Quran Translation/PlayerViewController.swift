//
//  PlayerViewController.swift
//  Japanese Quran Translation
//
//  Created by Sow Moussa on 2018/01/07.
//  Copyright © 2018 Sow Moussa. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class PlayerViewController: UIViewController {

    @IBOutlet weak var surahImage: UIImageView!
    @IBOutlet weak var surahNameKana: UILabel!
    @IBOutlet weak var surahName: UILabel!
    @IBOutlet weak var playerControlToolbar: UIToolbar!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playbackDurationLabel: UILabel!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var uiDownloadButton: UIButton!
    
    var surahInfo: SurahModel?
    var audioPlayer : AVPlayer?
    var playerItem : AVPlayerItem?
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var isPlaying = false
    fileprivate let seekDuration: Float64 = 5
    var timeObserverToken : Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("cycle viewDidLoad")
        
        // Do any additional setup after loading the view.        
        Helper.loadImage(imageView: surahImage, url: (surahInfo?.imageUrl)!)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        //audioPlayer?.removeTimeObserver(timeObserverToken ?? self)
        resetPlayer()
        NSLog("cycle viewDidDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NSLog("cycle viewWillAppear")
        preparePlayerPlayback()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NSLog("cycle viewWillDisappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status : AVPlayerItemStatus = self.playerItem!.status as AVPlayerItemStatus
            
            if status == .readyToPlay {
                // 再生準備完了
                stopProgressBar()
                displaySurahInfo()
                initPlayerControlIcons()
                NSLog("ReadyToPlay")
                self.startPlayback()
            } else if status == .failed {
                NSLog("Failed")
            } else if status == .unknown {
                NSLog("Unknown")
            }
        } else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                                         change: change,
                                         context: context)
        }
    }
    
    func preparePlayerPlayback() -> Void {
        // backgroud playback
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
            return
        }
        
        createProgressBar()
        var url = URL(string: (surahInfo?.audioUrl)!)
        let fileUrl = getSaveFileUrl(fileName: (surahInfo?.audioUrl)!)
        if isFileDownloaded(fileUrl: fileUrl) {
            url = fileUrl
        }
        
        playerItem = AVPlayerItem(url: url!)
        self.playerItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        audioPlayer = AVPlayer(playerItem: playerItem)
        showProgressBar()
        registerPlayProgress()
    }
    
    func displaySurahInfo() -> Void {
        surahName.text = surahInfo?.name
        surahNameKana.text = surahInfo?.nameKana
        playbackDurationLabel.text = playerItem?.duration.durationText
        playerSlider.maximumValue = (playerItem?.duration.durationSeconds)!
        
        let fileUrl = getSaveFileUrl(fileName: (surahInfo?.audioUrl)!)
        if isFileDownloaded(fileUrl: fileUrl) {
            uiDownloadButton.titleLabel?.text = "SAVED"
        }
    }
    
    func initPlayerControlIcons() -> Void {
        var items = self.playerControlToolbar.items
        items![2] = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(PlayerViewController.playButtonClick(_:)))
        self.playerControlToolbar.setItems(items, animated: true)
    }
    
    func registerPlayProgress() -> Void {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        timeObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) {
                [weak self] time in
                // update player transport UI
            self?.currentTimeLabel.text = self?.audioPlayer?.currentTime().durationText
            self?.playerSlider.value = (self?.audioPlayer?.currentTime().durationSeconds)!
        }
    }
    
    func resetPlayer() -> Void {
        if (audioPlayer == nil) {
            return
        }
        
        audioPlayer?.removeTimeObserver(timeObserverToken ?? self)
        audioPlayer?.pause()
        audioPlayer = nil
        playerItem = nil
        isPlaying = false
    }
    
    func startPlayback() -> Void
    {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pausePlayback() -> Void
    {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stopPlayback() -> Void {
        audioPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        audioPlayer?.pause()
    }
    
    func rewindPlayback() -> Void {
        let playerCurrentTime = CMTimeGetSeconds((audioPlayer?.currentTime())!)
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
        audioPlayer?.seek(to: time2)
    }
    
    func forwardPlayback() -> Void {
        guard let duration  = audioPlayer?.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds((audioPlayer?.currentTime())!)
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(Int64(newTime * 1000 as Float64), 1000)
            audioPlayer?.seek(to: time2)
        }
    }
    
    @IBAction func rewindButtonClick(_ sender: Any) {
        if !isPlaying {
            return
        }
        rewindPlayback()
    }
    
    @IBAction func forwardButtonClick(_ sender: Any) {
        if !isPlaying {
            return
        }
        forwardPlayback()
    }
    
    @IBAction func playButtonClick(_ sender: Any) {
        var items = self.playerControlToolbar.items
        if isPlaying {
            items![2] = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(PlayerViewController.playButtonClick(_:)))
            pausePlayback()
        } else {
            items![2] = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(PlayerViewController.playButtonClick(_:)))
            startPlayback()
        }
        
        self.playerControlToolbar.setItems(items, animated: true)
    }

    @IBAction func stopButtonClick(_ sender: Any) {
        stopPlayback()
        isPlaying = false
        showPlayIcon()
    }
    
    @IBAction func onSliderChange(_ sender: Any) {
    }
    
    func createProgressBar() -> Void {
        //activityIndicator.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
    }
    func showProgressBar() -> Void {
        activityIndicator.startAnimating()
    }
    
    func stopProgressBar() -> Void {
        activityIndicator.stopAnimating()
    }
    
    // MARK: Icons display
    func showPlayIcon() -> Void {
        var items = self.playerControlToolbar.items
        items![2] = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(PlayerViewController.playButtonClick(_:)))
        self.playerControlToolbar.setItems(items, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onPlayVideoClick(_ sender: Any) {
        resetPlayer()
        let vvc = storyboard?.instantiateViewController(withIdentifier: "showYoutube") as! VideoViewController
        vvc.videoCode = "BRCLnzvn_T0"
        navigationController?.pushViewController(vvc, animated: true)
    }
    
    @IBAction func onDownloadSurahClick(_ sender: Any) {
        startDownload(audioUrl: (surahInfo?.audioUrl)!)
    }
    
    func startDownload(audioUrl:String) -> Void {
        let fileUrl = self.getSaveFileUrl(fileName: audioUrl)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(audioUrl, to:destination)
            .downloadProgress { (progress) in
                self.surahNameKana.text = (String)(progress.fractionCompleted)
            }
            .responseData { (data) in
                self.surahNameKana.text = "Completed!"
        }
    }
    
    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
    
    func isFileDownloaded(fileUrl: URL) -> Bool {
        let filePath = fileUrl.path
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: filePath)) {
            return true
        } else {
            return false
        }
    }
}
