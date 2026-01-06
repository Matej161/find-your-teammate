namespace Backend;

public class SqliteRepository<T> : IRepository<T> where T : class, new()
{
    public T Add(T entity)
    {
        Database.Insert(entity);
        return entity;
    }

    public T[] GetAll() => Database.GetAll<T>().ToArray();

    public T GetById(Guid id) => Database.GetById<T>(id);

    public T Update(T entity)
    {
        Database.Update(entity);
        return entity;
    }

    public T Remove(Guid id)
    {
        var entity = GetById(id);
        if (entity != null) Database.Delete<T>(id);
        return entity;
    }
}