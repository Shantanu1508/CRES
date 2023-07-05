export class Message {
  constructor(
    public content: MsgSpeech,
    public sentBy: string,
    public messageID: string,
    public enableLoading: boolean
  ) { }
}

export class MsgSpeech {
  constructor(public Speech: string, public Type: string, public status: string, public intentName: string) { }
}
