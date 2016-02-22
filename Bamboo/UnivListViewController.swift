//
//  UnivListViewController.swift
//  Bamboo
//
//  Created by 김혜원 on 2015. 12. 23..
//  Copyright © 2015년 ParkTaeHyun. All rights reserved.
//

import UIKit
import Alamofire

class UnivListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //@IBOutlet weak var univListTableView: UICollectionView!
    
    @IBOutlet weak var univListTableView: UITableView!
    
    var univBoards : [UnivBoard] = []
    var plusUnivBoards : [UnivBoard] = []
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var hiddenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hiddenView.hidden = true
        print("\(User.sharedInstance().univ)")
        initSetting()
        initUnivBoard()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hiddenView.hidden = true
        pageInt = 1
        initUnivBoard()
        initSetting()
    }

    
    func refresh(sender:AnyObject)
    {
        initUnivBoard()
        pageInt = 1
        print("refresh")
        self.refreshControl?.endRefreshing()
        // Code to refresh table view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.univBoards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = univListTableView.dequeueReusableCellWithIdentifier("univCell", forIndexPath: indexPath) as! UnivTableViewCell
        
        cell.contents.setTitle(self.univBoards[indexPath.row].contents, forState: .Normal)
        
        cell.likeNum.text = String(self.univBoards[indexPath.row].numberOfLike)
        
        cell.commentNum.text = String(self.univBoards[indexPath.row].numberOfComment)
        //cell.commentNum.text = "\(indexPath.row)"
        
        if univBoards[indexPath.row].islike == "0" {
            let image: UIImage = UIImage(named: "unlike")!
            cell.likeImage.setImage(image, forState: UIControlState.Normal)
        }
        else {
            let image: UIImage = UIImage(named: "like")!
            cell.likeImage.setImage(image, forState: UIControlState.Normal)
        }
        cell.likeImage.addTarget(self, action: "contentLikeFunc", forControlEvents: .TouchUpInside)
        if univBoards[indexPath.row].imgURL != "" {
            cell.backgroundImage.hidden = false
            cell.backgroundImage.downloadedFrom(link: univBoards[indexPath.row].imgURL, contentMode: .ScaleToFill)
        } else {
            cell.backgroundImage.hidden = true
        }
        
            if(univBoards[indexPath.row].keywordArray.count == 0){
                cell.keywordFirst.hidden = true
                cell.keywordSecond.hidden = true
                cell.keywordThird.hidden = true
                //                cell.keywordFirst.setTitle(" ", forState: .Normal)
                //                cell.keywordSecond.setTitle(" ", forState: .Normal)
                //                cell.keywordThird.setTitle(" ", forState: .Normal)
            }
            else if(univBoards[indexPath.row].keywordArray.count == 1){
                cell.keywordFirst.hidden = false
                cell.keywordFirst.setTitle("#"+self.univBoards[indexPath.row].keywordArray[0], forState: .Normal)
                cell.keywordSecond.hidden = true
                cell.keywordThird.hidden = true
                //                cell.keywordSecond.setTitle("", forState: .Normal)
                //                cell.keywordThird.setTitle("", forState: .Normal)
            }
            else if(univBoards[indexPath.row].keywordArray.count == 2){
                cell.keywordFirst.hidden = false
                cell.keywordSecond.hidden = false
                cell.keywordFirst.setTitle("#"+self.univBoards[indexPath.row].keywordArray[0], forState: .Normal)
                cell.keywordSecond.setTitle("#"+self.univBoards[indexPath.row].keywordArray[1], forState: .Normal)
                cell.keywordThird.hidden = true
            }
            else {
                cell.keywordFirst.hidden = false
                cell.keywordSecond.hidden = false
                cell.keywordThird.hidden = false
                cell.keywordFirst.setTitle("#"+self.univBoards[indexPath.row].keywordArray[0], forState: .Normal)
                cell.keywordSecond.setTitle("#"+self.univBoards[indexPath.row].keywordArray[1], forState: .Normal)
                cell.keywordThird.setTitle("#"+self.univBoards[indexPath.row].keywordArray[2], forState: .Normal)
            }
        
        //print(univBoards[indexPath.row].keywordArray.count)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        }
        
        if univBoards[indexPath.row].notice_yn == "Y" {
            cell.megaPhone.hidden = false
        }
        else {
            cell.megaPhone.hidden = true
        }
        return cell
    }
    
    
    func contentLikeFunc() {
        setLike()
        //        contentLikeNum.text = String(contentLikeNumTmp)
    }
    
    func setLike() {
        let point : CGPoint = univListTableView.convertPoint(CGPointZero, toView:univListTableView)
        let indexPath = univListTableView.indexPathForRowAtPoint(point)
        let code = univBoards[indexPath!.row].code
        
        let jsonParser = SimpleJsonParser()
        jsonParser.HTTPGetJson("http://ec2-52-68-50-114.ap-northeast-1.compute.amazonaws.com/bamboo/API/Bamboo_Set_Like.php?b_code=\(code)&uuid=\(User.sharedInstance().uuid)") {
            (data : Dictionary<String, AnyObject>, error : String?) -> Void in
            if error != nil {
                print("\(error) : PostBoardVC")
            } else {
                if let _ = data["state"] as? String,
                    let _ = data["message"] as? String
                {
                    print("succece:))")
                    //                    self.state = stateT
                    //                    print(self.state)
                    //                    if self.state == "1" {
                    //                        //                        print("yet")
                    //                        //                        self.contentLikeNumTmp = self.contentLikeNumTmp + 1
                    //                        //                        print(self.contentLikeNumTmp)
                    //                        //                        self.contentLikeNum.text = "\(self.contentLikeNumTmp)" ////
                    //                        //
                    //                    }
                    
                } else {
                    //print("User객체 SimpleJsonParser인스턴스 failed")
                }
            }
        }
    }

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("indexPath")
        print(indexPath.item)
        print(univBoards.count)
        print(pageInt)
        if indexPath.item > 4 {
            if univBoards.count == 20 *  pageInt {
            if indexPath.item == (univBoards.count-1) {
                print("new")
                pageInt = pageInt + 1
                print(pageInt)
                plusInitUnivBoard()
            }
            }
            
        }
    }

    var pageInt = 1
    
    func initSetting() {
        self.univListTableView.delegate = self
        self.univListTableView.dataSource = self
        self.btnBest.hidden = true
        self.btnNew.hidden = true
        btnBest.addTarget(self, action: "btnBestFunc", forControlEvents: .TouchUpInside)
        btnNew.addTarget(self, action: "btnNewFunc", forControlEvents: .TouchUpInside)
        btnWrite.addTarget(self, action: "btnWriteFunc", forControlEvents: .TouchUpInside)
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.univListTableView.addSubview(refreshControl)
        
    }
    
    func initUnivBoard() {
        BBActivityIndicatorView.show("로딩중입니다><")
        Alamofire
            .request(Router.GetList(type: "T03", page: "1", university: User.sharedInstance().univ, uuid: User.sharedInstance().uuid))
            .responseCollection { (response: Response<[UnivBoard], NSError>) in
                if response.result.isSuccess {
                    BBActivityIndicatorView.hide()
                    self.univBoards = response.result.value!
                    print(response)
                    print(response.result.value)
                    if self.univBoards.isEmpty {
                        self.hiddenView.hidden = false
                        self.univListTableView.hidden = true
                    }
                    else {
                        self.hiddenView.hidden = true
                        self.univListTableView.hidden = false
                    }

                }
                self.univListTableView.reloadData()
        }
    }
    
    func plusInitUnivBoard() {
        Alamofire
            .request(Router.GetList(type: "T03", page: "\(pageInt)", university: User.sharedInstance().univ, uuid: User.sharedInstance().uuid))
            .responseCollection { (response: Response<[UnivBoard], NSError>) in
                if response.result.isSuccess {
                    self.plusUnivBoards = response.result.value!
                    print(response)
                    print(response.result.value)
                    self.univBoards = self.univBoards + self.plusUnivBoards
                    
                }
                
                self.univListTableView.reloadData()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUnivDetail" {
            let DetailVC = segue.destinationViewController as! DetailViewController
            
            let point : CGPoint = sender!.convertPoint(CGPointZero, toView:univListTableView)
            let indexPath = univListTableView.indexPathForRowAtPoint(point)
            
            DetailVC.contentT = univBoards[indexPath!.row].contents
            DetailVC.keywords = univBoards[indexPath!.row].keywords
            DetailVC.contentlikeNumT = String(univBoards[indexPath!.row].numberOfLike)
            DetailVC.commentNumT = String(univBoards[indexPath!.row].numberOfComment)
            
            DetailVC.code = univBoards[indexPath!.row].code
            DetailVC.state = univBoards[indexPath!.row].islike

            print(DetailVC.code)
        }
        else if segue.identifier == "keywordUnivFirstSegue" {
            let KeywordVC = segue.destinationViewController as! KeywordViewController
            let point : CGPoint = sender!.convertPoint(CGPointZero, toView:univListTableView)
            let indexPath = univListTableView.indexPathForRowAtPoint(point)
            
            KeywordVC.titleName = univBoards[indexPath!.row].keywordArray[0]
        }
            
        else if segue.identifier == "keywordUnivSecondSegue" {
            let KeywordVC = segue.destinationViewController as! KeywordViewController
            let point : CGPoint = sender!.convertPoint(CGPointZero, toView:univListTableView)
            let indexPath = univListTableView.indexPathForRowAtPoint(point)
            
            KeywordVC.titleName = univBoards[indexPath!.row].keywordArray[1]
        }
        else if segue.identifier == "keywordUnivThirdSegue" {
            let KeywordVC = segue.destinationViewController as! KeywordViewController
            let point : CGPoint = sender!.convertPoint(CGPointZero, toView:univListTableView)
            let indexPath = univListTableView.indexPathForRowAtPoint(point)
            
            KeywordVC.titleName = univBoards[indexPath!.row].keywordArray[2]
        }
        else if segue.identifier == "univPost" {
            let PostBoardVC = segue.destinationViewController as! PostBoardViewController
            PostBoardVC.type = User.sharedInstance().univ
            
        }
        else if segue.identifier == "megaPhone" {
            let KeywordVC = segue.destinationViewController as! KeywordViewController
            KeywordVC.detailOrMega = 2
            KeywordVC.titleName = User.sharedInstance().univ
        }
        
        
    }
    
    
    @IBAction func cancelToListVC(segue : UIStoryboardSegue) {
        
    }
    @IBOutlet weak var btnWrite: UIButton!
    
    func btnWriteFunc() {
        self.btnBest.hidden = false
        self.btnNew.hidden = false
        let image  = UIImage(named: "btn_write_unselected")
        btnWrite.setImage(image, forState: .Normal)
    }
    
    @IBOutlet weak var btnBest: UIButton!
    
    
    
    func btnBestFunc() {
        print(123)
        self.btnBest.hidden = true
        self.btnNew.hidden = true
        let image  = UIImage(named: "btn_best_selected")
        let image2  = UIImage(named: "btn_new_unselected")
        btnWrite.setImage(image, forState: .Normal)
        btnBest.setImage(image, forState: .Normal)
        btnNew.setImage(image2, forState: .Normal)
    }
    
    @IBOutlet weak var btnNew: UIButton!
    
    func btnNewFunc() {
        self.btnBest.hidden = true
        self.btnNew.hidden = true
        let image  = UIImage(named: "btn_new_selected")
        let image2  = UIImage(named: "btn_best_unselected")
        btnWrite.setImage(image, forState: .Normal)
        btnNew.setImage(image, forState: .Normal)
        btnBest.setImage(image2, forState: .Normal)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
