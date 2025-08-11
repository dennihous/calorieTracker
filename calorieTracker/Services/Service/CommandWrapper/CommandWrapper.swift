class CommandWrapper{
  init(parameter: Optional<Any>){
    self.parameter = parameter
  }
  var parameter: Optional<Any>
  func execute()->Optional<Any>{}
  func setParameter(parameter: Optional<Any>){
    self.parameter = parameter
  }
}
