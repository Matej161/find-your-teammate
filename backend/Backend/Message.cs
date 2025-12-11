namespace Backend;

public class Message
{
    public Guid Id { get; set; }
    public string Content { get; set; }
    public DateTime TimeSent { get; set; }
    public Guid UserId { get; set; }
}