//
//  CounterViewController.swift
//  SwiftCounter_1
//
//  Created by Yongzhi on 02/03/16.
//  Copyright © 2016 Yongzhi. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController{
    
//    var page = UIView()
    
    //UI Controls
    var timeLabel: UILabel? //show the time left
    var startStopButton: UIButton? // start/stop button
    var clearButton: UIButton? // reset button
    var timeButtons: [UIButton]? //set the time
    let timeButtonInfos = [("1min",60),("3min",180),("5min",300),("Second",1)]
    var textLabel: UILabel? //show the text I want to say
    
    var remainingSeconds: Int = 0{
        willSet(newSeconds){
            
            let mins = newSeconds / 60
            let seconds = newSeconds % 60
            
            timeLabel!.text = NSString(format: "%02d:%02d", mins,seconds) as String
            
            if newSeconds <= 0 {
                isCounting = false
                self.startStopButton!.alpha = 0.3
                self.startStopButton!.enabled = false
            }else{
                self.startStopButton!.alpha = 1.0
                self.startStopButton!.enabled = true
            }
        }
    }
    
    var timer:NSTimer?
    var isCounting: Bool = false{
        willSet(newValue){
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonEnabled(!newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg1.jpg")!)
        setupTimeLabel()
        setuptimeButtons()
        setupActionButtons()
        setupTextLabel()
        
        remainingSeconds = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame = CGRectMake(10, 40, self.view.bounds.size.width-20, 120)
        
        textLabel!.frame = CGRectMake(10, 360, self.view.bounds.size.width-20, 100)
        
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
        for (index, button) in (timeButtons!).enumerate() {
            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
        }
        
//        (timeButtons!.count - 1)
//        for (index, button) in (timeButtons!).enumerate() {
//            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
//            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
//        }
        
        startStopButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
        clearButton!.frame = CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44)
        
    }
    
    
    //UI Helpers
    
    func setupTextLabel(){
        
        textLabel = UILabel()
        textLabel!.text = "Let's Roll !"
        textLabel!.textColor = UIColor.orangeColor()
        textLabel!.font = UIFont(name: "Helvetica", size: 27)
//        timeLabel!.backgroundColor = UIColor.blackColor()
        textLabel!.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(textLabel!)
        
    }
    
    func setupTimeLabel(){
        
        timeLabel = UILabel()
        timeLabel!.textColor = UIColor.redColor()
        timeLabel!.font = UIFont(name: "Helvetica", size: 80)
//        timeLabel!.backgroundColor = UIColor.blackColor()
        timeLabel!.textAlignment = NSTextAlignment.Center
        timeLabel!.layer.cornerRadius = 8
        self.view.addSubview(timeLabel!)
        
    }
    
    func setuptimeButtons(){
        
        var buttons: [UIButton] = []
        for (index,(title,_)) in timeButtonInfos.enumerate(){
            
            let button: UIButton = UIButton()
            button.tag = index //save the index of button
            button.setTitle("\(title)", forState: UIControlState.Normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons += [button]
            self.view.addSubview(button)
            
        }
        timeButtons = buttons
        
        
        
    }
    
    func setupActionButtons(){
        //create start/stop button
        startStopButton = UIButton()
        startStopButton!.backgroundColor = UIColor.redColor()
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton!.setTitle("Start/Stop", forState: UIControlState.Normal)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        startStopButton!.layer.cornerRadius = 8
        self.view.addSubview(startStopButton!)
        
        
        clearButton = UIButton()
        clearButton!.backgroundColor = UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("Reset", forState: UIControlState.Normal)
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton!.layer.cornerRadius = 8
        self.view.addSubview(clearButton!)
    }
    
    func setSettingButtonEnabled(enabled: Bool) {
        for button in self.timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
    }
    
    //Actions
    func timeButtonTapped(sender: UIButton){
        let(_, seconds) =  timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    func startStopButtonTapped(sender: UIButton){
        isCounting = !isCounting
        
        if isCounting {
            createAndFireLocalNotificationAfterSeconds(remainingSeconds)
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
    }
    
    func clearButtonTapped(sender: UIButton){
        remainingSeconds = 0
    }
    
    func updateTimer(sender: NSTimer){
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            //            let alert = UIAlertView()
            let alert = UIAlertController(title: "Counting Time finished", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction)
            //            var cancelAction = UIAlertAction(title: "cancle", style: UIAlertActionStyle.Cancel, handler: nil)
            //            var okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
            //            alertController.addAction(cancelAction)
            //            alertController.addAction(okAction)
            //            alert.message = ""
            //            alert.addButtonWithTitle("OK")
            //            alert.show()
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Helpers
    
    func createAndFireLocalNotificationAfterSeconds(seconds: Int) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        
        let timeIntervalSinceNow = Double(seconds)
        notification.fireDate = NSDate(timeIntervalSinceNow:timeIntervalSinceNow);
        
        notification.timeZone = NSTimeZone.systemTimeZone();
        notification.alertBody = "Counting Time finished";
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
        
    }
    
    
    
}