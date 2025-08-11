class Service{
  let proxy: ServiceProxy
  var commands: Dictionary<String, CommandWrapper>
  let builder: MessageBuilder
  init(proxyEntry: ServiceInputSub, proxyExit: ServiceOutputPub){
    self.proxy = ServiceProxy(Entry: proxyEntry, Exit: proxyExit)
    self.commands = [:]
    self.builder = MessageBuilder()
  }
  func createCommand()->Void{}
  func invokeCommand()->Void{}
}
