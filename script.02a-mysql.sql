
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

  ALTER TABLE Funcionario
  NOCHECK CONSTRAINT CH_Func1

  INSERT INTO Funcionario
  VALUES
    ('Antonio Antonino Antones', '01/02/00', 'M', 1500.00, 'Rua A '),
    ('Amaro Merico Vespucio', '02/02/00', 'M', 2500.00, 'Rua B'),
    ('Abílio Abel Garcia', '03/02/01', 'M', 1000.00, 'Rua C'),
    ('Bia Bianca Bones', '04/03/01', 'F', 5000.25, 'Rua D'),
    ('Beatriz Bertioga', '05/05/01', 'F', 300.00, 'Rua E'),
    ('Caio Cesar Cearez', '06/05/01', 'M', 250.00, 'Rua F'),
    ('Celso Cesare', '07/06/01', 'M', 1542.36, 'Rua J'),
    ('Danilo Douglas', '08/06/01', 'M', 1524.56, 'Rua K'),
    ('Denis Denilo', '09/07/01', 'M', 5235.56, 'Rua L'),
    ('Everton Evaristo', '10/07/01', 'M', 2542.25, 'Rua M'),
    ('Evanir Eva', '11/08/01', 'M', 4523.54, 'Rua N'),
    ('Fabio Fabricio', '12/08/01', 'M', 1524.25, 'Rua O'),
    ('Fabiola Fabiolo', '02/01/02', 'F', 2554.25, 'Rua P'),
    ('Geraldo ;mes', '03/010/02', 'M', 1542.25, 'Rua Q'),
    ('Helio Heliópolis', '04/01/02', 'M', 1542.23, 'Rua R'),
    ('Irineu Irene', '05/02/02', 'M', 2523.00, 'Rua S'),
    ('Jonas jackes', '05/02/02', 'M', 2500.00, 'Rua T'),
    ('Leandro La;', '06/02/02', 'M', 1500.00, 'Rua U'),
    ('Lucio Lacio', '07/03/02', 'M', 2500.00, 'Rua V'),
    ('Lecio Licio', '08/04/02', 'M', 1420.00, 'Rua X'),
    ('Mario Mendes', '06/02/02', 'M', 1262.00, 'Rua W'),
    ('Olavo Odavlas', '07/07/02', 'M', 1540.00, 'Rua Y')

    ;

  ALTER TABLE Funcionario
  CHECK CONSTRAINT CH_Func1

END//


/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosBonus
  @Val_Bonus decimal(10,2)
BEGIN

  ALTER TABLE Bonus
  NOCHECK CONSTRAINT CH_Bonus1;

  DECLARE @Cod_Func int;
  DECLARE Cursor_Funcionario CURSOR FOR
    SELECT Cod_Func FROM Funcionario;

  OPEN Cursor_Funcionario;

  FETCH NEXT
  FROM Cursor_Funcionario
  INTO @Cod_Func;

  WHILE @@Fetch_Status = 0
  BEGIN

   INSERT INTO Bonus(Cod_Func, Data_Bonus, Val_Bonus)
   VALUES (@Cod_Func, getdate()-30, @Val_Bonus);

   FETCH NEXT
   FROM Cursor_Funcionario
   INTO @Cod_Func;

  END

  DEALLOCATE Cursor_Funcionario;

  ALTER TABLE Bonus
  NOCHECK CONSTRAINT CH_Bonus1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosPontuacao(
  @Val_Pontos decimal(10, 2),
  @Cod_Func1 int,
  @Cod_Func2 int)
BEGIN

  ALTER TABLE Pontuacao
  NOCHECK CONSTRAINT CH_Pto1;

  DECLARE @Cod_Func int;
  DECLARE Cursor_Funcionario CURSOR FOR
    SELECT Cod_Func
    FROM Funcionario
    WHERE Cod_Func BETWEEN @Cod_Func1 AND @Cod_Func2;

  OPEN Cursor_Funcionario;

  FETCH NEXT
  FROM Cursor_Funcionario
  INTO @Cod_Func;

  WHILE (@@Fetch_Status = 0)
  BEGIN

    INSERT INTO Pontuacao (Cod_Func, Data_Pto, Pto_Func)
    VALUES (@Cod_Func, getdate()-30, @Val_Pontos);

    FETCH NEXT
    FROM Cursor_Funcionario
    INTO @Cod_Func;

  END;

  DEALLOCATE Cursor_Funcionario;

  ALTER TABLE Pontuacao
  NOCHECK CONSTRAINT CH_Pto1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosHistorico()
BEGIN

  ALTER TABLE Historico
  NOCHECK CONSTRAINT CH_Hist1;

  INSERT INTO Historico
    SELECT Cod_Func, Getdate() - 30, Convert(Decimal(10,2), Sal_Func / 2), Sal_Func
    FROM Funcionario;

  ALTER TABLE Historico
  CHECK CONSTRAINT CH_Hist1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosPedido
BEGIN

  ALTER TABLE Pedido
  NOCHECK CONSTRAINT CH_Pedido1, FK_Pedido1, FK_Pedido2;

  DECLARE @Cod_Func int;
  DECLARE @Cod_Cli int;
  DECLARE @Cod_Sta int;
  DECLARE @Data Varchar(255);
  DECLARE @DataPed smalldatetime;
  DECLARE @Cod_CliLim int;
  DECLARE @Cod_StaLim int;
  DECLARE @Cod_FuncLim int;

  SELECT @Cod_FuncLim = Max(Cod_Func)
  FROM Funcionario;

  SELECT @Cod_CliLim = Max(Cod_Cli)
  FROM Cliente;

  SELECT @Cod_StaLim = Max(Cod_Sta)
  FROM StatusPedido;

  SET @Cod_Func = 1;
  SET @Cod_Cli = 1;
  SET @Cod_Sta = 1;

  WHILE @Cod_Func < @Cod_FuncLim
  BEGIN

    WHILE @Cod_Cli < @Cod_CliLim
    BEGIN

      WHILE @Cod_Sta <= @Cod_StaLim
      BEGIN

        SET @Data = CONVERT(Char(02), MONTH(DATEADD(mm, @Cod_Sta * 2, Getdate())));
        SET @Data = @Data + '/' + CONVERT(Char(02), DAY(GETDATE() - @Cod_Sta * 3));
        SET @Data = @Data + '/' + CONVERT(Char(04), YEAR(DATEADD(YY, -1 * @Cod_Sta, GETDATE())));
        SET @DataPed = Convert(smalldatetime, @Data);

        INSERT INTO Pedido
        VALUES (@Cod_Cli, @Cod_Func, @Cod_Sta, @Data, 100 * @Cod_Cli);

        SET @Cod_Sta = @Cod_Sta + 1;

      END

      SET @Cod_Cli = @Cod_Cli + 1;
      SET @Cod_Sta = 1;

    END

    SET @Cod_Func = @Cod_Func + 1;
    SET @Cod_Cli = 1;

  END

  ALTER TABLE Pedido
  NOCHECK CONSTRAINT CH_Pedido1, FK_Pedido1, FK_Pedido2;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_Parcelas (
  @Val_Lim1 decimal(10,2),
  @Val_Lim2 decimal(10,2),
  @NumPar int)
BEGIN

  ALTER TABLE PARCELA
  NOCHECK CONSTRAINT CH_Parcela1;

  DECLARE @Tabela TABLE (
    Linha int identity,
    Num_Par smallint,
    Num_Ped int,
    Data_Venc smalldatetime,
    Val_Ped decimal(10,2),
    Val_Par decimal(10,2),
    Data_Pgto smalldatetime,
    Val_Pgto decimal(10,2));

  DECLARE @Cont int;
  DECLARE @TotLim int;
  DECLARE @Cont2 int;

  SET @Cont = 1;
  SET @Cont2 = 1;

  INSERT INTO @Tabela
    SELECT null, Num_Ped, Data_Ped, Val_Ped, Convert(Decimal(10,2), Val_Ped / 3), null, null
    FROM PEDIDO
    WHERE Val_Ped between @Val_Lim1 AND @Val_Lim2;

  SELECT @TotLim = Count(*)
  from @Tabela;

  WHILE @Cont <= @TotLim
  BEGIN

    WHILE @Cont2 <= @NumPar
    BEGIN

      UPDATE @Tabela
      SET Num_Par = @Cont2,
        Data_Venc = Data_Venc + @Cont2,
        Val_Pgto = Val_Par,
        Data_Pgto = Data_Venc
      WHERE Linha = @Cont;

      SET @Cont2 = @Cont2 + 1;
      SET @Cont = @Cont + 1;

    END

    SET @Cont2 = 1;

  END

  INSERT INTO Parcela
    SELECT Num_Par, Num_Ped,
    Data_Venc,Val_Par,Data_Pgto
    FROM @Tabela;

  ALTER TABLE PARCELA
  CHECK CONSTRAINT CH_Parcela1;

END//

/****************************************************************************/
/****************************************************************************/

CREATE PROCEDURE P_GeraDadosItens (
  @Cod1 int,
  @Cod2 int,
  @Qtd int)
BEGIN

  INSERT INTO Itens
    SELECT Pedido.Num_Ped, Produto.Cod_Prod, @Qtd, Produto.Val_UnitProd
    FROM Pedido
    CROSS JOIN Produto
    WHERE Pedido.Num_Ped BETWEEN @Cod1 AND @Cod2;

END//

/****************************************************************************/
/* Inserindo dados diretamente nas tabelas e com a execução das procedures  */
/* criadas anteriormente neste script                                       */
/****************************************************************************/

INSERT INTO TipoEnd VALUES ('Entrega');
INSERT INTO TipoEnd VALUES ('Faturamento');
INSERT INTO TipoEnd VALUES ('Correspondência');
INSERT INTO TipoEnd VALUES ('Cobrança');
INSERT INTO TipoEnd VALUES ('Residential');
INSERT INTO TipoEnd VALUES ('Comercial');

INSERT INTO Estado VALUES ('AC','Acre');
INSERT INTO Estado VALUES ('AL','Alagoas');
INSERT INTO Estado VALUES ('AM','Amazonas');
INSERT INTO Estado VALUES ('AP','Amapa');
INSERT INTO Estado VALUES ('BA','Bahia');
INSERT INTO Estado VALUES ('CE','Ceará');
INSERT INTO Estado VALUES ('DF','Destrito Federal');
INSERT INTO Estado VALUES ('ES','Espirito Santo');
INSERT INTO Estado VALUES ('GO','Goias');
INSERT INTO Estado VALUES ('MA','Maranhão');
INSERT INTO Estado VALUES ('MG','Minas Gerais');
INSERT INTO Estado VALUES ('MS','Mato Grosso do Sul');
INSERT INTO Estado VALUES ('MT','Mato Grosso do Norte');
INSERT INTO Estado VALUES ('PB','Paraíba');
INSERT INTO Estado VALUES ('PE','Pernambuco');
INSERT INTO Estado VALUES ('PI','Piauí');
INSERT INTO Estado VALUES ('PR','Paraná');
INSERT INTO Estado VALUES ('RJ','Rio de Janeiro');
INSERT INTO Estado VALUES ('RN','Rio Grande do Norte');
INSERT INTO Estado VALUES ('RO','Rondônia');
INSERT INTO Estado VALUES ('RR','Roraima');
INSERT INTO Estado VALUES ('RS','Rio Grande do Sul');
INSERT INTO Estado VALUES ('SC','Santa Catarina');
INSERT INTO Estado VALUES ('SE','Sergipe');
INSERT INTO Estado VALUES ('SP','São Paulo');
INSERT INTO Estado VALUES ('TO','Tocantins');


INSERT INTO Cidade VALUES ('SP','Araraquara');
INSERT INTO Cidade VALUES ('SP','Americana');
INSERT INTO Cidade VALUES ('SP','Araçatuba');
INSERT INTO Cidade VALUES ('SP','Fernandópolis');
INSERT INTO Cidade VALUES ('SP','Jundiaí');
INSERT INTO Cidade VALUES ('SP','Sorocaba');
INSERT INTO Cidade VALUES ('SP','São José do Rio Preto');


INSERT INTO TipoCli VALUES ('Diamante');
INSERT INTO TipoCli VALUES ('Ouro');
INSERT INTO TipoCli VALUES ('Prata');
INSERT INTO TipoCli VALUES ('Bronze');
INSERT INTO TipoCli VALUES ('Cobre');
INSERT INTO TipoCli VALUES ('Zinco');

INSERT INTO Cliente VALUES (1,'João Carlos','01/01/1999',10000,'M');
INSERT INTO Cliente VALUES (1,'Daniel Souza','02/02/1999',10000,'M');
INSERT INTO Cliente VALUES (1,'Helena Oliveira','03/03/1999',9000,'F');
INSERT INTO Cliente VALUES (1,'Roberta Oliveira','04/04/1999',8000,'F');
INSERT INTO Cliente VALUES (2,'Renata Leão','05/05/1999',5000,'F');
INSERT INTO Cliente VALUES (2,'Jairo Gato','06/06/1999',4000,'M');
INSERT INTO Cliente VALUES (3,'Fernando Gato','07/07/1999',3000,'M');
INSERT INTO Cliente VALUES (3,'Giovanna Silva Leão','08/08/1999',3000,'F');
INSERT INTO Cliente VALUES (4,'Lucas Ribeiro','09/09/1999',2000,'M');
INSERT INTO Cliente VALUES (3,'Helder Leão','10/10/1999',2000,'M');
INSERT INTO Cliente VALUES (2,'Olga Cristina Bonfiglioli','11/11/1999',8000,'F');
INSERT INTO Cliente VALUES (1,'Maria Cristina Bonfiglioli Martins de Souza Santos','12/12/1999',5000,'F');
INSERT INTO Cliente VALUES (1,'Salvador Eneas Feredico','01/13/1999',9000,'M');
INSERT INTO Cliente VALUES (1,'Dolores Gerreiro Martins','02/14/2000',8000,'F');
INSERT INTO Cliente VALUES (1,'Fabiana Bataglin','03/15/2000',5000,'F');
INSERT INTO Cliente VALUES (2,'Aparecida Ribeiro','04/16/2000',3000,'F');
INSERT INTO Cliente VALUES (3,'Reginaldo Ribeiro','05/17/2000',4000,'M');
INSERT INTO Cliente VALUES (4,'Suellen M Nunes','06/18/2000',3000,'F');
INSERT INTO Cliente VALUES (1,'Carlos Alberto','07/19/2000',2000,'M');
INSERT INTO Cliente VALUES (2,'Roberto Arruda','08/20/2000',1000,'M');
INSERT INTO Cliente VALUES (3,'Sandra Medeiros','09/21/2000',1500,'F');
INSERT INTO Cliente VALUES (4,'Alice Santos','10/22/2001',2500,'F');
INSERT INTO Cliente VALUES (5,'Valter Sanches','11/23/2001',3500,'M');
INSERT INTO Cliente VALUES (6,'Pascoal Babiera','12/24/2001',1525,'M');
INSERT INTO Cliente VALUES (1,'Lucia Bacalla','01/25/2001',6321,'F');
INSERT INTO Cliente VALUES (3,'Maria Belido','02/26/2001',5412,'F');
INSERT INTO Cliente VALUES (4,'Hamilton Belico','03/26/2001',2563,'M');
INSERT INTO Cliente VALUES (5,'Alberto Belli','04/27/2001',2412,'M');
INSERT INTO Cliente VALUES (6,'Marcia Bueno','05/28/2001',1235,'F');
INSERT INTO Cliente VALUES (1,'Maria Catta','06/29/2001',1236,'F');
INSERT INTO Cliente VALUES (2,'Carlos Cattaneo','07/30/2001',1253,'M');
INSERT INTO Cliente VALUES (3,'Andre Caula','08/31/2001',1524,'M');
INSERT INTO Cliente VALUES (4,'Fabia Dávello','09/01/2001',1236,'F');
INSERT INTO Cliente VALUES (5,'Afonso Ferraro','10/02/2001',1256,'M');
INSERT INTO Cliente VALUES (6,'Akemi Fukamizu','11/03/2001',1452,'F');
INSERT INTO Cliente VALUES (1,'Bernadino ;mes','12/04/2001',11785,'M');
INSERT INTO Cliente VALUES (2,'Regiani Hoki','01/05/2001',1524,'F');
INSERT INTO Cliente VALUES (3,'Valter Koszura','02/06/2001',1256,'M');
INSERT INTO Cliente VALUES (4,'Alexandre Kozeki','03/07/2001',1225,'M');
INSERT INTO Cliente VALUES (5,'Vittorio Lannocca','04/08/2001',1253,'M');
INSERT INTO Cliente VALUES (6,'Domin;s Lanini','05/09/2002',1253,'M');
INSERT INTO Cliente VALUES (1,'Paulo Mello','06/10/2001',10000,'M');
INSERT INTO Cliente VALUES (2,'Zilda Mellone','07/11/2001',8000,'F');
INSERT INTO Cliente VALUES (3,'Marlene Moura','08/12/2001',3000,'F');
INSERT INTO Cliente VALUES (4,'Francisca Oliveira','09/13/2001',2300,'F');
INSERT INTO Cliente VALUES (5,'Marlene Pereira','10/14/2001',2562,'F');
INSERT INTO Cliente VALUES (6,'Milton Pereira','11/15/2001',2563,'M');
INSERT INTO Cliente VALUES (1,'Ligia Ramos','12/16/2001',9200,'F');
INSERT INTO Cliente VALUES (2,'Mariangela Ramos','01/17/2001',7000,'F');
INSERT INTO Cliente VALUES (3,'Dora Romariz','02/18/2001',5263,'F');
INSERT INTO Cliente VALUES (4,'Paulino Romelli','03/19/2001',5428,'M');
INSERT INTO Cliente VALUES (5,'Fernando Sampaio','04/20/2001',2023,'M');
INSERT INTO Cliente VALUES (6,'José Sampaio','05/21/2001',2235,'M');
INSERT INTO Cliente VALUES (1,'Vicenzo Senatori','06/22/2001',7000,'M');
INSERT INTO Cliente VALUES (2,'Geraldo Senedeze','07/23/2001',2531,'M');
INSERT INTO Cliente VALUES (3,'Mauro Soares','08/24/2001',2532,'M');
INSERT INTO Cliente VALUES (4,'Paulo Souza','09/25/2001',2542,'M');
INSERT INTO Cliente VALUES (5,'Emidio Trifoni','10/26/2001',2563,'M');
INSERT INTO Cliente VALUES (6,'Heitor Vernile','11/27/2001',2542,'M');
INSERT INTO Cliente VALUES (1,'Carlos Saura','12/28/2001',6000,'M');
INSERT INTO Cliente VALUES (2,'Angelino Saullo','01/29/2001',5000,'M');
INSERT INTO Cliente VALUES (3,'Aldo Savazzoni','02/28/2001',4000,'M');


INSERT INTO Conjuge VALUES (1,'Renata',3000.00,'F');
INSERT INTO Conjuge VALUES (2,'Helena',5000.00,'F');
INSERT INTO Conjuge VALUES (3,'Daniel',6000.00,'M');
INSERT INTO Conjuge VALUES (4,'Tarcisio',1000.00,'M');
INSERT INTO Conjuge VALUES (5,'João Carlos',7000.00,'M');
INSERT INTO Conjuge VALUES (6,'Carla',9000.00,'M');
INSERT INTO Conjuge VALUES (7,'Ana Lucia',3000.00,'F');


INSERT INTO Endereco VALUES (1,1,1,'Rua Soraia - 29','Vila Santana',null);
INSERT INTO Endereco VALUES (2,1,1,'Rua Macunaima - 192','Jd.Europa',null);
INSERT INTO Endereco VALUES (1,1,2,'Rua Mariá - 342','Jd. Araguaia','Apto. 23');
INSERT INTO Endereco VALUES (2,2,2,'Rua Juca - 542','Vila Catarina ','Apto. 2');
INSERT INTO Endereco VALUES (2,2,3,'Pça Marcondes - 542','Vila Tereza ',null);
INSERT INTO Endereco VALUES (3,1,4,'Rua Santa Catarina - 1342','Vila Osvaldo Cruz',null);
INSERT INTO Endereco VALUES (1,1,1,'Av. Imirim, 325','Vila Vilma',null);
INSERT INTO Endereco VALUES (1,1,2,'Rua Clélia, 456','Vila Zoraide',null);
INSERT INTO Endereco VALUES (1,1,3,'Rua Pio XI, 938','Jd. América',null);
INSERT INTO Endereco VALUES (2,1,4,'Travessa 15, 1200','Vila Sonia',null);
INSERT INTO Endereco VALUES (2,2,5,'Av. Sodré, 392','Jd. Carnaúba',null);
INSERT INTO Endereco VALUES (2,3,6,'Av Mutinga, 200','Parque das Flores',null);
INSERT INTO Endereco VALUES (3,2,7,'Rua Cons. Ribas 594','Parque Municipal',null);
INSERT INTO Endereco VALUES (3,2,8,'Rua Maria Belido','Parque Industrial',null);
INSERT INTO Endereco VALUES (3,2,9,'Rua Avai 164','Vila Maria',null);
INSERT INTO Endereco VALUES (4,2,10,'Rua Bororós, 67','Vila Santa Terezinha',null);
INSERT INTO Endereco VALUES (4,2,11,'Rua Jose Pereira, 340','Zona da Mata',null);
INSERT INTO Endereco VALUES (4,3,12,'Av. Casa Verde, 450','Jd. Botucatu',null);
INSERT INTO Endereco VALUES (4,4,13,'Av Dr ;uveia, 392','Jd. Moricatupotá',null);
INSERT INTO Endereco VALUES (5,3,14,'Rua Lucena 184','Jd. Canhem BaBa',null);
INSERT INTO Endereco VALUES (5,3,15,'Av. Indianópolis 593','Vila Angela',null);
INSERT INTO Endereco VALUES (5,3,16,'Rua Alexandre Duma 486','Parque Piributa',null);
INSERT INTO Endereco VALUES (6,3,17,'Rua Maria Júlia 1207','Jd. Americanópolis',null);
INSERT INTO Endereco VALUES (6,3,18,'Rua Afonso Meira, 948','Parque Cruzeiro do Sul',null);
INSERT INTO Endereco VALUES (6,3,19,'Rua Bela Cintra 392','Vila Saturno',null);
INSERT INTO Endereco VALUES (6,4,20,'Rua Basilio 199','Jardim Jupter',null);
INSERT INTO Endereco VALUES (1,4,21,'Rua Doce 32','Praça Marte',null);
INSERT INTO Endereco VALUES (1,4,22,'Rua Grumix 114','Lar; de Netuno',null);
INSERT INTO Endereco VALUES (1,4,23,'Rua Emilia 32','Area de Plutão',null);
INSERT INTO Endereco VALUES (1,4,24,'Al Jurupis 900','Vila Lua Branca',null);
INSERT INTO Endereco VALUES (1,4,25,'Av. Guedes 653','Parque Urano',null);
INSERT INTO Endereco VALUES (2,5,26,'Rua Neves 430','Jd. Paraiso',null);
INSERT INTO Endereco VALUES (2,5,27,'Av. Mario Zonta, 180','Terra Prometida',null);
INSERT INTO Endereco VALUES (2,5,28,'Rua Florida, 430','Jd. das Flores',null);
INSERT INTO Endereco VALUES (3,5,29,'Av. Jose Barroso, 305','Praça das Margaridas',null);
INSERT INTO Endereco VALUES (3,5,30,'Rua Mirina, 38','Zona Franca',null);
INSERT INTO Endereco VALUES (4,5,31,'Rua Iagaraí, 46','Jd. Brasileiro',null);
INSERT INTO Endereco VALUES (4,5,32,'Rua Paulista, 251','Jd. MMDC',null);
INSERT INTO Endereco VALUES (4,2,33,'Rua Salete, 320','Jd. Sales Garcia',null);
INSERT INTO Endereco VALUES (5,1,34,'Rua Souza, 115','Vila Sonia',null);
INSERT INTO Endereco VALUES (5,1,35,'Rua Alcion, 604','Parque Piraque',null);
INSERT INTO Endereco VALUES (5,1,36,'Av. Sabará, 987','Parque Piqueri',null);
INSERT INTO Endereco VALUES (6,2,37,'Rua Oscar Freire, 453','Parque Infantil',null);
INSERT INTO Endereco VALUES (6,2,38,'Av. Amaral Gama, 58','Jardim Judas',null);
INSERT INTO Endereco VALUES (6,2,39,'Rua Iru, 23','Jd. São Salvador',null);
INSERT INTO Endereco VALUES (1,2,40,'Rua Silvia, 560','Vila Pau Brasil',null);
INSERT INTO Endereco VALUES (1,2,41,'Rua Moura, 147','Vila Viela',null);
INSERT INTO Endereco VALUES (1,3,42,'Rua Aroeir, 954','Vila Amarela',null);
INSERT INTO Endereco VALUES (1,3,43,'Rua Pereira, 394','Vila Verde',null);
INSERT INTO Endereco VALUES (2,3,44,'Rua Galeão, 54','Vila Branca',null);


INSERT INTO Credito VALUES (1,1000.00,Getdate()-30);
INSERT INTO Credito VALUES (1,2000.00,Getdate()-29);
INSERT INTO Credito VALUES (1,3000.00,Getdate()-28);
INSERT INTO Credito VALUES (2,1000.00,Getdate()-27);
INSERT INTO Credito VALUES (3,1000.00,Getdate()-26);
INSERT INTO Credito VALUES (4,1000.00,Getdate()-25);
INSERT INTO Credito VALUES (5,1000.00,Getdate()-24);
INSERT INTO Credito VALUES (6,1000.00,Getdate()-23);
INSERT INTO Credito VALUES (7,1000.00,Getdate()-22);
INSERT INTO Credito VALUES (8,1000.00,Getdate()-21);
INSERT INTO Credito VALUES (9,1000.00,Getdate()-20);
INSERT INTO Credito VALUES (10,1000.00,Getdate()-19);
INSERT INTO Credito VALUES (11,1000.00,Getdate()-18);
INSERT INTO Credito VALUES (12,1000.00,Getdate()-17);
INSERT INTO Credito VALUES (13,1000.00,Getdate()-16);
INSERT INTO Credito VALUES (14,1000.00,Getdate()-15);
INSERT INTO Credito VALUES (15,1000.00,Getdate()-14);
INSERT INTO Credito VALUES (16,1000.00,Getdate()-13);
INSERT INTO Credito VALUES (17,1000.00,Getdate()-12);
INSERT INTO Credito VALUES (18,1000.00,Getdate()-11);
INSERT INTO Credito VALUES (19,1000.00,Getdate()-10);
INSERT INTO Credito VALUES (20,1000.00,Getdate()-9);
INSERT INTO Credito VALUES (21,1000.00,Getdate()-8);
INSERT INTO Credito VALUES (22,1000.00,Getdate()-7);
INSERT INTO Credito VALUES (23,1000.00,Getdate()-6);
INSERT INTO Credito VALUES (24,1000.00,Getdate()-5);
INSERT INTO Credito VALUES (25,1000.00,Getdate()-4);
INSERT INTO Credito VALUES (26,1000.00,Getdate()-3);
INSERT INTO Credito VALUES (27,1000.00,Getdate()-2);
INSERT INTO Credito VALUES (28,1000.00,Getdate()-1);
INSERT INTO Credito VALUES (29,1000.00,Getdate()-30);
INSERT INTO Credito VALUES (30,1000.00,Getdate()-29);
INSERT INTO Credito VALUES (31,1000.00,Getdate()-28);
INSERT INTO Credito VALUES (32,1000.00,Getdate()-27);
INSERT INTO Credito VALUES (33,1000.00,Getdate()-26);
INSERT INTO Credito VALUES (34,1000.00,Getdate()-25);
INSERT INTO Credito VALUES (35,1000.00,Getdate()-24);
INSERT INTO Credito VALUES (36,1000.00,Getdate()-23);
INSERT INTO Credito VALUES (37,1000.00,Getdate()-22);
INSERT INTO Credito VALUES (38,1000.00,Getdate()-21);
INSERT INTO Credito VALUES (39,1000.00,Getdate()-20);
INSERT INTO Credito VALUES (40,1000.00,Getdate()-19);
INSERT INTO Credito VALUES (41,1000.00,Getdate()-18);
INSERT INTO Credito VALUES (42,1000.00,Getdate()-17);
INSERT INTO Credito VALUES (43,1000.00,Getdate()-16);
INSERT INTO Credito VALUES (44,1000.00,Getdate()-15);
INSERT INTO Credito VALUES (45,1000.00,Getdate()-14);
INSERT INTO Credito VALUES (46,1000.00,Getdate()-13);
INSERT INTO Credito VALUES (47,1000.00,Getdate()-12);
INSERT INTO Credito VALUES (48,1000.00,Getdate()-11);
INSERT INTO Credito VALUES (49,1000.00,Getdate()-10);
INSERT INTO Credito VALUES (50,1000.00,Getdate()-9);
INSERT INTO Credito VALUES (51,1000.00,Getdate()-8);
INSERT INTO Credito VALUES (52,1000.00,Getdate()-7);
INSERT INTO Credito VALUES (53,1000.00,Getdate()-6);
INSERT INTO Credito VALUES (54,1000.00,Getdate()-5);
INSERT INTO Credito VALUES (55,1000.00,Getdate()-4);
INSERT INTO Credito VALUES (56,1000.00,Getdate()-3);
INSERT INTO Credito VALUES (57,1000.00,Getdate()-2);
INSERT INTO Credito VALUES (58,1000.00,Getdate()-1);
INSERT INTO Credito VALUES (59,1000.00,Getdate()-1);
INSERT INTO Credito VALUES (60,1000.00,Getdate()-2);
INSERT INTO Credito VALUES (61,1000.00,Getdate()-3);

INSERT INTO Fone VALUES (1,'434-2356','011');
INSERT INTO Fone VALUES (1,'256-4578','011');
INSERT INTO Fone VALUES (1,'256-5623','011');
INSERT INTO Fone VALUES (2,'242-9865','011');
INSERT INTO Fone VALUES (2,'323-8945','011');
INSERT INTO Fone VALUES (2,'232-7845','011');
INSERT INTO Fone VALUES (3,'565-2365','011');
INSERT INTO Fone VALUES (3,'454-1254','011');
INSERT INTO Fone VALUES (3,'898-2345','011');
INSERT INTO Fone VALUES (4,'454-1223','011');
INSERT INTO Fone VALUES (4,'787-4512','011');
INSERT INTO Fone VALUES (5,'525-4578','011');
INSERT INTO Fone VALUES (5,'252-9887','011');
INSERT INTO Fone VALUES (6,'578-6521','011');
INSERT INTO Fone VALUES (6,'568-5421','011');
INSERT INTO Fone VALUES (7,'536-3254','011');
INSERT INTO Fone VALUES (8,'568-2154','011');
INSERT INTO Fone VALUES (9,'587-3221','011');
INSERT INTO Fone VALUES (10,'863-6598','011');
INSERT INTO Fone VALUES (11,'138-8754','011');
INSERT INTO Fone VALUES (12,'123-6598','011');
INSERT INTO Fone VALUES (13,'321-6357','011');
INSERT INTO Fone VALUES (14,'301-1232','011');
INSERT INTO Fone VALUES (15,'321-4512','011');
INSERT INTO Fone VALUES (16,'333-3221','011');
INSERT INTO Fone VALUES (17,'555-4578','011');
INSERT INTO Fone VALUES (18,'666-1245','011');
INSERT INTO Fone VALUES (19,'777-3265','011');
INSERT INTO Fone VALUES (20,'888-2154','011');
INSERT INTO Fone VALUES (21,'999-1111','015');
INSERT INTO Fone VALUES (21,'202-1222','015');
INSERT INTO Fone VALUES (22,'254-3333','015');
INSERT INTO Fone VALUES (23,'458-4444','015');
INSERT INTO Fone VALUES (23,'874-5555','015');
INSERT INTO Fone VALUES (24,'313-6666','015');
INSERT INTO Fone VALUES (24,'587-7777','015');
INSERT INTO Fone VALUES (25,'589-8888','015');
INSERT INTO Fone VALUES (26,'999-9999','015');
INSERT INTO Fone VALUES (27,'999-1010','015');
INSERT INTO Fone VALUES (27,'111-1111','015');
INSERT INTO Fone VALUES (28,'222-1212','015');
INSERT INTO Fone VALUES (28,'333-1313','015');
INSERT INTO Fone VALUES (28,'444-1414','015');
INSERT INTO Fone VALUES (29,'555-1515','015');
INSERT INTO Fone VALUES (29,'666-1616','015');
INSERT INTO Fone VALUES (30,'777-1717','015');
INSERT INTO Fone VALUES (31,'888-1818','015');
INSERT INTO Fone VALUES (32,'999-1919','015');
INSERT INTO Fone VALUES (33,'101-2020','015');
INSERT INTO Fone VALUES (34,'555-2121','021');
INSERT INTO Fone VALUES (35,'333-2222','021');
INSERT INTO Fone VALUES (36,'717-2323','021');
INSERT INTO Fone VALUES (37,'656-2424','021');
INSERT INTO Fone VALUES (38,'374-2525','021');
INSERT INTO Fone VALUES (39,'859-2626','021');
INSERT INTO Fone VALUES (40,'222-2727','021');
INSERT INTO Fone VALUES (41,'256-2828','021');
INSERT INTO Fone VALUES (42,'542-2929','021');
INSERT INTO Fone VALUES (43,'578-3030','021');
INSERT INTO Fone VALUES (44,'896-4041','021');
INSERT INTO Fone VALUES (45,'369-5050','021');
INSERT INTO Fone VALUES (46,'132-5151','021');
INSERT INTO Fone VALUES (47,'321-6161','021');
INSERT INTO Fone VALUES (48,'542-7171','011');
INSERT INTO Fone VALUES (49,'201-8181','011');
INSERT INTO Fone VALUES (50,'301-9191','011');
INSERT INTO Fone VALUES (50,'401-1919','011');
INSERT INTO Fone VALUES (50,'501-1818','011');
INSERT INTO Fone VALUES (51,'601-1212','011');
INSERT INTO Fone VALUES (52,'701-1313','011');
INSERT INTO Fone VALUES (53,'801-1414','011');
INSERT INTO Fone VALUES (54,'901-1515','011');
INSERT INTO Fone VALUES (56,'222-1616','011');
INSERT INTO Fone VALUES (56,'333-1714','011');
INSERT INTO Fone VALUES (57,'111-1818','011');
INSERT INTO Fone VALUES (58,'444-1919','011');
INSERT INTO Fone VALUES (59,'222-2020','011');
INSERT INTO Fone VALUES (62,'333-2121','011');

INSERT INTO Email VALUES (1,'Joaobrasao@Hotmail.com');
INSERT INTO Email VALUES (1,'Joaobrasao@bbb.com.br');
INSERT INTO Email VALUES (1,'Joaobrasao@xxx.com.br');
INSERT INTO Email VALUES (1,'JoaoCarloss@Globo.com.br');
INSERT INTO Email VALUES (2,'DanielLeao@uol.com.br');
INSERT INTO Email VALUES (3,'HOL@Hotmail.com');
INSERT INTO Email VALUES (4,'ROL@Hotmail.com');
INSERT INTO Email VALUES (5,'RenataLeao01@Hotmail.com');
INSERT INTO Email VALUES (5,'Renata.Leao@Globo.com');
INSERT INTO Email VALUES (6,'JairoGato@Bol.com.br');
INSERT INTO Email VALUES (7,'FernandoLeao@Hotmil.com');
INSERT INTO Email VALUES (8,'GiGi_Leao@Hotmial.com');
INSERT INTO Email VALUES (9,'Lucas_Leao@Hotmail.com');
INSERT INTO Email VALUES (10,'HelderLeão@Hotmail.com');
INSERT INTO Email VALUES (11,'OlgaCBonfiglioli@Hotmail.com');
INSERT INTO Email VALUES (12,'MCBMSS@Hotmail.com');
INSERT INTO Email VALUES (13,'SEFeredico@Hotmail.com');
INSERT INTO Email VALUES (14,'DoloresGMartins@Hotmail.com');
INSERT INTO Email VALUES (15,'Fabiana_Bataglin@Hotmail.com');
INSERT INTO Email VALUES (28,'Alberto_Belli@Hotmail.com');
INSERT INTO Email VALUES (29,'Marcia_Bueno@Hotmail.com');
INSERT INTO Email VALUES (30,'MariaCatta@Hotmail.com');
INSERT INTO Email VALUES (38,'ValterKoszura@Hotmail.com');
INSERT INTO Email VALUES (51,'PaulinoRomelli@Hotmail.com');
INSERT INTO Email VALUES (52,'Fernando Sampaio');
INSERT INTO Email VALUES (53,'JoséSampaio@uol.com.br');
INSERT INTO Email VALUES (54,'VicenzoSenatori@uol.com.br');
INSERT INTO Email VALUES (55,'GeraldoSenedeze@uol.com.br');
INSERT INTO Email VALUES (61,'AngelinoSaullo@uol.com.br');
INSERT INTO Email VALUES (62,'AldoSavazzoni@uol.com.br');

INSERT INTO StatusPedido VALUES ('Aberto');
INSERT INTO StatusPedido VALUES ('Pendente');
INSERT INTO StatusPedido VALUES ('Fechado');
INSERT INTO StatusPedido VALUES ('Cancelado');

Exec P_GeraDadosFuncionario();

Exec P_GeraDadosBonus(100.00);

Exec P_GeraDadosBonus(300.00);

Exec P_GeraDadosPontuacao(10,1,10);

Exec P_GeraDadosPontuacao(70,11,22);

Exec P_GeraDadosHistorico();

INSERT INTO Dependente VALUES (3,'Sebastiana Maria','01/02/64','F')
INSERT INTO Dependente VALUES (3,'Sebastião Mario','01/02/64','M')
INSERT INTO Dependente VALUES (4,'Aurea Virtude','01/02/64','F')
INSERT INTO Dependente VALUES (4,'Aureo Visture','01/02/64','M')
INSERT INTO Dependente VALUES (7,'Pedro da Silva','01/02/64','F')
INSERT INTO Dependente VALUES (7,'Alvares da Silva','01/02/64','M')
INSERT INTO Dependente VALUES (7,'Cabral da Silva','01/02/64','M')

;

Exec P_GeraDadosPedido
;

Exec P_Parcelas 0,300,3
;

Exec P_Parcelas 301,400,4
;

Exec P_Parcelas 401,500,5
;

Exec P_Parcelas 501,600,6
;

Exec P_Parcelas 601,700,7
;

Exec P_Parcelas 701,800,8
;

Exec P_Parcelas 801,900,9
;

Exec P_Parcelas 901,10000,10
;

INSERT INTO TipoProd VALUES ('Primeira Linha')
INSERT INTO TipoProd VALUES ('Segunda Linha')
INSERT INTO TipoProd VALUES ('Terceira Linha')
INSERT INTO TipoProd VALUES ('Quarta Linha')
INSERT INTO TipoProd VALUES ('Quinta Linha')

;

INSERT INTO Produto VALUES (1,'Armário Inox',1000,1200)
INSERT INTO Produto VALUES (1,'Armário Madeira',1000,2200)
INSERT INTO Produto VALUES (2,'Armário Metal',1000,200)
INSERT INTO Produto VALUES (1,'Mesa Vidro',100,1500)
INSERT INTO Produto VALUES (3,'Mesa Fórmica',1000,200)
INSERT INTO Produto VALUES (2,'Mesa Madeira',1000,800)
INSERT INTO Produto VALUES (1,'Sofa Couro',500,2200)
INSERT INTO Produto VALUES (2,'Sofa Napa',500,200)
INSERT INTO Produto VALUES (1,'Estante Madeira',500,12200)
INSERT INTO Produto VALUES (1,'Cama',500,1200)
INSERT INTO Produto VALUES (1,'Geladeira',500,3200)
INSERT INTO Produto VALUES (1,'Fogão',500,700)

;

Exec P_GeraDadosItens 1,100,1
;

Exec P_GeraDadosItens 101,200,2
;

Exec P_GeraDadosItens 201,300,2
;

Exec P_GeraDadosItens 301,400,2
;

Exec P_GeraDadosItens 401,10000,3
;

Exec P_GeraDadosItens 10001,10000,4
;

/****************************************************************************/
/* Verificando a Criação da Tabelas do Database SYSAMPLES                   */
/****************************************************************************/

SELECT *
FROM Information_Schema.Tables
WHERE Table_Type = 'Base Table'

/****************************************************************************/

SELECT * FROM Bonus
SELECT * FROM Cidade
SELECT * FROM Cliente
SELECT * FROM Conjuge
SELECT * FROM Credito
SELECT * FROM Dependente
SELECT * FROM EMail
SELECT * FROM Endereco
SELECT * FROM Estado
SELECT * FROM Fone
SELECT * FROM Funcionario
SELECT * FROM Historico
SELECT * FROM Itens
SELECT * FROM Parcela
SELECT * FROM Pedido
SELECT * FROM Pontuacao
SELECT * FROM Produto
SELECT * FROM StatusPedido
SELECT * FROM TipoCli
SELECT * FROM TipoEnd
SELECT * FROM TipoProd

/****************************************************************************/

SELECT count(*) FROM Bonus
SELECT count(*) FROM Cidade
SELECT count(*) FROM Cliente
SELECT count(*) FROM Conjuge
SELECT count(*) FROM Credito
SELECT count(*) FROM Dependente
SELECT count(*) FROM EMail
SELECT count(*) FROM Endereco
SELECT count(*) FROM Estado
SELECT count(*) FROM Fone
SELECT count(*) FROM Funcionario
SELECT count(*) FROM Historico
SELECT count(*) FROM Itens
SELECT count(*) FROM Parcela
SELECT count(*) FROM Pedido
SELECT count(*) FROM Pontuacao
SELECT count(*) FROM Produto
SELECT count(*) FROM StatusPedido
SELECT count(*) FROM TipoCli
SELECT count(*) FROM TipoEnd
SELECT count(*) FROM TipoProd

