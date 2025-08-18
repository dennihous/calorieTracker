import Foundation
class UIAdapterService: Service{
    
    override init(proxyEntry: any ServiceInputSub, proxyExit: any ServiceOutputPub){
        super.init(proxyEntry: proxyEntry, proxyExit: proxyExit)
        commands["serializeFE"] = Serialize(service: self)
        commands["deserializeFE"] = Deserialize(service: self)
    }
    
    private func parseFoodEntry(foodEntry: FoodEntry) -> Dictionary<String, Any>{
        var foodInfo = Dictionary(uniqueKeysWithValues:
        Mirror(reflecting:foodEntry).children.map{(String(reflecting: $0.label), 
        $0.value)})
        return [foodEntry.id.uuidString:foodInfo]
    }
    func serializeFoodEntry(foodEntry: FoodEntry, destination: String, command: String)->message{
        let builder = self.builder
        let payload = self.parseFoodEntry(foodEntry: foodEntry)
        var meta: Dictionary<String, String> = [:]
        meta["destination"] = destination
        builder.reset()
        builder.setPayload(payload)
        builder.setCommand(command)
        builder.setMeta(meta)
        return builder.build()
    }
    func deserializeFEMessage(_ message: message)->FoodEntry?{
        let entryDetails = message.payload as! Dictionary<String, Any>
        return FoodEntry(date: entryDetails["date"] as! Date, name: entryDetails["name"] as! String, calories: entryDetails["calories"] as! Int, meal: entryDetails["meal"] as! MealType)
    }
    override func invokeCommand(){
        let command = self.proxy.Entry.message!.command
        if self.commands.keys.contains(command){
            let commandInstance = self.commands[command]!
            let param = self.proxy.Entry.message!
            commandInstance.setParameter(parameter: param)
            self.proxy.relayOut(message: commandInstance.execute() as!
            message)
        }
    }
}
