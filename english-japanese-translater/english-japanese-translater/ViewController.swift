//
//  ViewController.swift
//  english-japanese-translater
//
//  Created by 佐藤和希 on 2016/08/14.
//  Copyright © 2016年 kaz. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

class ViewController: UIViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnDo: UIButton!
    @IBOutlet weak var switchEng_Jap: UISegmentedControl!
    @IBOutlet weak var pastSearchWordsTableView: UITableView!
    
    var safariView : SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        pastSearchWordsTableView.delegate = self
        pastSearchWordsTableView.dataSource = self
         pastSearchWordsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnDoTapped(sender: UIButton) {
        
        let searchWord = textField.text
        
        if(searchWord == ""){
            return
        }
        
        let optionWord = switchEng_Jap.selectedSegmentIndex == 0 ? "英語" : "意味"
        let urlStr = "https://www.google.co.jp/search?q=" + searchWord! + "+" + optionWord
        let escapeStr = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let openURL = NSURL(string:escapeStr)!
        self.safariView = SFSafariViewController(URL: openURL)
        presentViewController(safariView!, animated: true, completion: nil)
        
        textField.text = ""
        saveSearchWordToDB(searchWord!)
        
        pastSearchWordsTableView.reloadData()
    }
    
    
    func saveSearchWordToDB(searchWord : String){
        let realm = try! Realm()
        let pastSearchWord = PastSearchWords()
        
        pastSearchWord.word = searchWord
        pastSearchWord.date = NSDate()
        
        let pastSearchWords = realm.objects(PastSearchWords)
        pastSearchWord.id = pastSearchWords.count + 1
        
        try! realm.write() {
            realm.add(pastSearchWord)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let pastSearchWords = realm.objects(PastSearchWords)
 
        return pastSearchWords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let realm = try! Realm()
        let pastSearchWords = realm.objects(PastSearchWords)
        
        cell.textLabel?.text = pastSearchWords.reverse()[indexPath.row].word
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        textField.text = cell.textLabel?.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}