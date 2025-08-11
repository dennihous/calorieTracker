class ServiceProxy{
  var Entry : ServiceInputSub
  var Exit : ServiceOutputPub
  init(Entry: ServiceInputSub, Exit: ServiceOutputPub) {
    self.Entry = Entry
    self.Exit = Exit
  }
  func relayIn(message: message)->message{
    self.Entry.recieveMessage(message:message)
    return self.Entry.message
  }
  func relayOut(message: message){
    self.Exit.setOutput(output: message)
    self.Exit.publish()
  }
}
