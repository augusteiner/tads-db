
-- 1. Escreva um comando que apresente quantos clientes são casados e quantos clientes são solteiros

SELECT
  'Qte. de clientes casados' AS Descricao, COUNT(Cliente.Cod_Cli) AS Quantidade

FROM Cliente

INNER JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli

UNION

SELECT
  'Qte. de clientes solteiros' AS Descricao, COUNT(Cliente.Cod_Cli) AS Quantidade

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli

WHERE Conjuge.Cod_Cli IS NULL

;

-- 2. Escreve um comando que exiba quantos e-mails cada cliente tem

SELECT Cliente.Cod_Cli, COUNT(EMail.Cod_Cli) AS Qte_Emails

FROM Cliente

LEFT JOIN EMail
ON EMail.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 3. Escreva um comando que exiba quantos clientes você tem de cada tipo

SELECT TipoCli.Cod_TipoCli, COUNT(Cliente.Cod_Cli) AS Qte_Clientes

FROM Cliente

INNER JOIN TipoCli
ON TipoCli.Cod_TipoCli = Cliente.Cod_TipoCli

GROUP BY TipoCli.Cod_TipoCli;

-- 4. Escreva um comando que exiba a quantidade de parcelas de que é composto cada pedido

SELECT Pedido.Num_Ped, COUNT(Parcela.Num_Par) AS Qte_Parcelas

FROM Pedido

LEFT JOIN Parcela
ON Parcela.Num_Ped = Pedido.Num_Ped

GROUP BY Pedido.Num_Ped;

-- 5. Escreva um comando que exiba a quantidade de dependentes que cada funcionário tem

SELECT Funcionario.Cod_Func, COUNT(Dependente.Cod_Dep) AS Qte_Dependentes

FROM Funcionario

LEFT JOIN Dependente
ON Dependente.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 6. Escreva um comando que mostre quantos produtos você tem de cada tipo

SELECT TipoProd.Cod_TipoProd, COUNT(Produto.Cod_Prod) AS Qte_Produtos

FROM TipoProd

LEFT JOIN Produto
ON Produto.Cod_TipoProd = TipoProd.Cod_TipoProd

GROUP BY TipoProd.Cod_TipoProd;

-- 7. Escreva um comando que mostre o quanto cada cliente gastou em pedidos

SELECT Cliente.Cod_Cli, SUM(Pedido.Val_Ped) AS Val_Gasto_Pedidos

FROM Cliente

LEFT JOIN Pedido
ON Pedido.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 8. Escreva um comando que mostre quantos clientes você tem em cada cidade

SELECT Cidade.Cod_Cid, COUNT(Cliente.Cod_Cli) AS Qte_Clientes

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

LEFT JOIN Cidade
ON Cidade.Cod_Cid = Endereco.Cod_Cid

GROUP BY Cidade.Sigla_Est, Cidade.Cod_Cid;

-- 9. Escreva um comando que mostre quantas cidades você tem em cada estado

SELECT Estado.Sigla_Est, COUNT(Cidade.Cod_Cid) AS Qte_Cidades

FROM Estado

LEFT JOIN Cidade
ON Cidade.Sigla_Est = Estado.Sigla_Est

GROUP BY Estado.Sigla_Est;

-- 10. Escreva um comando que exiba o total de bônus que cada funcionário recebeu

SELECT Funcionario.Cod_Func, SUM(Bonus.Val_Bonus) AS Total_Bonus

FROM Funcionario

LEFT JOIN Bonus
ON Bonus.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 11. Escreva um comando que mostre o total de salários pagos para os
--     funcionários do sexo masculino e para os do sexo feminino

SELECT Funcionario.Sexo_Func, SUM(Funcionario.Sal_Func) AS Salario_Sexo

FROM Funcionario

GROUP BY Funcionario.Sexo_Func;

-- 12. Escreva um comando que mostre quantos pedidos você tem de cada status

SELECT StatusPedido.Cod_Sta, COUNT(Pedido.Cod_Sta) AS Qte_Pedidos

FROM Pedido

LEFT JOIN StatusPedido
ON StatusPedido.Cod_Sta = Pedido.Cod_Sta

GROUP BY StatusPedido.Cod_Sta;

-- 13. Escreva um comando que exiba a quantidade de endereços que cada cliente tem

SELECT Cliente.Cod_Cli, COUNT(Endereco.Cod_End) Qte_Enderecos

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 14. Escreva um comando que exiba o total de pontos que cada funcionário fez por mês

SELECT Funcionario.Cod_Func, MONTH(Pontuacao.Data_Pto) AS Mes, SUM(Pontuacao.Pto_Func) AS Total_Pontos

FROM Funcionario

LEFT JOIN Pontuacao
ON Pontuacao.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func, MONTH(Pontuacao.Data_Pto);

-- 15. Escreva um comando que mostre quantos pedidos cada funcionário atendeu

SELECT Funcionario.Cod_Func, COUNT(Pedido.Cod_Func) AS Qte_Pedidos_Atendidos

FROM Funcionario

LEFT JOIN Pedido
ON Pedido.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 16. Escreva um comando que mostre quantos pedidos de cada cliente cada funcionário atendeu

SELECT Funcionario.Cod_Func, Cliente.Cod_Cli, COUNT(Pedido.Cod_Func) AS Qte_Pedidos_Atendidos

FROM Funcionario

LEFT JOIN Pedido
ON Pedido.Cod_Func = Funcionario.Cod_Func

LEFT JOIN Cliente
ON Cliente.Cod_Cli = Pedido.Cod_Cli

GROUP BY Funcionario.Cod_Func, Cliente.Cod_Cli;

-- 17. Escreva um comando que exiba quantos endereços cada cliente tem de cada tipo

SELECT Cliente.Cod_Cli, TipoEnd.Cod_TipoEnd, COUNT(TipoEnd.Cod_TipoEnd) AS Qte_Enderecos_Do_Tipo

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

LEFT JOIN TipoEnd
ON TipoEnd.Cod_TipoEnd = Endereco.Cod_TipoEnd

GROUP BY Cliente.Cod_Cli, TipoEnd.Cod_TipoEnd

ORDER BY Cliente.Cod_Cli, TipoEnd.Cod_TipoEnd;

-- 18. Escreva um comando que mostre o total de salários pagos aos funcionários

SELECT SUM(Funcionario.Sal_Func) AS Total_Salarios

FROM Funcionario;

-- 19. Escreva um comando que apresente quantos clientes você tem de cada estado civil,
--     apresentando o nome completo de cada estado civil

SELECT
  'Qte. de clientes casados' AS Descricao, 'Casado(a)' AS Status, COUNT(Cliente.Cod_Cli) AS Quantidade

FROM Cliente

INNER JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli

UNION

SELECT
  'Qte. de clientes solteiros' AS Descricao, 'Solteiro(a)' AS Status, COUNT(Cliente.Cod_Cli) AS Quantidade

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli

WHERE Conjuge.Cod_Cli IS NULL

;

-- 20. Escreve um comando que exiba quantos e-mails cada cliente tem,
--     apresentando o nome de cada cliente

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(EMail.Cod_Cli) AS Qte_EMails

FROM Cliente

LEFT JOIN EMail
ON EMail.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli, Cliente.Nome_Cli;

-- 21. Escreva um comando que exiba quantos clientes você tem de cada tipo,
--     apresentando o nome de cada tipo

SELECT TipoCli.Cod_TipoCli, TipoCli.Nome_TipoCli, COUNT(Cliente.Cod_Cli) AS Qte_Clientes_do_Tipo

FROM TipoCli

LEFT JOIN Cliente
ON Cliente.Cod_TipoCli = TipoCli.Cod_TipoCli

GROUP BY TipoCli.Cod_TipoCli, TipoCli.Nome_TipoCli;

-- 22. Escreva um comando que exiba a quantidade de parcelas que compõem cada pedido,
--     exibindo todos os dados dos pedidos

SELECT Pedido.Num_Ped, Pedido.Cod_Cli, Pedido.Cod_Func, Pedido.Cod_Sta, Pedido.Data_Ped, Pedido.Val_Ped,
       COUNT(Parcela.Num_Ped) AS Qte_Parcelas

FROM Pedido

LEFT JOIN Parcela
ON Parcela.Num_Ped = Pedido.Num_Ped

GROUP BY Pedido.Num_Ped, Pedido.Cod_Cli, Pedido.Cod_Func, Pedido.Cod_Sta, Pedido.Data_Ped, Pedido.Val_Ped;

-- 23. Escreva um comando que exiba a quantidade de dependentes que cada funcionário tem,
--     mostrando o nome de cada funcionário

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, COUNT(Dependente.Cod_Func) AS Qte_Dependentes

FROM Funcionario

LEFT JOIN Dependente
ON Dependente.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func, Funcionario.Nome_Func;

-- 24. Escreva um comando que mostre quantos produtos você tem de cada tipo,
--     mostrando o nome do tipo

SELECT TipoProd.Cod_TipoProd, TipoProd.Nome_TipoProd, COUNT(Produto.Cod_Prod) AS Qte_Produtos_do_Tipo

FROM TipoProd

LEFT JOIN Produto
ON Produto.Cod_TipoProd = TipoProd.Cod_TipoProd

GROUP BY TipoProd.Cod_TipoProd, TipoProd.Nome_TipoProd;

-- 25. Escreva um comando que mostre o quanto cada cliente gastou em pedidos,
--     mostrando o nome do cliente

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, SUM(Val_Ped) AS Gasto_em_Pedidos

FROM Cliente

LEFT JOIN Pedido
ON Pedido.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli, Cliente.Nome_Cli;

-- 26. Escreva um comando que mostre quantos clientes você tem em cada cidade,
--     mostrando o nome de cada cidade

SELECT Cidade.Sigla_Est, Cidade.Nome_Cid, COUNT(Endereco.Cod_Cli) AS Qte_Clientes_na_Cidade

FROM Cidade

LEFT JOIN Endereco
ON Endereco.Cod_Cid = Cidade.Cod_Cid

GROUP BY Cidade.Sigla_Est, Cidade.Nome_Cid;

-- 27. Escreva um comando que mostre quantas cidades você tem em cada estado,
--     mostrando o nome do estado

SELECT Estado.Nome_Est, COUNT(Cidade.Cod_Cid) AS Qte_Cidades

FROM Estado

LEFT JOIN Cidade
ON Cidade.Sigla_Est = Estado.Sigla_Est

GROUP BY Estado.Nome_Est;

-- 28. Escreva um comando que exiba o total de bônus que cada funcionário recebeu,
--     mostrando o nome de cada funcionário

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, SUM(Bonus.Val_Bonus) AS Total_de_Bonus

FROM Funcionario

LEFT JOIN Bonus
ON Funcionario.Cod_Func = Bonus.Cod_Func

GROUP BY Funcionario.Cod_Func, Funcionario.Nome_Func;

-- 29. Escreva um comando que exiba a quantidade de endereços que cada cliente tem,
--     mostrando o nome de cada cliente

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(Endereco.Cod_End) AS Qte_Enderecos

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli, Cliente.Nome_Cli;

-- 30. Escreva um comando que exiba o total de pontos que cada funcionário fez por mês,
--     mostrando o nome do funcionário

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, MONTH(Pontuacao.Data_Pto) AS Mes,
       SUM(Pto_Func) AS Total_de_Pontos_no_Mes

FROM Funcionario

LEFT JOIN Pontuacao
ON Pontuacao.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func, Funcionario.Nome_Func, MONTH(Pontuacao.Data_Pto);
