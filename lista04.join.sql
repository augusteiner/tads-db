
-- 1. Escreva um comando que mostre o número, a data e o valor total de cada pedido,
--    mostrando também o nome de cada cliente que fez o pedido e o nome de cada funcionário
--    que atendeu cada pedido.

SELECT p.Num_Ped, p.Data_Ped, p.Val_Ped, c.Nome_Cli, f.Nome_Func

FROM Pedido AS p

INNER JOIN Cliente AS c
ON c.Cod_Cli = p.Cod_Cli

INNER JOIN Funcionario AS f
ON f.Cod_Func = p.Cod_Func;

-- 2. Escreva um comando que apresente o nome de cada cliente e o nome do cônjuge
--    daqueles que forem casados.

SELECT ci.Nome_Cli, co.Nome_Conj

FROM Cliente AS ci

LEFT JOIN Conjuge AS co
ON ci.Cod_Cli = co.Cod_Cli;

-- 3. Escreva um comando que apresente a renda de cada cliente, juntando a renda do cliente
--    e do cônjuge para os clientes casados.

SELECT Cliente.Nome_Cli, Cliente.Renda_Cli + COALESCE(Conjuge.Renda_Conj, 0) Renda_Somada

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli;

-- 4. Escreva um comando que apresente os dados dos clientes, os e-mails de cada um e os
--    telefones de cada um.

SELECT c.Nome_Cli, c.Renda_Cli, c.Sexo_Cli, f.Num_fone, e.Email_Cli

FROM Cliente AS c

LEFT JOIN Fone AS f
ON c.Cod_Cli = f.Cod_Cli

LEFT JOIN Email AS e
ON c.Cod_Cli = e.Cod_Cli;

-- 5. Escreva um comando que mostre os nomes dos clientes, os endereços com o nome de cada cidade
--    e o nome de cada estado de cada endereço que cada cliente tem.

SELECT c.Cod_Cli, c.Nome_Cli, e.Nome_Rua, e.Nome_Bairro, e.Compl_End, ci.Nome_Cid, es.Nome_Est

FROM Cliente AS c

LEFT JOIN Endereco AS e
ON e.Cod_Cli = c.Cod_Cli

LEFT JOIN Cidade AS ci
ON ci.Cod_Cid = e.Cod_Cid

LEFT JOIN Estado AS es
ON es.Sigla_Est = ci.Sigla_Est;

-- 6. Escreva um comando que mostre o nome de cada funcionário e o nome de cada dependente
--    de que cada funcionário que tem dependentes.

SELECT f.Nome_Func, d.Nome_Dep

FROM Funcionario AS f

INNER JOIN Dependente AS d
ON f.Cod_Func = d.Cod_Func;

-- 7. Escreva um comando que apresente o nome dos funcionários e o histórico de cada um.

SELECT f.Cod_Func, f.Nome_Func, h.Sal_Ant, h.Sal_Atual

FROM Funcionario as f

LEFT JOIN Historico as h
ON f.Cod_Func = h.Cod_Func;

-- 8. Escreva um comando que mostre o nome de cada cliente, o número, data e valor total de cada pedido
--    que cada cliente fez e o valor de cada parcela de cada pedido.

SELECT c.Nome_Cli, p.Num_Ped, p.Data_Ped, p.Val_Ped, pa.Num_Par, pa.Val_Venc

FROM Pedido AS p

INNER JOIN Cliente AS c
ON c.Cod_Cli = p.Cod_Cli

INNER JOIN Parcela AS pa
ON p.Num_Ped = pa.Num_Ped;

-- 9. Escreva um comando que apresente um relatório de todos os funcionário e clientes que você tem no banco Exemplo.

SELECT Cod_Func Cod_Pessoa, Nome_Func Nome_Pessoa, Data_CadFunc Data_CadPessoa, Sexo_Func Sexo_Pessoa, 'FUNCIONARIO' Tipo_Pessoa
FROM Funcionario

UNION

SELECT Cod_Cli Cod_Pessoa, Nome_Cli Nome_Pessoa, Data_CadCli Data_CadPessoa, Sexo_Cli Sexo_Pessoa, 'CLIENTE' Tipo_Pessoa
FROM Cliente

ORDER BY Nome_Pessoa;

-- 10. Escreva um comando que apresente todos os dados dos clientes solteiros.

SELECT Cliente.*

FROM Cliente

LEFT JOIN Conjuge
ON Cliente.Cod_Cli = Conjuge.Cod_Cli

WHERE Conjuge.Cod_Cli IS NULL;

-- OU

SELECT Cliente.*

FROM Cliente

WHERE NOT EXISTS ( SELECT Cod_Cli FROM Conjuge WHERE Conjuge.Cod_Cli = Cliente.Cod_Cli );

-- OU

SELECT Cliente.*

FROM Cliente

WHERE Cod_Cli NOT IN ( SELECT Cod_Cli FROM Conjuge );

-- 11. Escreva um comando que apresente os dados do cliente que tem o salário mais alto.

SELECT c.*

FROM Cliente as c

WHERE c.Renda_Cli = ( SELECT MAX(c.Renda_Cli) FROM Cliente c );

-- 12. Escreva um comando que apresente os dados dos clientes que não têm telefone.

SELECT c.*

FROM Cliente AS c

LEFT JOIN Fone AS f
ON f.Cod_Cli = c.Cod_Cli

WHERE f.Cod_Cli IS NULL;

-- OU

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Fone );

-- OU

SELECT c.*

FROM Cliente AS c

WHERE NOT EXISTS ( SELECT c.Cod_Cli FROM Fone f WHERE f.Cod_Cli = c.Cod_Cli );

-- 13. Escreva um comando que apresente os dados dos clientes que não têm telefone nem emails.

SELECT c.*

FROM Cliente AS c

LEFT JOIN Fone AS f
ON f.Cod_Cli = c.Cod_Cli

LEFT JOIN Email AS e
ON e.Cod_Cli = c.Cod_Cli

WHERE f.Cod_Cli IS NULL AND e.Cod_Cli IS NULL

GROUP BY c.Cod_Cli;

-- OU

SELECT c.*

FROM Cliente AS c

WHERE
  c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Fone AS f WHERE f.Cod_Cli = c.Cod_Cli )
  AND c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Email AS e WHERE e.Cod_Cli = c.Cod_Cli );

-- 14. Escreva um comando que apresente os dados de todos os clientes que não fizeram nenhum pedido.

SELECT c.*

FROM Cliente AS c

LEFT JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli

WHERE p.Cod_Cli IS NULL;

-- OU

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Pedido AS p WHERE p.Cod_Cli = c.Cod_Cli );

-- 15. Escreva um comando que apresente os dados dos clientes que fizeram pelo menos um pedido.

SELECT c.*

FROM Cliente AS c

INNER JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli

GROUP BY c.Cod_Cli;

-- OU

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN ( SELECT Cod_Cli FROM Pedido );

-- 16. Escreva um comando que apresente os dados dos clientes que fizeram pedidos que
--     foram atendidos pelo funcionário de código 1.

SELECT c.*

FROM Cliente AS c

INNER JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli

WHERE p.Cod_Func = 1

GROUP BY c.Cod_Cli;

-- OU

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN ( SELECT Cod_Cli FROM Pedido p WHERE Cod_Func = 1 );

-- 17. Escreva um comando que apresente todos os pedidos que foram pagos à vista.

SELECT p.*

FROM Pedido p

WHERE
  p.Cod_Sta IN ( SELECT Cod_Sta FROM StatusPedido WHERE Sta_Ped = 'Fechado' )
  AND p.Num_Ped IN ( SELECT Num_Ped FROM Parcela WHERE Data_Venc = Data_Pgto );

-- 18. Escreva um comando que apresente os dados dos clientes que fizeram pedidos
--     atendidos pelos funcionários que não têm dependentes.

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN (

  SELECT p.Cod_Cli

  FROM Pedido p

  -- XXX Funcionários SEM dependentes (NOT IN)
  WHERE p.Cod_Func NOT IN (

    -- XXX Códigos de funcionários COM dependentes
    SELECT Cod_Func

    FROM Dependente

  )

);
