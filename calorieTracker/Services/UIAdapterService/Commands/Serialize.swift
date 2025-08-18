class Serialize: baseWrapper{
    override func execute()-> Optional<Any>{
        let message: message = self.parameter as! message
        return self.service.serializeFoodEntry(foodEntry: message.payload as! FoodEntry, destination: message.meta["destination"]!, command: message.command)
    }
}
