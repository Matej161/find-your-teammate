namespace Backend;

public class GlobalChatIds
{
    public static readonly List<ChatRoom> DefaultRooms = new()
    {
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000001"), Name = "League of Legends Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000002"), Name = "Fortnite Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000003"), Name = "Minecraft Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000004"), Name = "Rocket League Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000005"), Name = "Valorant Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000006"), Name = "Counter Strike 2 Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000007"), Name = "Overwatch 2 Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true },
        new ChatRoom { Id = Guid.Parse("00000000-0000-0000-0000-000000000008"), Name = "Apex Legends Global Chat", MaxCapacity = Int32.MaxValue, IsStatic = true }
    };
}