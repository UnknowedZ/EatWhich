//
//  mainViewController.swift
//  EatWhich
//
//  Created by 王女士 on 2017/7/12.
//  Copyright © 2017年 王女士. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var swipeLeft :UISwipeGestureRecognizer!;   // 左滑手势
    var swipeRight :UISwipeGestureRecognizer!;  // 右滑手势
    var user:User!
    var flag = 0;
    var blackFilter:UIView!
    
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var aboveView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var rightView: UIView!

    @IBOutlet weak var hunStyle: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var supperRate: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var flashView: UIView!
    
    @IBOutlet weak var menuUp: UIView!
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.backgroundColor = UIColor.clear
        //设置按钮样式
        menuUp.backgroundColor = user.colorTheme
        blackFilter = UIView(frame: UIScreen.main.bounds)
        blackFilter.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackFilter.isHidden = true
        aboveView.addSubview(blackFilter)
        rightView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        menuButton.layer.cornerRadius = 25
        menuButton.layer.masksToBounds = true
        hunStyle.setTitleColor(user.colorTheme, for: .normal)
        hunStyle.layer.borderColor = user.colorTheme.cgColor
        hunStyle.layer.masksToBounds = true
        hunStyle.layer.borderWidth = 2
        hunStyle.layer.cornerRadius = 12;
        menuButton.setBackgroundImage(user.headImage, for: .normal)
        bottomView.center.x -= self.view.bounds.width
        rightView.center.x += self.view.bounds.width
        headImage.layer.cornerRadius = 30
        headImage.layer.masksToBounds = true
        headImage.image = user.headImage
        nameTitle.text = user.name
        flashView.backgroundColor = UIColor.clear
        
        //实现滑动菜单
        swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(mainViewController.swipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.aboveView.addGestureRecognizer(swipeLeft)
        swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(mainViewController.swipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.aboveView.addGestureRecognizer(swipeRight)
        //检测用户能量摄入状态
        switch user.state {
        case 1:
            self.backgroundImage.image = #imageLiteral(resourceName: "back1")
            rate.text = "果腹"
        case 2:
            self.backgroundImage.image = #imageLiteral(resourceName: "back3")
            rate.text = "饱食"
        default:
            self.backgroundImage.image = #imageLiteral(resourceName: "back2")
            rate.text = "少食"
        }
        self.backgroundImage.image = #imageLiteral(resourceName: "ThemeBackground")
        supperRate.textColor = user.colorTheme
        rate.textColor = user.colorTheme
        //加载历史记录
        //user.getRestaurantHistory(number: 30)
    }
    
    @IBAction func touch(_ sender: Any) {
        //加载动画
        let waterView = WaterView(frame: flashView.bounds, state: user.state)
        flashView.addSubview(waterView)
        hunStyle.layer.borderColor = UIColor.white.cgColor
        hunStyle.setTitleColor(.white, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //实现滑动菜单
    func swipe(_ recognizer:UISwipeGestureRecognizer){
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.left{
            UIView.animate(withDuration:0.5, animations: {
                if(self.flag == 1){
                    self.bottomView.center.x -= self.view.bounds.width*0.8
                    self.blackFilter.isHidden = true
                    self.aboveView.center.x -= self.view.bounds.width*0.8
                    self.flag = 0
                    return
                }
                if(self.flag == 0){
                    self.rightView.center.x -= self.view.bounds.width*0.6
                    self.blackFilter.isHidden = false
                    //self.aboveView.center.x -= self.view.bounds.width*0.8
                    self.flag = 2
                    return
                }
            })
            
        }else if recognizer.direction == UISwipeGestureRecognizerDirection.right{
            UIView.animate(withDuration:0.5, animations: {
                if(self.flag == 0){
                    self.bottomView.center.x += self.view.bounds.width*0.8
                    self.blackFilter.isHidden = false
                    self.aboveView.center.x += self.view.bounds.width*0.8
                    self.flag = 1
                    return
                }
                if(self.flag == 2){
                    self.rightView.center.x += self.view.bounds.width*0.6
                    self.blackFilter.isHidden = true
                    //self.aboveView.center.x += self.view.bounds.width*0.8
                    self.flag = 0
                    return
                }
            })
        }
    }
    
    
    @IBAction func openView(_ sender: UIButton) {
        UIView.animate(withDuration:0.5, animations: {
            if(self.flag == 0){
                self.bottomView.center.x += self.view.bounds.width*0.8
                self.blackFilter.isHidden = false
                self.aboveView.center.x += self.view.bounds.width*0.8
                self.flag = 1;
            }
        })
    }
    
    //跳转到推荐界面
    @IBAction func hun_Click(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showCustomView", sender: self)
        
    }
    //跳转到个人信息界面
    @IBAction func toInforma(_ sender: UIButton) {
         self.performSegue(withIdentifier: "toInforma_1", sender: self)
    }
    
    //退出登录
    @IBAction func toLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin_1", sender: self)

    }
    
    //跳转到健康界面
    @IBAction func toHealth(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHealth_1", sender: self)
    }
    
    //跳转到好友界面
    @IBAction func toFriend(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toFriend", sender: self)

    }
    
    @IBAction func toSupper(_ sender: Any) {
        self.performSegue(withIdentifier: "toSupper", sender: self)
    }
    //跳转到关于界面
    @IBAction func toAbout(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toAbout_1", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInforma_1"{
            if let a = segue.destination as? InformationViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "showCustomView"{
            if let a = segue.destination as? CustomInputViewController{
                a.user = self.user
                
            }
        }
        if segue.identifier == "toHealth_1"{
            if let a = segue.destination as? HealthViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "toFriend"{
            if let a = segue.destination as? FriendViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "toAbout_1"{
            if let a = segue.destination as? AboutViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "toSupper"{
            if let a = segue.destination as? SuperTimeViewController{
                a.user = self.user
            }
        }
        if segue.identifier == "showHistory"{
            if let a = segue.destination as? RecordViewController{
                a.user = self.user
                a.record = sender as? EatRecord
            }
        }
        if segue.identifier == "showDetailHistory"{
            if let a = segue.destination as? HistoryViewController{
                a.user = self.user
            }
        }
    }
    //tableview dataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showHistory", sender: user.historyRecord[indexPath.row])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.historyRecord.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = user.historyRecord[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let historyCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! HistoryTableViewCell
        historyCell.title.text! = restaurant.restaurant["name"] as! String
        historyCell.timeLabel.text! = dateFormatter.string(from: restaurant.date)
        historyCell.backgroundColor = UIColor.clear
        switch restaurant.state{
        case -1:
            historyCell.RestImage.image = #imageLiteral(resourceName: "restaurantblue")
        case 1:
            historyCell.RestImage.image = #imageLiteral(resourceName: "restaurantred")
        default:
            historyCell.RestImage.image = #imageLiteral(resourceName: "restaurantgreen")
        }
        return historyCell
    }
    @IBAction func showDetailHistory(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetailHistory", sender: self.user)
    }
    //清空历史记录
    @IBAction func deleteHistory(_ sender: Any) {
        let headers = [
            "authorization": "Basic eGp5OjIwMTcwNzI0",
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "ee43bdf3-ee2a-7154-7594-1a0a63de0eb1"
        ]
        let parameters = [
            "userID": user.userName
            ] as [String : Any]
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://www.sgmy.site/api/v2.0/deletehistory")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    NSLog(error.debugDescription)
                } else {
                    let json = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    let status = json?.object(forKey: "result") as! String
                    if status == "True"{
                        let alertController = UIAlertController(title: "Warning",message: " 清空成功", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.user.historyRecord = []
                    }
                }
            })
            dataTask.resume()
        }
        catch let error{
            NSLog("JSON失败\(error)")
        }
    }
}


