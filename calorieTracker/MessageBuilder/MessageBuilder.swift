class MessageBuilder{
  var command: Optional<String>
  var payload: Optional<Any>
  var meta: Optional<Dictionary<String, String>>

  init(){}

  func setCommand ( command: String) {
    self.command = command
  }
  func setPayload { payload: Any ) {
    self.payload = payload
  }
  func setMeta( meta: Dictionary<String, String>) {
    self.meta = meta
  }

  func reset(){
    self.command = nil
    self.payload = nil
    self.status = nil
  }

  func build()->message{
    return message(command: self.command, payload: self.payload, meta: self.meta)
  }
}
