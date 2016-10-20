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
/* Criando o Database Exemplo                                               */
/*  Script_01                                                               */
/****************************************************************************/

CREATE DATABASE Exemplo

;

/****************************************************************************/
/* Estabelecendo uma Conexão com o Database Exemplo                         */
/****************************************************************************/

USE Exemplo;

/****************************************************************************/
/* Criando AS tabelas do database SYSAMPLES                                 */
/****************************************************************************/

CREATE TABLE TipoEnd (

  Cod_TipoEnd INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome_TipoEnd VARCHAR(30) NOT NULL,

  CONSTRAINT PK_TipoEnd PRIMARY KEY (Cod_TipoEnd),

  CONSTRAINT UQ_TipoEnd UNIQUE KEY (Nome_TipoEnd)

)
;

CREATE TABLE Estado (

  Sigla_Est CHAR(02) NOT NULL,
  Nome_Est VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Est PRIMARY KEY (Sigla_Est),

  CONSTRAINT UQ_Est UNIQUE KEY (Nome_Est)

)
;

CREATE TABLE Cidade (

  Cod_Cid INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Sigla_Est CHAR(02) NOT NULL,
  Nome_Cid VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Cid PRIMARY KEY (Cod_Cid),

  CONSTRAINT FK_Cid FOREIGN KEY (Sigla_Est) REFERENCES Estado (Sigla_Est),

  CONSTRAINT UQ_Cid UNIQUE KEY (Sigla_Est, Nome_Cid)

)
;

CREATE TABLE TipoCli (

  Cod_TipoCli INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome_TipoCli VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoCli PRIMARY KEY (Cod_TipoCli),

  CONSTRAINT UQ_TipoCli UNIQUE KEY (Nome_TipoCli)

)
;

CREATE TABLE Cliente (

  Cod_Cli INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_TipoCli INT UNSIGNED NOT NULL,
  Nome_Cli VARCHAR(100) NOT NULL,
  Data_CadCli DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Renda_Cli DECIMAL(10,2) NOT NULL DEFAULT 0,
  Sexo_Cli CHAR(01) NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Cli PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Cli FOREIGN KEY (Cod_TipoCli) REFERENCES TipoCli (Cod_TipoCli),

  CONSTRAINT CH_Cli1 CHECK (Renda_Cli >= 0),
  CONSTRAINT CH_Cli2 CHECK (Sexo_Cli IN ('F', 'M'))

)
;

CREATE TABLE Conjuge (

  Cod_Cli INT UNSIGNED NOT NULL,
  Nome_Conj CHAR(30) NOT NULL,
  Renda_Conj DECIMAL(10,2) NOT NULL DEFAULT 0,
  Sexo_Conj CHAR(01) NOT NULL DEFAULT 'M',

  CONSTRAINT PK_Conj PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Conj FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli),

  CONSTRAINT CH_Conj1 CHECK (Renda_Conj >= 0),
  CONSTRAINT CH_Conj2 CHECK (Sexo_Conj IN ('F', 'M'))

)
;

CREATE TABLE Endereco (

  Cod_End INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_TipoEnd INT UNSIGNED NOT NULL,
  Cod_Cid INT UNSIGNED NOT NULL,
  Cod_Cli INT UNSIGNED NOT NULL,
  Nome_Rua VARCHAR(100) NOT NULL,
  Nome_Bairro VARCHAR(100) NOT NULL,
  Compl_End VARCHAR(100) NULL,

  CONSTRAINT PK_End PRIMARY KEY (Cod_End),

  CONSTRAINT FK_End1 FOREIGN KEY (Cod_TipoEnd) REFERENCES TipoEnd (Cod_TipoEnd),
  CONSTRAINT FK_End2 FOREIGN KEY (Cod_Cid) REFERENCES Cidade (Cod_Cid),
  CONSTRAINT FK_End3 FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
;

CREATE TABLE Credito (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Cli INT UNSIGNED NOT NULL,
  Cred_Cli DECIMAL(10,2) NOT NULL,
  Data_CredCli DATETIME NOT NULL,

  CONSTRAINT PK_Cred PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Cred FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli),

  CONSTRAINT CH_Cred CHECK (Cred_Cli > 0)

)
;

CREATE TABLE Fone (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Cli INT UNSIGNED NOT NULL,
  Num_Fone CHAR(10) NOT NULL,
  Num_DDD CHAR(05) NOT NULL DEFAULT '011',

  CONSTRAINT PK_Fone PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Fone FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
;

CREATE TABLE EMail (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Cli INT UNSIGNED NOT NULL,
  EMail_Cli VARCHAR(255) NOT NULL,

  CONSTRAINT PK_Email PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Emails FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
;

CREATE TABLE StatusPedido (

  Cod_Sta SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  Sta_Ped VARCHAR(100) NOT NULL,

  CONSTRAINT PK_StatusPed PRIMARY KEY (Cod_Sta),

  CONSTRAINT UQ_StatusPed UNIQUE KEY (Sta_Ped)

)
;

CREATE TABLE Funcionario (

  Cod_Func INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome_Func VARCHAR(100) NOT NULL,
  Data_CadFunc DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Sexo_Func CHAR(01) NOT NULL DEFAULT 'F',
  Sal_Func DECIMAL(10,2) NOT NULL DEFAULT 200,
  End_Func VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Func PRIMARY KEY (Cod_Func),

  CONSTRAINT CH_Func1 CHECK (Data_CadFunc >= CURDATE()),
  CONSTRAINT CH_Func2 CHECK (Sexo_Func IN ('F', 'M')),
  CONSTRAINT CH_Func3 CHECK (Sal_Func >= 0)

)
;

CREATE TABLE Bonus (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Func INT UNSIGNED NOT NULL,
  Data_Bonus DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Bonus DECIMAL(10,2) NOT NULL,

  CONSTRAINT PK_Bonus PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Bonus FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func),

  CONSTRAINT CH_Bonus1 CHECK (Data_Bonus >= CURDATE()),
  CONSTRAINT CH_Bonus2 CHECK (Val_Bonus > 0)

)
;

CREATE TABLE Pontuacao (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Func INT UNSIGNED NOT NULL,
  Data_Pto DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Pto_Func DECIMAL(4,2) NOT NULL,

  CONSTRAINT PK_Pto PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Pto FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func),

  CONSTRAINT CH_Pto1 CHECK (Data_Pto >= CURDATE()),
  CONSTRAINT CH_Pto2 CHECK (Pto_Func > 0)

)
;

CREATE TABLE Historico (

  Num_Lanc INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Func INT UNSIGNED NOT NULL,
  Data_Hist DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Sal_Ant DECIMAL(10,2) NOT NULL,
  Sal_Atual DECIMAL(10,2) NOT NULL,

  CONSTRAINT PK_Hist PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Hist FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func),

  CONSTRAINT CH_Hist1 CHECK (Data_Hist >= CURDATE()),
  CONSTRAINT CH_Hist2 CHECK (Sal_Ant >= 0),
  CONSTRAINT CH_Hist3 CHECK (Sal_Ant > 0)

)
;

CREATE TABLE Dependente (

  Cod_Dep INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Func INT UNSIGNED NOT NULL,
  Nome_Dep VARCHAR(100) NOT NULL,
  Data_NascDep DATETIME NOT NULL,
  Sexo_Dep CHAR(01) NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Dep PRIMARY KEY (Cod_Dep),

  CONSTRAINT FK_Dep FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func),

  CONSTRAINT CH_Dep CHECK (Sexo_Dep IN ('F', 'M'))

)
;

CREATE TABLE Pedido (

  Num_Ped INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_Cli INT UNSIGNED NOT NULL,
  Cod_Func INT UNSIGNED NOT NULL,
  Cod_Sta SMALLINT UNSIGNED NOT NULL,
  Data_Ped DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Ped DECIMAL(10,2) NOT NULL DEFAULT 0,

  CONSTRAINT PK_Pedido PRIMARY KEY (Num_Ped),

  CONSTRAINT FK_Pedido1 FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli),
  CONSTRAINT FK_Pedido2 FOREIGN KEY (Cod_Cli) REFERENCES Funcionario (Cod_Func),

  CONSTRAINT CH_Pedido1 CHECK (Data_Ped >= CURDATE()),
  CONSTRAINT CH_Pedido2 CHECK (Val_Ped >=0)

)
;

CREATE TABLE Parcela (

  Num_Par SMALLINT UNSIGNED NOT NULL,
  Num_Ped INT UNSIGNED NOT NULL,
  Data_Venc DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Venc DECIMAL(10,2) NOT NULL,
  Data_Pgto DATETIME NULL,
  Val_Pgto DECIMAL(10,2) AS (
    CASE
      WHEN Data_Pgto < Data_Venc THEN
        Val_Venc * 0.9
      WHEN Data_Pgto = Data_Venc THEN
        Val_Venc
      WHEN Data_Pgto > Data_Venc THEN
        Val_Venc * 1.1
    END),

  CONSTRAINT PK_Parcela PRIMARY KEY (Num_Par,Num_Ped),

  CONSTRAINT FK_Parcela FOREIGN KEY (Num_Ped) REFERENCES Pedido (Num_Ped),

  CONSTRAINT CH_Parcela1 CHECK (Data_Venc >= CURDATE()),
  CONSTRAINT CH_Parcela2 CHECK (Val_Venc >= 0)

)
;

CREATE TABLE TipoProd (

  Cod_TipoProd INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nome_TipoProd VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoProd PRIMARY KEY (Cod_TipoProd),

  CONSTRAINT UQ_TipoProd UNIQUE KEY (Nome_TipoProd)

)
;

CREATE TABLE Produto (

  Cod_Prod INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Cod_TipoProd INT UNSIGNED NOT NULL,
  Nome_Prod VARCHAR(100) NOT NULL,
  Qtd_EstqProd INT UNSIGNED NOT NULL DEFAULT 0,
  Val_UnitProd DECIMAL(10,2) NOT NULL Check (Val_UnitProd > 0),
  Val_Total DECIMAL(10,2) AS (Qtd_EstqProd * Val_UnitProd),

  CONSTRAINT PK_Prod PRIMARY KEY (Cod_Prod),

  CONSTRAINT FK_Prod FOREIGN KEY (Cod_TipoProd) REFERENCES TipoProd (Cod_TipoProd),

  CONSTRAINT UQ_Prod UNIQUE KEY (Nome_Prod),

  CONSTRAINT CH_Prod1 CHECK (Qtd_EstqProd >= 0),
  CONSTRAINT CH_Prod2 CHECK (Val_UnitProd > 0)

)
;

CREATE TABLE Itens (

  Num_Ped INT UNSIGNED NOT NULL,
  Cod_Prod INT UNSIGNED NOT NULL,
  Qtd_Vend INT UNSIGNED NOT NULL,
  Val_Vend DECIMAL(10,2) NOT NULL,

  CONSTRAINT PK_Itens PRIMARY KEY (Num_Ped,Cod_Prod),

  CONSTRAINT FK_Itens1 FOREIGN KEY (Num_Ped) REFERENCES Pedido (Num_Ped),
  CONSTRAINT FK_Itens2 FOREIGN KEY (Cod_Prod) REFERENCES Produto (Cod_Prod),

  CONSTRAINT CH_Itens1 CHECK (Qtd_Vend > 0),
  CONSTRAINT CH_Itens2 CHECK (Val_Vend > 0)

)
;

/****************************************************************************/
/* Verificando a Criação da Tabelas do Database SYSAMPLES                   */
/****************************************************************************/

SELECT *
FROM Information_Schema.Tables
WHERE Table_Type = 'Base Table'

;

/****************************************************************************/
