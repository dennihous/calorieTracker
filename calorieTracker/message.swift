struct message{
  var command: String
  var payload: Optional<Any>
  var meta: Dictionary<String, String> = ["destination": "", "status":"", "":""]
}
