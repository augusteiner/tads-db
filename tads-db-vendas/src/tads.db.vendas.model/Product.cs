
using tads.db.vendas.common;

namespace tads.db.vendas.model
{
    public class Product : IProduct
    {
        public int Id { get; set; }

        public string Description { get; set; }

        public decimal Price { get; set; }
    }
}
