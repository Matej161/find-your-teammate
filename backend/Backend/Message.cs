namespace Backend;

public class Message
{
    public Guid Id { get; set; }
    public Guid RoomId { get; set; }
    public string Content { get; set; }
    public DateTime TimeSent { get; set; }
    public Guid UserId { get; set; }

    public Message(Guid roomId, Guid id, string content, DateTime timeSent, Guid userId)
    {
        RoomId = roomId;
        Id = id;
        Content = content;
        TimeSent = timeSent;
        UserId = userId;
    }
}