
-- 1. Escreva um comando que mostre o número, a data e o valor total de cada pedido,
--    mostrando também o nome de cada cliente que fez o pedido e o nome de cada funcionário
--    que atendeu cada pedido.

SELECT p.Num_Ped, p.Data_Ped, p.Val_Ped, c.Nome_Cli, f.Nome_Func

FROM Pedido AS p

INNER JOIN Cliente AS c
ON c.Cod_Cli = p.Cod_Cli

INNER JOIN Funcionario AS f
ON f.Cod_Func = p.Cod_Func;

-- XXX usando sub-consulta

SELECT p.Num_Ped, p.Data_Ped, p.Val_Ped,
       ( SELECT Nome_Cli FROM Cliente WHERE Cod_Cli = p.Cod_Cli ) AS Nome_Cli,
       ( SELECT Nome_Func FROM Funcionario WHERE Cod_Func = p.Cod_Func ) AS Nome_Func

FROM Pedido AS p;


-- 2. Escreva um comando que apresente o nome de cada cliente e o nome do cônjuge
--    daqueles que forem casados.

SELECT ci.Nome_Cli, co.Nome_Conj

FROM Cliente AS ci

LEFT JOIN Conjuge AS co
ON ci.Cod_Cli = co.Cod_Cli;

-- XXX usando sub-consulta

SELECT Nome_Cli, ( SELECT Nome_Conj FROM Conjuge WHERE Conjuge.Cod_Cli = c.Cod_Cli ) Nome_Conj

FROM Cliente AS c;

-- 3. Escreva um comando que apresente a renda de cada cliente, juntando a renda do cliente
--    e do cônjuge para os clientes casados.

SELECT Cliente.Nome_Cli, Cliente.Renda_Cli + COALESCE(Conjuge.Renda_Conj, 0) Renda_Somada

FROM Cliente

LEFT JOIN Conjuge
ON Conjuge.Cod_Cli = Cliente.Cod_Cli;

-- XXX usando sub-consulta

SELECT c.Nome_Cli,
       c.Renda_Cli + COALESCE(( SELECT Renda_Conj FROM Conjuge WHERE Conjuge.Cod_Cli = c.Cod_Cli ), 0) Renda_Somada

FROM Cliente c;


-- 4. Escreva um comando que apresente os dados dos clientes, os e-mails de cada um e os
--    telefones de cada um.

SELECT c.*, f.Num_Fone Contato, 'FONE' AS Contato_Tipo

FROM Cliente AS c

INNER JOIN Fone AS f
ON f.Cod_Cli = c.Cod_Cli

UNION

SELECT c.*, e.EMail_Cli Contato, 'EMAIL' AS Contato_Tipo

FROM Cliente AS c

INNER JOIN EMail e
ON e.Cod_Cli = c.Cod_Cli;

-- XXX usando sub-consulta

SELECT c.*, f.Num_Fone Contato, 'FONE' AS Contato_Tipo

FROM Cliente AS c, Fone f

WHERE c.Cod_Cli IN (f.Cod_Cli)

UNION

SELECT c.*, e.EMail_Cli Contato, 'EMAIL' AS Contato_Tipo

FROM Cliente AS c, EMail e

WHERE c.Cod_Cli IN (e.Cod_Cli);

-- XXX usando sub-consulta (Spartan Mode) :: Somente subqueries

SELECT
  ( SELECT Cod_Cli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Cod_Cli,
  ( SELECT Cod_TipoCli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Cod_TipoCli,
  ( SELECT Nome_Cli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Nome_Cli,
  ( SELECT Data_CadCli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Data_CadCli,
  ( SELECT Renda_Cli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Renda_Cli,
  ( SELECT Sexo_Cli FROM Cliente WHERE Cod_Cli = f.Cod_Cli) Sexo_Cli,
  f.Num_Fone AS Contato,
  'FONE' AS Contato_Tipo

FROM Fone f

UNION

SELECT
  ( SELECT Cod_Cli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Cod_Cli,
  ( SELECT Cod_TipoCli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Cod_TipoCli,
  ( SELECT Nome_Cli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Nome_Cli,
  ( SELECT Data_CadCli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Data_CadCli,
  ( SELECT Renda_Cli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Renda_Cli,
  ( SELECT Sexo_Cli FROM Cliente WHERE Cod_Cli = e.Cod_Cli) Sexo_Cli,
  e.EMail_Cli AS Contato,
  'EMAIL' AS Contato_Tipo

FROM EMail e;

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

-- XXX usando sub-consulta

SELECT
  ( SELECT Nome_Cli FROM Cliente WHERE Cod_Cli = e.Cod_Cli ) AS Nome_Cli,
  e.Nome_Rua, e.Nome_Bairro, e.Compl_End,
  ( SELECT Nome_Cid FROM Cidade WHERE Cod_Cid = e.Cod_Cid ) AS Nome_Cid,
  ( SELECT Nome_Est FROM Estado WHERE Sigla_Est IN ( SELECT Sigla_Est FROM Cidade WHERE Cod_Cid = e.Cod_Cid )) AS Nome_Est

FROM Endereco AS e;

-- 6. Escreva um comando que mostre o nome de cada funcionário e o nome de cada dependente
--    de que cada funcionário que tem dependentes.

SELECT f.Cod_Func, f.Nome_Func, d.Nome_Dep

FROM Funcionario AS f

INNER JOIN Dependente AS d
ON f.Cod_Func = d.Cod_Func;

-- XXX usando sub-consulta

SELECT
  ( SELECT Cod_Func FROM Funcionario WHERE Cod_Func = d.Cod_Func ) Cod_Func,
  ( SELECT Nome_Func FROM Funcionario WHERE Cod_Func = d.Cod_Func ) Nome_Func,
  d.Nome_Dep

FROM Dependente AS d;


-- 7. Escreva um comando que apresente o nome dos funcionários e o histórico de cada um.

SELECT f.Cod_Func, f.Nome_Func, h.Sal_Ant, h.Sal_Atual

FROM Funcionario as f

LEFT JOIN Historico as h
ON f.Cod_Func = h.Cod_Func;

-- XXX usando sub-consulta

SELECT
  h.Cod_Func,
  ( SELECT f.Nome_Func FROM Funcionario f WHERE f.Cod_Func = h.Cod_Func ),
  h.Sal_Ant, h.Sal_Atual

FROM Historico as h;

-- 8. Escreva um comando que mostre o nome de cada cliente, o número, data e valor total de cada pedido
--    que cada cliente fez e o valor de cada parcela de cada pedido.

SELECT c.Nome_Cli, p.Num_Ped, p.Data_Ped, p.Val_Ped, pa.Num_Par, pa.Val_Venc

FROM Pedido AS p

INNER JOIN Cliente AS c
ON c.Cod_Cli = p.Cod_Cli

INNER JOIN Parcela AS pa
ON p.Num_Ped = pa.Num_Ped;

-- FIXME usando sub-consulta

SELECT
  ( SELECT Nome_Cli FROM Cliente WHERE Cod_Cli IN ( SELECT Cod_Cli FROM Pedido WHERE Num_Ped = p.Num_Ped ) ) Nome_Cli,

  ( SELECT Num_Ped FROM Pedido WHERE Num_Ped = p.Num_Ped ) Num_Ped,
  ( SELECT Data_Ped FROM Pedido WHERE Num_Ped = p.Num_Ped ) Data_Ped,
  ( SELECT Val_Ped FROM Pedido WHERE Num_Ped = p.Num_Ped ) Val_Ped,

  p.Num_Par, p.Val_Venc

FROM Parcela AS p;

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

-- XXX usando sub-consulta

SELECT Cliente.*

FROM Cliente

WHERE NOT EXISTS ( SELECT Cod_Cli FROM Conjuge WHERE Conjuge.Cod_Cli = Cliente.Cod_Cli );

-- XXX usando sub-consulta

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

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Fone );

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE NOT EXISTS ( SELECT c.Cod_Cli FROM Fone f WHERE f.Cod_Cli = c.Cod_Cli );

-- 13. Escreva um comando que apresente os dados dos clientes que não têm telefone nem emails.

SELECT DISTINCT c.*

FROM Cliente AS c

LEFT JOIN Fone AS f
ON f.Cod_Cli = c.Cod_Cli

LEFT JOIN Email AS e
ON e.Cod_Cli = c.Cod_Cli

WHERE
  f.Cod_Cli IS NULL
  AND e.Cod_Cli IS NULL;

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE
  c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Fone AS f WHERE f.Cod_Cli = c.Cod_Cli )
  AND c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Email AS e WHERE e.Cod_Cli = c.Cod_Cli );

-- 14. Escreva um comando que apresente os dados de todos os clientes que não fizeram nenhum pedido.

SELECT DISTINCT c.*

FROM Cliente AS c

LEFT JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli

WHERE p.Cod_Cli IS NULL;

-- XXX usando sub-consulta

SELECT c.Cod_Cli, c.Cod_TipoCli, c.Nome_Cli, c.Data_CadCli, c.Renda_Cli, c.Sexo_Cli

FROM Cliente AS c

WHERE c.Cod_Cli NOT IN ( SELECT Cod_Cli FROM Pedido AS p WHERE p.Cod_Cli = c.Cod_Cli );

-- 15. Escreva um comando que apresente os dados dos clientes que fizeram pelo menos um pedido.

SELECT DISTINCT c.*

FROM Cliente AS c

INNER JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli;

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN ( SELECT Cod_Cli FROM Pedido );

-- 16. Escreva um comando que apresente os dados dos clientes que fizeram pedidos que
--     foram atendidos pelo funcionário de código 1.

SELECT DISTINCT c.*

FROM Cliente AS c

INNER JOIN Pedido AS p
ON p.Cod_Cli = c.Cod_Cli

WHERE p.Cod_Func = 1;

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN ( SELECT Cod_Cli FROM Pedido p WHERE Cod_Func = 1 );

-- 17. Escreva um comando que apresente todos os pedidos que foram pagos à vista.

SELECT p.*

FROM Pedido p

LEFT JOIN Parcela pa
ON pa.Num_Ped = p.Num_Ped

WHERE
  -- XXX Pedidos não parcelados
  pa.Num_Ped IS NULL;

-- XXX usando sub-consulta

SELECT p.*

FROM Pedido p

WHERE
  p.Num_Ped NOT IN ( SELECT Num_Ped FROM Parcela );

-- 18. Escreva um comando que apresente os dados dos clientes que fizeram pedidos
--     atendidos pelos funcionários que não têm dependentes.

SELECT DISTINCT c.*

FROM Cliente AS c

INNER JOIN Pedido p
ON p.Cod_Cli = c.Cod_Cli

LEFT JOIN Dependente d
ON d.Cod_Func = p.Cod_Func

WHERE d.Cod_Func IS NULL;

-- XXX usando sub-consulta

SELECT c.*

FROM Cliente AS c

WHERE c.Cod_Cli IN (

  -- XXX Funcionários SEM dependentes (NOT IN)
  SELECT p.Cod_Cli FROM Pedido p WHERE p.Cod_Func NOT IN (

    -- XXX Códigos de funcionários COM dependentes
    SELECT Cod_Func FROM Dependente

  )

);
