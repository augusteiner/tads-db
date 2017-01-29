
-- 1. Escreva um comando que apresente quantos clientes são casados e quantos clientes são solteiros

SELECT
  SUM(Conjuge.Cod_Cli IS NOT NULL) Qte_Clientes_Casados,
  SUM(Conjuge.Cod_Cli IS NULL) Qte_Clientes_Solteiros,
  SUM(Cliente.Cod_Cli > 0) Qte_Clientes_Total

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli;

-- 2. Escreve um comando que exiba quantos e-mails cada cliente tem

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(EMail.Cod_Cli) Qte_Emails

FROM Cliente

LEFT JOIN EMail
ON EMail.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 3. Escreva um comando que exiba quantos clientes você tem de cada tipo

SELECT COUNT(Cliente.Cod_Cli) Qte_Clientes, TipoCli.Cod_TipoCli, TipoCli.Nome_TipoCli

FROM Cliente

INNER JOIN TipoCli
ON TipoCli.Cod_TipoCli = Cliente.Cod_TipoCli

GROUP BY TipoCli.Cod_TipoCli;

-- 4. Escreva um comando que exiba a quantidade de parcelas de que é composto cada pedido

SELECT Pedido.Num_Ped, Pedido.Val_Ped, Pedido.Data_Ped, COUNT(Parcela.Num_Par) Qte_Parcelas

FROM Pedido

LEFT JOIN Parcela
ON Parcela.Num_Ped = Pedido.Num_Ped

GROUP BY Pedido.Num_Ped;

-- 5. Escreva um comando que exiba a quantidade de dependentes que cada funcionário tem

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, COUNT(Dependente.Cod_Dep) Qte_Dependentes

FROM Funcionario

LEFT JOIN Dependente
ON Dependente.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 6. Escreva um comando que mostre quantos produtos você tem de cada tipo

SELECT TipoProd.Cod_TipoProd, TipoProd.Nome_TipoProd, COUNT(Produto.Cod_Prod) Qte_Produtos

FROM TipoProd

LEFT JOIN Produto
ON Produto.Cod_TipoProd = TipoProd.Cod_TipoProd

GROUP BY TipoProd.Cod_TipoProd;

-- 7. Escreva um comando que mostre o quanto cada cliente gastou em pedidos

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, SUM(Pedido.Val_Ped) Val_Gasto_Pedidos

FROM Cliente

LEFT JOIN Pedido
ON Pedido.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 8. Escreva um comando que mostre quantos clientes você tem em cada cidade

SELECT Cidade.Cod_Cid, Cidade.Nome_Cid, COUNT(Cliente.Cod_Cli) Qte_Clientes

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

LEFT JOIN Cidade
ON Cidade.Cod_Cid = Endereco.Cod_Cid

GROUP BY Endereco.Cod_Cid;

-- 9. Escreva um comando que mostre quantas cidades você tem em cada estado

SELECT Estado.Sigla_Est, Estado.Nome_Est, COUNT(Cidade.Cod_Cid) Qte_Cidades

FROM Estado

LEFT JOIN Cidade
ON Cidade.Sigla_Est = Estado.Sigla_Est

GROUP BY Estado.Sigla_Est;

-- 10. Escreva um comando que exiba o total de bônus que cada funcionário recebeu

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, SUM(Bonus.Val_Bonus) Total_Bonus

FROM Funcionario

LEFT JOIN Bonus
ON Bonus.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 11. Escreva um comando que mostre o total de salários pagos para os
--     funcionários do sexo masculino e para os do sexo feminino

SELECT Funcionario.Sexo_Func, SUM(Funcionario.Sal_Func) Salario_Sexo

FROM Funcionario

GROUP BY Funcionario.Sexo_Func;

-- 12. Escreva um comando que mostre quantos pedidos você tem de cada status

SELECT StatusPedido.Cod_Sta, StatusPedido.Sta_Ped, COUNT(Pedido.Cod_Sta) Qte_Pedidos

FROM Pedido

LEFT JOIN StatusPedido
ON StatusPedido.Cod_Sta = Pedido.Cod_Sta

GROUP BY Pedido.Cod_Sta;

-- 13. Escreva um comando que exiba a quantidade de endereços que cada cliente tem

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(Endereco.Cod_End) Qte_Enderecos

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 14. Escreva um comando que exiba o total de pontos que cada funcionário fez por mês

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, MONTH(Pontuacao.Data_Pto) Mes_Pontuacao, SUM(Pontuacao.Pto_Func) Total_Pontos

FROM Funcionario

LEFT JOIN Pontuacao
ON Pontuacao.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func, MONTH(Pontuacao.Data_Pto);

-- 15. Escreva um comando que mostre quantos pedidos cada funcionário atendeu

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, COUNT(Pedido.Cod_Func) Qte_Pedidos_Atendidos

FROM Funcionario

LEFT JOIN Pedido
ON Pedido.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 16. Escreva um comando que mostre quantos pedidos de cada cliente cada funcionário atendeu

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(Pedido.Cod_Func) Qte_Pedidos_Atendidos

FROM Funcionario

LEFT JOIN Pedido
ON Pedido.Cod_Func = Funcionario.Cod_Func

LEFT JOIN Cliente
ON Cliente.Cod_Cli = Pedido.Cod_Cli

GROUP BY Funcionario.Cod_Func, Pedido.Cod_Cli;

-- 17. Escreva um comando que exiba quantos endereços cada cliente tem de cada tipo

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, TipoEnd.Cod_TipoEnd, TipoEnd.Nome_TipoEnd, COUNT(TipoEnd.Cod_TipoEnd) Qte_Enderecos_Do_Tipo

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

LEFT JOIN TipoEnd
ON TipoEnd.Cod_TipoEnd = Endereco.Cod_TipoEnd

GROUP BY Cliente.Cod_Cli, TipoEnd.Cod_TipoEnd

ORDER BY Cliente.Nome_Cli, TipoEnd.Nome_TipoEnd;

-- 18. Escreva um comando que mostre o total de salários pagos aos funcionários

SELECT SUM(Funcionario.Sal_Func) Total_Salarios

FROM Funcionario;

-- 19. Escreva um comando que apresente quantos clientes você tem de cada estado civil,
--     apresentando o nome completo de cada estado civil

SELECT
  COUNT(Cliente.Cod_Cli) Qte_Clientes,
  CASE Conjuge.Cod_Cli IS NULL WHEN TRUE THEN 'Solteiro' ELSE 'Casado' END Estado_Civil

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli

GROUP BY Estado_Civil;

-- 20. Escreve um comando que exiba quantos e-mails cada cliente tem, apresentando o nome de cada cliente

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, COUNT(EMail.Cod_Cli) Qte_EMails

FROM Cliente

LEFT JOIN EMail
ON EMail.Cod_Cli = Cliente.Cod_Cli

GROUP BY EMail.Cod_Cli;

-- 21. Escreva um comando que exiba quantos clientes você tem de cada tipo, apresentando o nome de cada tipo

SELECT TipoCli.Cod_TipoCli, TipoCli.Nome_TipoCli, COUNT(Cliente.Cod_Cli) Qte_Clientes_do_Tipo

FROM TipoCli

LEFT JOIN Cliente
ON Cliente.Cod_TipoCli = TipoCli.Cod_TipoCli

GROUP BY TipoCli.Cod_TipoCli;

-- 22. Escreva um comando que exiba a quantidade de parcelas que compõem cada pedido,
--     exibindo todos os dados dos pedidos

SELECT Pedido.*, COUNT(Parcela.Num_Ped) Qte_Parcelas

FROM Pedido

LEFT JOIN Parcela
ON Parcela.Num_Ped = Pedido.Num_Ped

GROUP BY Pedido.Num_Ped;

-- 23. Escreva um comando que exiba a quantidade de dependentes que cada funcionário tem,
--     mostrando o nome de cada funcionário

SELECT Funcionario.Cod_Func, Funcionario.Nome_Func, COUNT(Dependente.Cod_Func) Qte_Dependentes

FROM Funcionario

LEFT JOIN Dependente
ON Dependente.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 24. Escreva um comando que mostre quantos produtos você tem de cada tipo, mostrando o nome do tipo

SELECT TipoProd.Cod_TipoProd, TipoProd.Nome_TipoProd, COUNT(Produto.Cod_Prod) Qte_Produtos_do_Tipo

FROM TipoProd

LEFT JOIN Produto
ON Produto.Cod_TipoProd = TipoProd.Cod_TipoProd

GROUP BY TipoProd.Cod_TipoProd;

-- 25. Escreva um comando que mostre o quanto cada cliente gastou em pedidos, mostrando o nome do cliente

SELECT Cliente.Cod_Cli, Cliente.Nome_Cli, SUM(Val_Ped) Gasto_em_Pedidos

FROM Cliente

LEFT JOIN Pedido
ON Pedido.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 26. Escreva um comando que mostre quantos clientes você tem em cada cidade, mostrando o nome de cada cidade

SELECT Cidade.*, COUNT(Endereco.Cod_Cli) Qte_Clientes_na_Cidade

FROM Cidade

LEFT JOIN Endereco
ON Endereco.Cod_Cid = Cidade.Cod_Cid

GROUP BY Cidade.Cod_Cid;

-- 27. Escreva um comando que mostre quantas cidades você tem em cada estado, mostrando o nome do estado

SELECT Estado.*, COUNT(Cidade.Cod_Cid) Qte_Cidades

FROM Estado

LEFT JOIN Cidade
ON Cidade.Sigla_Est = Estado.Sigla_Est

GROUP BY Estado.Sigla_Est;

-- 28. Escreva um comando que exiba o total de bônus que cada funcionário recebeu, mostrando o nome de cada funcionário

SELECT Funcionario.*, SUM(Bonus.Val_Bonus) Total_de_Bonus

FROM Funcionario

LEFT JOIN Bonus
ON Funcionario.Cod_Func = Bonus.Cod_Func

GROUP BY Funcionario.Cod_Func;

-- 29. Escreva um comando que exiba a quantidade de endereços que cada cliente tem, mostrando o nome de cada cliente

SELECT Cliente.*, COUNT(Endereco.Cod_End) Qte_Enderecos

FROM Cliente

LEFT JOIN Endereco
ON Endereco.Cod_Cli = Cliente.Cod_Cli

GROUP BY Cliente.Cod_Cli;

-- 30. Escreva um comando que exiba o total de pontos que cada funcionário fez por mês, mostrando o nome do funcionário

SELECT Funcionario.Nome_Func, MONTH(Pontuacao.Data_Pto) Mes, SUM(Pto_Func) Total_de_Pontos_no_Mes

FROM Funcionario

LEFT JOIN Pontuacao
ON Pontuacao.Cod_Func = Funcionario.Cod_Func

GROUP BY Funcionario.Cod_Func, Mes;
