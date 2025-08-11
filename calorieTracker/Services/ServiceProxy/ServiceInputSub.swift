protocol ServiceInputSub{
  var message: message {get set}
  func recieveMessage(message: message)->Void
}
