
namespace tads.db.vendas.common
{
    public interface IProduct : IIdentifiable
    {
        string Description { get; set; }
        decimal Price { get; set; }
    }
}
