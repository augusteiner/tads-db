
using System;
using System.Data.Common;

using MySql.Data.MySqlClient;

namespace tads.db.vendas.cli {

    public class Program {

        public static void Main(string[] args) {

            DbConnection connection = MySqlClientFactory.Instance.CreateConnection();

            connection.ConnectionString =
                "Server=127.0.0.1;Port=4040;Database=vendas_27_09_2016;Uid=vendas;Pwd=;";

            connection.Open();

            var cmd = connection.CreateCommand();

            cmd.CommandText = "SELECT * FROM produto";
            var reader = cmd.ExecuteReader();

            Console.WriteLine("-- Produtos cadastrados --");

            while (reader.Read()) {

                for (var i = 0; i < reader.FieldCount; i++) {

                    Console.WriteLine(
                        "\t{0}: {1}",

                        reader.GetName(i),
                        reader.GetValue(i));

                }

            }

        }

    }

}
