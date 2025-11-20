namespace Backend;

public interface IRepository<T>
{
    T GetById(Guid id);
    T[] GetAll();
    T Add(T entity);
    T Update(T entity);
    T Remove(Guid id);
}