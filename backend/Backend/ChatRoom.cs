namespace Backend;

public class ChatRoom
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public int MaxCapacity { get; set; } // Maximální počet uživatelů
    public bool IsStatic { get; set; }
}