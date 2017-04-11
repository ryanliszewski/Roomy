//
//  MessagingViewController.swift
//  roomy
//
//  Created by Poojan Dave on 4/7/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
import Parse
import JSQMessagesViewController

// Change the subclass from UIViewController to JSQMessagesViewController
class MessagingViewController: JSQMessagesViewController {
    
    /*
        Initialization for the properties
     */
    
    // array of JSQMessage and instantiating it
    var messages = [JSQMessage]()
    
    // Sets the bubbles
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()

    
    /*
        viewDidLoad and viewDidAppear
     */
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bringing up the keyboard for the textField
        inputToolbar.contentView.textView.becomeFirstResponder()
        
        // removing the avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Setting the senderId to the currentUser id so that we can differentiate between incoming and outgoing messages
        self.senderId = Roomy.current()?.objectId
        self.senderDisplayName = Roomy.current()?.username
        
        // Retrieving the messages from Parse
        loadMessages()
        
    }
    
    
    /*
        Collection View Methods
    */
    
    // messageDataForItemAt: returns the appropriate message based upon the row
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    // messageBubbleImageDataForItemAt: determining the type of bubble (incoming or outgoing)
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    // avatarImageDataForItemat: returns the avatar
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // numberOfItemsInSection: Total cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // cellForItemAt:
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // creating a cell and casting it as a JSQMessagesCollectionViewCell
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    // Sets the outoing and incoming bubbles
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }

    
    /*
        Sending/Creating the message
     */
    
    // Action: When the send button is pressed
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        sendMessage(text: text, video: nil, picture: nil)
    }
    
    // method to send the message to Parse
    private func sendMessage(text: String, video: URL?, picture: UIImage?) {
        
        // creates the messageObject
        if PFUser.current() != nil {
            let messageObject = Message()
            messageObject.roomy = Roomy.current()
            messageObject.senderName = Roomy.current()?.username
            messageObject.text = text
            
            messageObject.saveInBackground { succeeded, error in
                if succeeded {
                    
                    // ?????
                    self.finishSendingMessage()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    
    /*
        Retrieving the messages
     */
    
    // retrieve messages from Parse
    private func loadMessages() {
        
        // create query
        let query = PFQuery(className: "Message")
        query.order(byDescending: "_created_at")
        query.limit = 50
        
        query.findObjectsInBackground { pfMessages, error in
            if let pfMessages = pfMessages {
                self.add(pfMessages: pfMessages as! [Message])
            } else {
                print("Error")
            }
        }
    }
    
    // add the messages to the collection view
    private func add(pfMessages: [Message]) {
        
        // NOTE: mfMessage["roomy"] does not exist right now. ~Dustyn 4/10 8:36pm
        func add(pfMessage: Message) {
            
            if let pfUserObject = pfMessage.roomy as? Roomy {
                
                // TODO: using pfMessage senderName, not pfUserObject.username
                if let authorID = pfUserObject.objectId,
                    let authorFullName = pfMessage.senderName {
                    
                    print(authorFullName)
                    print(authorID)
                    
                    let jsqMessage: JSQMessage? = {

                        if let text = pfMessage["text"] as? String {
                            return JSQMessage(senderId: authorID, senderDisplayName: authorFullName, date: pfMessage.createdAt, text: text)
                        } else {
                            return nil
                        }
                    }()
                        
                    if let jsqMessage = jsqMessage {
                        self.messages.append(jsqMessage)
                    }
                        
                    self.collectionView.reloadData()
                }
            }
        }
        
        for pfMessage in pfMessages {
            print("pfMesssage: ")
            print(pfMessage)
            print()
            add(pfMessage: pfMessage)
        }
        
        // ??????
        if pfMessages.count >= 1 {
            self.scrollToBottom(animated: false)
            self.finishReceivingMessage()
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
