namespace Backend;

public interface IRepository<T> where T : class
{
    T Add(T entity);
    T[] GetAll();
    T GetById(Guid id);
    T Update(T entity);
    T Remove(Guid id);
}

