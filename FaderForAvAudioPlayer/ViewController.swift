import UIKit
import AVFoundation

private let audioFileName = "i_ll_be_waiting_carlos_vallejo.mp3"

class ViewController: UIViewController {
  private var player: AVAudioPlayer?
  private var fader: iiFaderForAvAudioPlayer?
  @IBOutlet weak var sliderParentView: UIView!
  @IBOutlet weak var fadingLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    sliderParentView.backgroundColor = nil
    createControls()
    playSound(audioFileName)
    player?.volume = 0

    if let currentPlayer = player {
      fadeIn(currentPlayer)
    }

    UILabel.appearance().textColor = UIColor.whiteColor()
    UIView.appearance().tintColor = UIColor(
      red: 255.0/255,
      green: 134.0/255,
      blue: 170.0/255,
      alpha: 1)
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }

  private func createControls() {
    SliderControls.create(AppDelegate.current.controls.allArray,
      delegate: nil, superview: sliderParentView)
  }

  @IBAction func onFadeInTapped(sender: AnyObject) {
    fadingLabel.hidden = false
    fadingLabel.text = "Fading in..."

    if let currentPlayer = player {
      fadeIn(currentPlayer)
    }
  }

  @IBAction func onFadeOutTapped(sender: AnyObject) {
    fadingLabel.hidden = false
    fadingLabel.text = "Fading out..."

    if let currentPlayer = player {
      fadeOut(currentPlayer)
    }
  }

  private func fadeIn(aPlayer: AVAudioPlayer) {
    fader =  ViewController.initFader(aPlayer, fader: fader)
    fader?.fadeIn(
      AppDelegate.current.controls.value(ControlType.duration),
      velocity: AppDelegate.current.controls.value(ControlType.velocity)) { finished in

      if finished {
        self.fadingLabel.hidden = true
      }
    }
  }

  private func fadeOut(aPlayer: AVAudioPlayer) {
    fader = ViewController.initFader(aPlayer, fader: fader)

    fader?.fadeOut(
      AppDelegate.current.controls.value(ControlType.duration),
      velocity: AppDelegate.current.controls.value(ControlType.velocity)) { finished in

      if finished {
        self.fadingLabel.hidden = true
      }
    }
  }

  private func playSound(fileName: String) {
    let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName, nil, nil)
    let newPlayer = try? AVAudioPlayer(contentsOfURL: soundURL)
    newPlayer?.numberOfLoops = -1

    if player != nil { return } // already playing

    player = newPlayer
    newPlayer?.play()
  }

  private class func initFader(player: AVAudioPlayer, fader: iiFaderForAvAudioPlayer?)
    -> iiFaderForAvAudioPlayer {

    if let currentFader = fader {
      currentFader.stop()
    }

    return iiFaderForAvAudioPlayer(player: player)
  }
}

