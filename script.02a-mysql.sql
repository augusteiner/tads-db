/*
 * MIT License
 *
 * Copyright (c) 2016 José Augusto
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/****************************************************************************/
/* Estabelecendo uma Conexão com o Database SYSAMPLE                        */
/*  Script_02A                                                              */
/****************************************************************************/

USE Exemplo

;

DELIMITER //

/****************************************************************************/
/* Criando as Procedures que geram dados para as Tabelas                    */
/****************************************************************************/
CREATE PROCEDURE P_GeraDadosFuncionario()
BEGIN

  -- ALTER TABLE Funcionario
  -- NOCHECK CONSTRAINT CH_Func1

  INSERT INTO Funcionario (
    Nome_Func, Data_CadFunc, Sexo_Func, Sal_Func, End_Func)
  VALUES
    ('Antonio Antonino Antones', '00-02-01', 'M', 1500.00, 'Rua A '),
    ('Amaro Merico Vespucio', '00-02-02', 'M', 2500.00, 'Rua B'),
    ('Abílio Abel Garcia', '01-02-03', 'M', 1000.00, 'Rua C'),
    ('Bia Bianca Bones', '01-03-04', 'F', 5000.25, 'Rua D'),
    ('Beatriz Bertioga', '01-05-05', 'F', 300.00, 'Rua E'),
    ('Caio Cesar Cearez', '01-05-06', 'M', 250.00, 'Rua F'),
    ('Celso Cesare', '01-06-07', 'M', 1542.36, 'Rua J'),
    ('Danilo Douglas', '01-06-08', 'M', 1524.56, 'Rua K'),
    ('Denis Denilo', '01-07-09', 'M', 5235.56, 'Rua L'),
    ('Everton Evaristo', '01-07-10', 'M', 2542.25, 'Rua M'),
    ('Evanir Eva', '01-08-11', 'M', 4523.54, 'Rua N'),
    ('Fabio Fabricio', '01-08-12', 'M', 1524.25, 'Rua O'),
    ('Fabiola Fabiolo', '02-01-02', 'F', 2554.25, 'Rua P'),
    ('Geraldo Gomes', '02-010-03', 'M', 1542.25, 'Rua Q'),
    ('Helio Heliópolis', '02-01-04', 'M', 1542.23, 'Rua R'),
    ('Irineu Irene', '02-02-05', 'M', 2523.00, 'Rua S'),
    ('Jonas jackes', '02-02-05', 'M', 2500.00, 'Rua T'),
    ('Leandro Lago', '02-02-06', 'M', 1500.00, 'Rua U'),
    ('Lucio Lacio', '02-03-07', 'M', 2500.00, 'Rua V'),
    ('Lecio Licio', '02-04-08', 'M', 1420.00, 'Rua X'),
    ('Mario Mendes', '02-02-06', 'M', 1262.00, 'Rua W'),
    ('Olavo Odavlas', '02-07-07', 'M', 1540.00, 'Rua Y')

;

  -- ALTER TABLE Funcionario
  -- CHECK CONSTRAINT CH_Func1

END//


/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosBonus(
  Val_Bonus DECIMAL(10, 2))
BEGIN

  -- ALTER TABLE Bonus
  -- NOCHECK CONSTRAINT CH_Bonus1;

  INSERT INTO Bonus (Cod_Func, Data_Bonus, Val_Bonus)
  SELECT Cod_Func, CURDATE() - INTERVAL 30 DAY, Val_Bonus
  FROM Funcionario;

  -- ALTER TABLE Bonus
  -- NOCHECK CONSTRAINT CH_Bonus1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosPontuacao(
  Val_Pontos DECIMAL(10, 2),
  Cod_Func1 INT,
  Cod_Func2 INT)
BEGIN

  -- ALTER TABLE Pontuacao
  -- NOCHECK CONSTRAINT CH_Pto1;

  INSERT INTO Pontuacao (Cod_Func, Data_Pto, Pto_Func)
  SELECT Cod_Func, DATE_SUB(CURDATE(), INTERVAL 30 DAY), Val_Pontos
  FROM Funcionario;

  -- ALTER TABLE Pontuacao
  -- NOCHECK CONSTRAINT CH_Pto1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosHistorico()
BEGIN

  -- ALTER TABLE Historico
  -- NOCHECK CONSTRAINT CH_Hist1;

  INSERT INTO Historico (Cod_Func, Data_Hist, Sal_Ant, Sal_Atual)
    SELECT Cod_Func, DATE_SUB(CURDATE(), INTERVAL 30 DAY), CONVERT(Sal_Func / 2, DECIMAL(10, 2)), Sal_Func
    FROM Funcionario;

  -- ALTER TABLE Historico
  -- CHECK CONSTRAINT CH_Hist1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosPedido()
BEGIN

  -- ALTER TABLE Pedido
  -- NOCHECK CONSTRAINT CH_Pedido1, FK_Pedido1, FK_Pedido2;

  INSERT INTO Pedido (Cod_Cli, Cod_Func, Cod_Sta, Data_Ped, Val_Ped)
  SELECT Cod_Cli, Cod_Func, Cod_Sta, CURDATE() - INTERVAL 1 YEAR, Cod_Cli * 100
  FROM Cliente, Funcionario, StatusPedido;

  -- ALTER TABLE Pedido
  -- NOCHECK CONSTRAINT CH_Pedido1, FK_Pedido1, FK_Pedido2;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_Parcelas (
  Val_Lim1 DECIMAL(10, 2),
  Val_Lim2 DECIMAL(10, 2),
  NumPar INT)
BEGIN

  -- ALTER TABLE PARCELA
  -- NOCHECK CONSTRAINT CH_Parcela1;

  DECLARE Cont INT;
  DECLARE TotLim INT;
  DECLARE Cont2 INT;

  DROP TEMPORARY TABLE IF EXISTS Tabela;

  CREATE TEMPORARY TABLE Tabela (

    Linha INT AUTO_INCREMENT,
    Num_Par SMALLINT NULL DEFAULT NULL,
    Num_Ped INT,
    Data_Venc DATETIME,
    Val_Ped DECIMAL(10, 2),
    Val_Par DECIMAL(10, 2),
    Data_Pgto DATETIME,
    Val_Pgto DECIMAL(10, 2),

    PRIMARY KEY (Linha)

  );

  SET Cont = 1;
  SET Cont2 = 1;

  INSERT INTO Tabela (Num_Par, Num_Ped, Data_Venc, Val_Ped, Val_Par, Data_Pgto, Val_Pgto)
    SELECT 1, Num_Ped, Data_Ped, Val_Ped, CONVERT(Val_Ped / 3, DECIMAL(10, 2)), null, null
    FROM Pedido
    WHERE Val_Ped between Val_Lim1 AND Val_Lim2;

  SELECT TotLim = COUNT(*)
  FROM Tabela;

  WHILE Cont <= TotLim DO

    WHILE Cont2 <= NumPar DO

      UPDATE Tabela
      SET Num_Par = Cont2,
        Data_Venc = DATE_ADD(Data_Venc, INTERVAL Cont2 DAY),
        Val_Pgto = Val_Par,
        Data_Pgto = Data_Venc
      WHERE Linha = Cont;

      SET Cont2 = Cont2 + 1;
      SET Cont = Cont + 1;

    END WHILE;

    SET Cont2 = 1;

  END WHILE;

  -- SELECT *
  -- FROM Tabela
  -- WHERE Num_Par IS NULL;

  INSERT INTO Parcela (Num_Par, Num_Ped, Data_Venc, Val_Pgto, Data_Pgto)
    SELECT Num_Par, Num_Ped, Data_Venc, Val_Par, Data_Pgto
    FROM Tabela
    /* WHERE Num_Par IS NOT NULL */;

  -- ALTER TABLE PARCELA
  -- CHECK CONSTRAINT CH_Parcela1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosItens (
  Cod1 INT,
  Cod2 INT,
  Qtd INT)
BEGIN

  INSERT INTO Itens
    SELECT Pedido.Num_Ped, Produto.Cod_Prod, Qtd, Produto.Val_UnitProd
    FROM Pedido
    CROSS JOIN Produto
    WHERE Pedido.Num_Ped BETWEEN Cod1 AND Cod2;

END//

/****************************************************************************/
/* Inserindo dados diretamente nas tabelas e com a execução das procedures  */
/* criadas anteriormente neste script                                       */
/****************************************************************************/


INSERT INTO TipoEnd (Nome_TipoEnd)
VALUES
  ('Entrega'),
  ('Faturamento'),
  ('Correspondência'),
  ('Cobrança'),
  ('Residential'),
  ('Comercial')

;


INSERT INTO Estado (Sigla_Est, Nome_Est)
VALUES
  ('AC', 'Acre'),
  ('AL', 'Alagoas'),
  ('AM', 'Amazonas'),
  ('AP', 'Amapa'),
  ('BA', 'Bahia'),
  ('CE', 'Ceará'),
  ('DF', 'Destrito Federal'),
  ('ES', 'Espirito Santo'),
  ('GO', 'Goias'),
  ('MA', 'Maranhão'),
  ('MG', 'Minas Gerais'),
  ('MS', 'Mato Grosso do Sul'),
  ('MT', 'Mato Grosso do Norte'),
  ('PB', 'Paraíba'),
  ('PE', 'Pernambuco'),
  ('PI', 'Piauí'),
  ('PR', 'Paraná'),
  ('RJ', 'Rio de Janeiro'),
  ('RN', 'Rio Grande do Norte'),
  ('RO', 'Rondônia'),
  ('RR', 'Roraima'),
  ('RS', 'Rio Grande do Sul'),
  ('SC', 'Santa Catarina'),
  ('SE', 'Sergipe'),
  ('SP', 'São Paulo'),
  ('TO', 'Tocantins')

;


INSERT INTO Cidade (Sigla_Est, Nome_Cid)
VALUES
  ('SP', 'Araraquara'),
  ('SP', 'Americana'),
  ('SP', 'Araçatuba'),
  ('SP', 'Fernandópolis'),
  ('SP', 'Jundiaí'),
  ('SP', 'Sorocaba'),
  ('SP', 'São José do Rio Preto')

;


INSERT INTO TipoCli (Nome_TipoCli)
VALUES
  ('Diamante'),
  ('Ouro'),
  ('Prata'),
  ('Bronze'),
  ('Cobre'),
  ('Zinco')

;


INSERT INTO Cliente (Cod_TipoCli, Nome_Cli, Data_CadCli, Renda_Cli, Sexo_Cli)
VALUES
  (1, 'João Carlos', '1999-01-01', 10000, 'M'),
  (1, 'Daniel Souza', '1999-02-02', 10000, 'M'),
  (1, 'Helena Oliveira', '1999-03-03', 9000, 'F'),
  (1, 'Roberta Oliveira', '1999-04-04', 8000, 'F'),
  (2, 'Renata Leão', '1999-05-05', 5000, 'F'),
  (2, 'Jairo Gato', '1999-06-06', 4000, 'M'),
  (3, 'Fernando Gato', '1999-07-07', 3000, 'M'),
  (3, 'Giovanna Silva Leão', '1999-08-08', 3000, 'F'),
  (4, 'Lucas Ribeiro', '1999-09-09', 2000, 'M'),
  (3, 'Helder Leão', '1999-10-10', 2000, 'M'),
  (2, 'Olga Cristina Bonfiglioli', '1999-11-11', 8000, 'F'),
  (1, 'Maria Cristina Bonfiglioli Martins de Souza Santos', '1999-12-12', 5000, 'F'),
  (1, 'Salvador Eneas Feredico', '1999-01-13', 9000, 'M'),
  (1, 'Dolores Gerreiro Martins', '2000-02-14', 8000, 'F'),
  (1, 'Fabiana Bataglin', '2000-03-15', 5000, 'F'),
  (2, 'Aparecida Ribeiro', '2000-04-16', 3000, 'F'),
  (3, 'Reginaldo Ribeiro', '2000-05-17', 4000, 'M'),
  (4, 'Suellen M Nunes', '2000-06-18', 3000, 'F'),
  (1, 'Carlos Alberto', '2000-07-19', 2000, 'M'),
  (2, 'Roberto Arruda', '2000-08-20', 1000, 'M'),
  (3, 'Sandra Medeiros', '2000-09-21', 1500, 'F'),
  (4, 'Alice Santos', '2001-10-22', 2500, 'F'),
  (5, 'Valter Sanches', '2001-11-23', 3500, 'M'),
  (6, 'Pascoal Babiera', '2001-12-24', 1525, 'M'),
  (1, 'Lucia Bacalla', '2001-01-25', 6321, 'F'),
  (3, 'Maria Belido', '2001-02-26', 5412, 'F'),
  (4, 'Hamilton Belico', '2001-03-26', 2563, 'M'),
  (5, 'Alberto Belli', '2001-04-27', 2412, 'M'),
  (6, 'Marcia Bueno', '2001-05-28', 1235, 'F'),
  (1, 'Maria Catta', '2001-06-29', 1236, 'F'),
  (2, 'Carlos Cattaneo', '2001-07-30', 1253, 'M'),
  (3, 'Andre Caula', '2001-08-31', 1524, 'M'),
  (4, 'Fabia Dávello', '2001-09-01', 1236, 'F'),
  (5, 'Afonso Ferraro', '2001-10-02', 1256, 'M'),
  (6, 'Akemi Fukamizu', '2001-11-03', 1452, 'F'),
  (1, 'Bernadino Gomes', '2001-12-04', 11785, 'M'),
  (2, 'Regiani Hoki', '2001-01-05', 1524, 'F'),
  (3, 'Valter Koszura', '2001-02-06', 1256, 'M'),
  (4, 'Alexandre Kozeki', '2001-03-07', 1225, 'M'),
  (5, 'Vittorio Lannocca', '2001-04-08', 1253, 'M'),
  (6, 'Domingos Lanini', '2002-05-09', 1253, 'M'),
  (1, 'Paulo Mello', '2001-06-10', 10000, 'M'),
  (2, 'Zilda Mellone', '2001-07-11', 8000, 'F'),
  (3, 'Marlene Moura', '2001-08-12', 3000, 'F'),
  (4, 'Francisca Oliveira', '2001-09-13', 2300, 'F'),
  (5, 'Marlene Pereira', '2001-10-14', 2562, 'F'),
  (6, 'Milton Pereira', '2001-11-15', 2563, 'M'),
  (1, 'Ligia Ramos', '2001-12-16', 9200, 'F'),
  (2, 'Mariangela Ramos', '2001-01-17', 7000, 'F'),
  (3, 'Dora Romariz', '2001-02-18', 5263, 'F'),
  (4, 'Paulino Romelli', '2001-03-19', 5428, 'M'),
  (5, 'Fernando Sampaio', '2001-04-20', 2023, 'M'),
  (6, 'José Sampaio', '2001-05-21', 2235, 'M'),
  (1, 'Vicenzo Senatori', '2001-06-22', 7000, 'M'),
  (2, 'Geraldo Senedeze', '2001-07-23', 2531, 'M'),
  (3, 'Mauro Soares', '2001-08-24', 2532, 'M'),
  (4, 'Paulo Souza', '2001-09-25', 2542, 'M'),
  (5, 'Emidio Trifoni', '2001-10-26', 2563, 'M'),
  (6, 'Heitor Vernile', '2001-11-27', 2542, 'M'),
  (1, 'Carlos Saura', '2001-12-28', 6000, 'M'),
  (2, 'Angelino Saullo', '2001-01-29', 5000, 'M'),
  (3, 'Aldo Savazzoni', '2001-02-28', 4000, 'M')

;


INSERT INTO Conjuge
VALUES
  (1, 'Renata', 3000.00, 'F'),
  (2, 'Helena', 5000.00, 'F'),
  (3, 'Daniel', 6000.00, 'M'),
  (4, 'Tarcisio', 1000.00, 'M'),
  (5, 'João Carlos', 7000.00, 'M'),
  (6, 'Carla', 9000.00, 'M'),
  (7, 'Ana Lucia', 3000.00, 'F')

;


INSERT INTO Endereco (Cod_TipoEnd, Cod_Cid, Cod_Cli, Nome_Rua, Nome_Bairro, Compl_End)
VALUES
  (1, 1, 1, 'Rua Soraia - 29', 'Vila Santana', NULL),
  (2, 1, 1, 'Rua Macunaima - 192', 'Jd.Europa', NULL),
  (1, 1, 2, 'Rua Mariá - 342', 'Jd. Araguaia', 'Apto. 23'),
  (2, 2, 2, 'Rua Juca - 542', 'Vila Catarina ', 'Apto. 2'),
  (2, 2, 3, 'Pça Marcondes - 542', 'Vila Tereza ', NULL),
  (3, 1, 4, 'Rua Santa Catarina - 1342', 'Vila Osvaldo Cruz', NULL),
  (1, 1, 1, 'Av. Imirim, 325', 'Vila Vilma', NULL),
  (1, 1, 2, 'Rua Clélia, 456', 'Vila Zoraide', NULL),
  (1, 1, 3, 'Rua Pio XI, 938', 'Jd. América', NULL),
  (2, 1, 4, 'Travessa 15, 1200', 'Vila Sonia', NULL),
  (2, 2, 5, 'Av. Sodré, 392', 'Jd. Carnaúba', NULL),
  (2, 3, 6, 'Av Mutinga, 200', 'Parque das Flores', NULL),
  (3, 2, 7, 'Rua Cons. Ribas 594', 'Parque Municipal', NULL),
  (3, 2, 8, 'Rua Maria Belido', 'Parque Industrial', NULL),
  (3, 2, 9, 'Rua Avai 164', 'Vila Maria', NULL),
  (4, 2, 10, 'Rua Bororós, 67', 'Vila Santa Terezinha', NULL),
  (4, 2, 11, 'Rua Jose Pereira, 340', 'Zona da Mata', NULL),
  (4, 3, 12, 'Av. Casa Verde, 450', 'Jd. Botucatu', NULL),
  (4, 4, 13, 'Av Dr Gouveia, 392', 'Jd. Moricatupotá', NULL),
  (5, 3, 14, 'Rua Lucena 184', 'Jd. Canhem BaBa', NULL),
  (5, 3, 15, 'Av. Indianópolis 593', 'Vila Angela', NULL),
  (5, 3, 16, 'Rua Alexandre Duma 486', 'Parque Piributa', NULL),
  (6, 3, 17, 'Rua Maria Júlia 1207', 'Jd. Americanópolis', NULL),
  (6, 3, 18, 'Rua Afonso Meira, 948', 'Parque Cruzeiro do Sul', NULL),
  (6, 3, 19, 'Rua Bela Cintra 392', 'Vila Saturno', NULL),
  (6, 4, 20, 'Rua Basilio 199', 'Jardim Jupter', NULL),
  (1, 4, 21, 'Rua Doce 32', 'Praça Marte', NULL),
  (1, 4, 22, 'Rua Grumix 114', 'Largo de Netuno', NULL),
  (1, 4, 23, 'Rua Emilia 32', 'Area de Plutão', NULL),
  (1, 4, 24, 'Al Jurupis 900', 'Vila Lua Branca', NULL),
  (1, 4, 25, 'Av. Guedes 653', 'Parque Urano', NULL),
  (2, 5, 26, 'Rua Neves 430', 'Jd. Paraiso', NULL),
  (2, 5, 27, 'Av. Mario Zonta, 180', 'Terra Prometida', NULL),
  (2, 5, 28, 'Rua Florida, 430', 'Jd. das Flores', NULL),
  (3, 5, 29, 'Av. Jose Barroso, 305', 'Praça das Margaridas', NULL),
  (3, 5, 30, 'Rua Mirina, 38', 'Zona Franca', NULL),
  (4, 5, 31, 'Rua Iagaraí, 46', 'Jd. Brasileiro', NULL),
  (4, 5, 32, 'Rua Paulista, 251', 'Jd. MMDC', NULL),
  (4, 2, 33, 'Rua Salete, 320', 'Jd. Sales Garcia', NULL),
  (5, 1, 34, 'Rua Souza, 115', 'Vila Sonia', NULL),
  (5, 1, 35, 'Rua Alcion, 604', 'Parque Piraque', NULL),
  (5, 1, 36, 'Av. Sabará, 987', 'Parque Piqueri', NULL),
  (6, 2, 37, 'Rua Oscar Freire, 453', 'Parque Infantil', NULL),
  (6, 2, 38, 'Av. Amaral Gama, 58', 'Jardim Judas', NULL),
  (6, 2, 39, 'Rua Iru, 23', 'Jd. São Salvador', NULL),
  (1, 2, 40, 'Rua Silvia, 560', 'Vila Pau Brasil', NULL),
  (1, 2, 41, 'Rua Moura, 147', 'Vila Viela', NULL),
  (1, 3, 42, 'Rua Aroeir, 954', 'Vila Amarela', NULL),
  (1, 3, 43, 'Rua Pereira, 394', 'Vila Verde', NULL),
  (2, 3, 44, 'Rua Galeão, 54', 'Vila Branca', NULL)

;


INSERT INTO Credito (Cod_Cli, Cred_Cli, Data_CredCli)
VALUES
  (1, 1000.00, DATE_SUB(CURDATE(), INTERVAL 30 DAY)),
  (1, 2000.00, DATE_SUB(CURDATE(), INTERVAL 29 DAY)),
  (1, 3000.00, DATE_SUB(CURDATE(), INTERVAL 28 DAY)),
  (2, 1000.00, DATE_SUB(CURDATE(), INTERVAL 27 DAY)),
  (3, 1000.00, DATE_SUB(CURDATE(), INTERVAL 26 DAY)),
  (4, 1000.00, DATE_SUB(CURDATE(), INTERVAL 25 DAY)),
  (5, 1000.00, DATE_SUB(CURDATE(), INTERVAL 24 DAY)),
  (6, 1000.00, DATE_SUB(CURDATE(), INTERVAL 23 DAY)),
  (7, 1000.00, DATE_SUB(CURDATE(), INTERVAL 22 DAY)),
  (8, 1000.00, DATE_SUB(CURDATE(), INTERVAL 21 DAY)),
  (9, 1000.00, DATE_SUB(CURDATE(), INTERVAL 20 DAY)),
  (10, 1000.00, DATE_SUB(CURDATE(), INTERVAL 19 DAY)),
  (11, 1000.00, DATE_SUB(CURDATE(), INTERVAL 18 DAY)),
  (12, 1000.00, DATE_SUB(CURDATE(), INTERVAL 17 DAY)),
  (13, 1000.00, DATE_SUB(CURDATE(), INTERVAL 16 DAY)),
  (14, 1000.00, DATE_SUB(CURDATE(), INTERVAL 15 DAY)),
  (15, 1000.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  (16, 1000.00, DATE_SUB(CURDATE(), INTERVAL 13 DAY)),
  (17, 1000.00, DATE_SUB(CURDATE(), INTERVAL 12 DAY)),
  (18, 1000.00, DATE_SUB(CURDATE(), INTERVAL 11 DAY)),
  (19, 1000.00, DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
  (20, 1000.00, DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
  (21, 1000.00, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
  (22, 1000.00, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
  (23, 1000.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
  (24, 1000.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  (25, 1000.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
  (26, 1000.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
  (27, 1000.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
  (28, 1000.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
  (29, 1000.00, DATE_SUB(CURDATE(), INTERVAL 30 DAY)),
  (30, 1000.00, DATE_SUB(CURDATE(), INTERVAL 29 DAY)),
  (31, 1000.00, DATE_SUB(CURDATE(), INTERVAL 28 DAY)),
  (32, 1000.00, DATE_SUB(CURDATE(), INTERVAL 27 DAY)),
  (33, 1000.00, DATE_SUB(CURDATE(), INTERVAL 26 DAY)),
  (34, 1000.00, DATE_SUB(CURDATE(), INTERVAL 25 DAY)),
  (35, 1000.00, DATE_SUB(CURDATE(), INTERVAL 24 DAY)),
  (36, 1000.00, DATE_SUB(CURDATE(), INTERVAL 23 DAY)),
  (37, 1000.00, DATE_SUB(CURDATE(), INTERVAL 22 DAY)),
  (38, 1000.00, DATE_SUB(CURDATE(), INTERVAL 21 DAY)),
  (39, 1000.00, DATE_SUB(CURDATE(), INTERVAL 20 DAY)),
  (40, 1000.00, DATE_SUB(CURDATE(), INTERVAL 19 DAY)),
  (41, 1000.00, DATE_SUB(CURDATE(), INTERVAL 18 DAY)),
  (42, 1000.00, DATE_SUB(CURDATE(), INTERVAL 17 DAY)),
  (43, 1000.00, DATE_SUB(CURDATE(), INTERVAL 16 DAY)),
  (44, 1000.00, DATE_SUB(CURDATE(), INTERVAL 15 DAY)),
  (45, 1000.00, DATE_SUB(CURDATE(), INTERVAL 14 DAY)),
  (46, 1000.00, DATE_SUB(CURDATE(), INTERVAL 13 DAY)),
  (47, 1000.00, DATE_SUB(CURDATE(), INTERVAL 12 DAY)),
  (48, 1000.00, DATE_SUB(CURDATE(), INTERVAL 11 DAY)),
  (49, 1000.00, DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
  (50, 1000.00, DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
  (51, 1000.00, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
  (52, 1000.00, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
  (53, 1000.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
  (54, 1000.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
  (55, 1000.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
  (56, 1000.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
  (57, 1000.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
  (58, 1000.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
  (59, 1000.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
  (60, 1000.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
  (61, 1000.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY))

;

INSERT INTO Fone (Cod_Cli, Num_Fone, Num_DDD)
VALUES
  (1, '434-2356', '011'),
  (1, '256-4578', '011'),
  (1, '256-5623', '011'),
  (2, '242-9865', '011'),
  (2, '323-8945', '011'),
  (2, '232-7845', '011'),
  (3, '565-2365', '011'),
  (3, '454-1254', '011'),
  (3, '898-2345', '011'),
  (4, '454-1223', '011'),
  (4, '787-4512', '011'),
  (5, '525-4578', '011'),
  (5, '252-9887', '011'),
  (6, '578-6521', '011'),
  (6, '568-5421', '011'),
  (7, '536-3254', '011'),
  (8, '568-2154', '011'),
  (9, '587-3221', '011'),
  (10, '863-6598', '011'),
  (11, '138-8754', '011'),
  (12, '123-6598', '011'),
  (13, '321-6357', '011'),
  (14, '301-1232', '011'),
  (15, '321-4512', '011'),
  (16, '333-3221', '011'),
  (17, '555-4578', '011'),
  (18, '666-1245', '011'),
  (19, '777-3265', '011'),
  (20, '888-2154', '011'),
  (21, '999-1111', '015'),
  (21, '202-1222', '015'),
  (22, '254-3333', '015'),
  (23, '458-4444', '015'),
  (23, '874-5555', '015'),
  (24, '313-6666', '015'),
  (24, '587-7777', '015'),
  (25, '589-8888', '015'),
  (26, '999-9999', '015'),
  (27, '999-1010', '015'),
  (27, '111-1111', '015'),
  (28, '222-1212', '015'),
  (28, '333-1313', '015'),
  (28, '444-1414', '015'),
  (29, '555-1515', '015'),
  (29, '666-1616', '015'),
  (30, '777-1717', '015'),
  (31, '888-1818', '015'),
  (32, '999-1919', '015'),
  (33, '101-2020', '015'),
  (34, '555-2121', '021'),
  (35, '333-2222', '021'),
  (36, '717-2323', '021'),
  (37, '656-2424', '021'),
  (38, '374-2525', '021'),
  (39, '859-2626', '021'),
  (40, '222-2727', '021'),
  (41, '256-2828', '021'),
  (42, '542-2929', '021'),
  (43, '578-3030', '021'),
  (44, '896-4041', '021'),
  (45, '369-5050', '021'),
  (46, '132-5151', '021'),
  (47, '321-6161', '021'),
  (48, '542-7171', '011'),
  (49, '201-8181', '011'),
  (50, '301-9191', '011'),
  (50, '401-1919', '011'),
  (50, '501-1818', '011'),
  (51, '601-1212', '011'),
  (52, '701-1313', '011'),
  (53, '801-1414', '011'),
  (54, '901-1515', '011'),
  (56, '222-1616', '011'),
  (56, '333-1714', '011'),
  (57, '111-1818', '011'),
  (58, '444-1919', '011'),
  (59, '222-2020', '011'),
  (62, '333-2121', '011')

;

INSERT INTO EMail (Cod_Cli, EMail_Cli)
VALUES
  (1, 'Joaobrasao@Hotmail.com'),
  (1, 'Joaobrasao@bbb.com.br'),
  (1, 'Joaobrasao@xxx.com.br'),
  (1, 'JoaoCarloss@Globo.com.br'),
  (2, 'DanielLeao@uol.com.br'),
  (3, 'HOL@Hotmail.com'),
  (4, 'ROL@Hotmail.com'),
  (5, 'RenataLeao01@Hotmail.com'),
  (5, 'Renata.Leao@Globo.com'),
  (6, 'JairoGato@Bol.com.br'),
  (7, 'FernandoLeao@Hotmil.com'),
  (8, 'GiGi_Leao@Hotmial.com'),
  (9, 'Lucas_Leao@Hotmail.com'),
  (10, 'HelderLeão@Hotmail.com'),
  (11, 'OlgaCBonfiglioli@Hotmail.com'),
  (12, 'MCBMSS@Hotmail.com'),
  (13, 'SEFeredico@Hotmail.com'),
  (14, 'DoloresGMartins@Hotmail.com'),
  (15, 'Fabiana_Bataglin@Hotmail.com'),
  (28, 'Alberto_Belli@Hotmail.com'),
  (29, 'Marcia_Bueno@Hotmail.com'),
  (30, 'MariaCatta@Hotmail.com'),
  (38, 'ValterKoszura@Hotmail.com'),
  (51, 'PaulinoRomelli@Hotmail.com'),
  (52, 'Fernando Sampaio'),
  (53, 'JoséSampaio@uol.com.br'),
  (54, 'VicenzoSenatori@uol.com.br'),
  (55, 'GeraldoSenedeze@uol.com.br'),
  (61, 'AngelinoSaullo@uol.com.br'),
  (62, 'AldoSavazzoni@uol.com.br')

;


INSERT INTO StatusPedido (Sta_Ped)
VALUES
  ('Aberto'),
  ('Pendente'),
  ('Fechado'),
  ('Cancelado')

;


CALL P_GeraDadosFuncionario();

CALL P_GeraDadosBonus(100.00);

CALL P_GeraDadosBonus(300.00);

CALL P_GeraDadosPontuacao(10, 1, 10);

CALL P_GeraDadosPontuacao(70, 11, 22);

CALL P_GeraDadosHistorico();


INSERT INTO Dependente (Cod_Func, Nome_Dep, Data_NascDep, Sexo_Dep)
VALUES
  (3, 'Sebastiana Maria', '64-02-01', 'F'),
  (3, 'Sebastião Mario', '64-02-01', 'M'),
  (4, 'Aurea Virtude', '64-02-01', 'F'),
  (4, 'Aureo Visture', '64-02-01', 'M'),
  (7, 'Pedro da Silva', '64-02-01', 'F'),
  (7, 'Alvares da Silva', '64-02-01', 'M'),
  (7, 'Cabral da Silva', '64-02-01', 'M')

;

CALL P_GeraDadosPedido();

CALL P_Parcelas(0, 300, 3);

CALL P_Parcelas(301, 400, 4);

CALL P_Parcelas(401, 500, 5);

CALL P_Parcelas(501, 600, 6);

CALL P_Parcelas(601, 700, 7);

CALL P_Parcelas(701, 800, 8);

CALL P_Parcelas(801, 900, 9);

CALL P_Parcelas(901, 10000, 10);


INSERT INTO TipoProd (Nome_TipoProd)
VALUES
  ('Primeira Linha'),
  ('Segunda Linha'),
  ('Terceira Linha'),
  ('Quarta Linha'),
  ('Quinta Linha')

;


INSERT INTO Produto (Cod_TipoProd, Nome_Prod, Val_UnitProd, Val_Total)
VALUES
  (1, 'Armário Inox', 1000, 1200),
  (1, 'Armário Madeira', 1000, 2200),
  (2, 'Armário Metal', 1000, 200),
  (1, 'Mesa Vidro', 100, 1500),
  (3, 'Mesa Fórmica', 1000, 200),
  (2, 'Mesa Madeira', 1000, 800),
  (1, 'Sofa Couro', 500, 2200),
  (2, 'Sofa Napa', 500, 200),
  (1, 'Estante Madeira', 500, 12200),
  (1, 'Cama', 500, 1200),
  (1, 'Geladeira', 500, 3200),
  (1, 'Fogão', 500, 700)

;

CALL P_GeraDadosItens(1, 100, 1);

CALL P_GeraDadosItens(101, 200, 2);

CALL P_GeraDadosItens(201, 300, 2);

CALL P_GeraDadosItens(301, 400, 2);

CALL P_GeraDadosItens(401, 10000, 3);

CALL P_GeraDadosItens(10001, 10000, 4);

/****************************************************************************/
/* Verificando a Criação da Tabelas do Database SYSAMPLES                   */
/****************************************************************************/

SELECT *
FROM Information_Schema.Tables
WHERE Table_Type = 'Base Table';

/****************************************************************************/

SELECT * FROM Bonus;
SELECT * FROM Cidade;
SELECT * FROM Cliente;
SELECT * FROM Conjuge;
SELECT * FROM Credito;
SELECT * FROM Dependente;
SELECT * FROM EMail;
SELECT * FROM Endereco;
SELECT * FROM Estado;
SELECT * FROM Fone;
SELECT * FROM Funcionario;
SELECT * FROM Historico;
SELECT * FROM Itens;
SELECT * FROM Parcela;
SELECT * FROM Pedido;
SELECT * FROM Pontuacao;
SELECT * FROM Produto;
SELECT * FROM StatusPedido;
SELECT * FROM TipoCli;
SELECT * FROM TipoEnd;
SELECT * FROM TipoProd;

/****************************************************************************/

SELECT COUNT(*) FROM Bonus;
SELECT COUNT(*) FROM Cidade;
SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM Conjuge;
SELECT COUNT(*) FROM Credito;
SELECT COUNT(*) FROM Dependente;
SELECT COUNT(*) FROM EMail;
SELECT COUNT(*) FROM Endereco;
SELECT COUNT(*) FROM Estado;
SELECT COUNT(*) FROM Fone;
SELECT COUNT(*) FROM Funcionario;
SELECT COUNT(*) FROM Historico;
SELECT COUNT(*) FROM Itens;
SELECT COUNT(*) FROM Parcela;
SELECT COUNT(*) FROM Pedido;
SELECT COUNT(*) FROM Pontuacao;
SELECT COUNT(*) FROM Produto;
SELECT COUNT(*) FROM StatusPedido;
SELECT COUNT(*) FROM TipoCli;
SELECT COUNT(*) FROM TipoEnd;
SELECT COUNT(*) FROM TipoProd;

