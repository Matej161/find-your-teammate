namespace Backend;

public class ChatMessage
{
    public Guid Id { get; set; }
    public Guid SenderId { get; set; }
    public Guid RoomId { get; set; }
    public string Content { get; set; }
    public DateTime Timestamp { get; set; }
}