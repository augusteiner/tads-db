
-- 1. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoEnd.

SELECT Cod_TipoEnd, Nome_TipoEnd

FROM TipoEnd;

-- 2. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoProd.

SELECT Cod_TipoProd, Nome_TipoProd

FROM TipoProd;

-- 3. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoCli.

SELECT Cod_TipoCli, Nome_TipoCli

FROM TipoCli;

-- 4. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela Estado.

SELECT Sigla_Est, Nome_Est

FROM Estado;

-- 5. Escreva um comando que exiba a sigla do estado e o nome das cidades que você possui em cada estado no seu sistema.

SELECT Sigla_Est, Nome_Cid

FROM Cidade;

-- 6. Escreva um comando que exiba o nome dos clientes do seu cadastro de clientes,
--    a data de cadastro desse cliente no sistema e o valor da renda que cada cliente possui.

SELECT Nome_Cli, Data_CadCli, Renda_Cli

FROM Cliente;

-- 7. Escreva um comando que exiba o nome de todos os funcionários do seu cadastro de funcionários,
--    a data de nascimento, o sexo e o salário de um dos funcionários do seu sistema.

SELECT Nome_Func, Data_CadFunc, Sexo_Func, Sal_Func

FROM Funcionario;

-- 8. Escreva um comando que exiba todos os dados da tabela Histórico do funcionário de código 1.

SELECT *

FROM Historico

WHERE Cod_Func = 1;

-- 9. Escreva um comando que exiba o nome, o tipo, a quantidade e o valor unitário dos produtos em estoque.

SELECT Nome_Prod, Qtd_EstqProd, Val_UnitProd

FROM Produto;

-- 10. Escreva um comando que exiba o nome do cliente, o valor da sua renda e apresente também
--     essa mesma renda com um acréscimo de 10%, para todos os clientes do seu database.

SELECT Nome_Cli, Renda_Cli, Renda_Cli * 1.1 AS Renda_Acresc

FROM Cliente;

-- 11. Escreva um comando que exiba o nome do cliente, o valor da sua renda e apresente também
--     essa mesma renda com um acréscimo de 10%, apenas para os clientes com renda inferior a 1000.00.

SELECT Nome_Cli, Renda_Cli, Renda_Cli * 1.1 AS Renda_Acresc

FROM Cliente

WHERE Renda_Cli < 1000.00;

-- 12. Escreva um comando que aplique 20% de aumento salarial para todos os funcionários do sexo feminino
--     e que ganhem um salário inferior a 1000.00.

UPDATE Funcionario

SET Sal_Func = Sal_Func * 1.2

WHERE Sal_Func < 1000.00
  AND Sexo_Func = 'F';

-- 13. Escreva um comando que aplique um aumento de 10% ao valor dos produtos do tipo 1.

UPDATE Produto

SET Val_UnitProd = Val_UnitProd * 1.1

WHERE Cod_Prod = 1;

-- 14. Escreva um comando que aplique um aumento de 5% ao valor dos produtos do tipo 2.

UPDATE Produto

SET Val_UnitProd = Val_UnitProd * 1.05

WHERE Cod_Prod = 2;

-- 15. Escreva um comando que aplique uma redução de 20% ao valor dos produtos do tipo 3.

UPDATE Produto

SET Val_UnitProd = Val_UnitProd * 0.80

WHERE Cod_Prod = 3;

-- 16. Escreva um comando que elimina todos os itens vendidos no pedido 10.

DELETE FROM Itens

WHERE Num_Ped = 10;

-- 17. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoEnd.

SELECT *

FROM TipoEnd;

-- 18. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoProd.

SELECT *

FROM TipoProd;

-- 19. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoCli.

SELECT *

FROM TipoCli;

-- 20. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela Estado.

SELECT *

FROM Estado;

-- 21. Escreva um comando que exiba a sigla do estado e o nome das cidades que você possui em cada estado no seu sistema.

SELECT Sigla_Est, Nome_Cid

FROM Cidade;

-- 22. Escreva um comando que exiba o nome dos clientes do seu cadastro de clientes,
--     a data de cadastro desse cliente no sistema e o valor da renda que cada cliente possui.

-- 23. Escreva um comando que exiba o nome de todos os funcionários do seu cadastro de funcionários,
--     a data de nascimento, o sexo e o salário de um dos funcionários do seu sistema.

-- 24. Escreva um comando que exiba todos os dados da tabela Histórico do funcionário de código 1.

-- 25. Escreva um comando que exiba o nome, o tipo, a quantidade e o valor unitário dos produtos em estoque.

-- 26. Escreva um comando que exiba o nome do cliente, o valor da sua renda e apresente também
--     essa mesma renda com um acréscimo de 10%, para todos os clientes do seu database.

-- 27. Escreva um comando que exiba o nome do cliente, o valor da sua renda e apresente também
--     essa mesma renda com um acréscimo de 10%, apenas para os clientes com renda inferior a 1000.00.

-- 28. Escreva um comando que aplique 20% de aumento salarial para todos os funcionários
--     do sexo feminino e que ganhem um salário inferior a 1000.00.

-- 29. Escreva um comando que aplique um aumento de 10% ao valor dos produtos do tipo 1.

-- 30. Escreva um comando que aplique um aumento de 5% ao valor dos produtos do tipo 2.

-- 31. Escreva um comando que aplique uma redução de 20% ao valor dos produtos do tipo 3.

-- 32. Escreva um comando que elimina todos os itens vendidos no pedido 10.

DELETE

FROM Itens

WHERE Num_Ped = 10;

-- 33. Escreva um comando que exiba todas as colunas e todas as linhas de dados da tabela TipoEnd,
--     ordenando os dados de forma crescente pela coluna Nome_Tipo.

SELECT *

FROM TipoEnd

ORDER BY Nome_TipoEnd ASC;

-- 34. Escreva um comando que apresente os dados dos clientes ordenados de forma decrescente pela coluna Nome_Cli.

SELECT *

FROM Cliente

ORDER BY Nome_Cli DESC;