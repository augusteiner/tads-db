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
/* Criando o Database exemplo                                               */
/*  Script_01                                                               */
/****************************************************************************/

/* SET default_storage_engine=InnoDB */;

/*! DROP SCHEMA IF EXISTS exemplo */;

CREATE SCHEMA exemplo
/*! DEFAULT COLLATE 'utf8mb4_general_ci' */
/*! DEFAULT CHARSET 'utf8mb4' */
/*! COLLATE 'utf8mb4_general_ci' */
/*! CHARSET 'utf8mb4' */
;

/****************************************************************************/
/* Estabelecendo uma Conexão com o Database exemplo                         */
/****************************************************************************/

/* USE exemplo */;

/****************************************************************************/
/* Criando AS tabelas do database SYSAMPLES                                 */
/****************************************************************************/

CREATE TABLE IF NOT EXISTS exemplo.TipoEnd (

  Cod_TipoEnd SERIAL,
  Nome_TipoEnd VARCHAR(30) NOT NULL,

  CONSTRAINT PK_TipoEnd PRIMARY KEY (Cod_TipoEnd),

  CONSTRAINT UQ_TipoEnd UNIQUE KEY (Nome_TipoEnd)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Estado (

  Sigla_Est CHAR(02) NOT NULL,
  Nome_Est VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Est PRIMARY KEY (Sigla_Est),

  CONSTRAINT UQ_Est UNIQUE KEY (Nome_Est)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Cidade (

  Cod_Cid SERIAL,
  Sigla_Est CHAR(02) NOT NULL,
  Nome_Cid VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Cid PRIMARY KEY (Cod_Cid),

  CONSTRAINT FK_Cid FOREIGN KEY (Sigla_Est) REFERENCES exemplo.Estado (Sigla_Est),

  CONSTRAINT UQ_Cid UNIQUE KEY (Sigla_Est, Nome_Cid)

)
;

CREATE TABLE IF NOT EXISTS exemplo.TipoCli (

  Cod_TipoCli SERIAL,
  Nome_TipoCli VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoCli PRIMARY KEY (Cod_TipoCli),

  CONSTRAINT UQ_TipoCli UNIQUE KEY (Nome_TipoCli)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Cliente (

  Cod_Cli SERIAL,
  Cod_TipoCli BIGINT UNSIGNED NOT NULL,
  Nome_Cli VARCHAR(100) NOT NULL,
  Data_CadCli TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Renda_Cli DECIMAL(14,4) NOT NULL DEFAULT 0,
  Sexo_Cli CHAR(01) NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Cli PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Cli FOREIGN KEY (Cod_TipoCli) REFERENCES exemplo.TipoCli (Cod_TipoCli),

  CONSTRAINT CH_Cli1 CHECK (Renda_Cli >= 0),
  CONSTRAINT CH_Cli2 CHECK (Sexo_Cli IN ('F', 'M'))

)
;

CREATE TABLE IF NOT EXISTS exemplo.Conjuge (

  Cod_Cli BIGINT UNSIGNED NOT NULL,
  Nome_Conj CHAR(30) NOT NULL,
  Renda_Conj DECIMAL(14,4) NOT NULL DEFAULT 0,
  Sexo_Conj CHAR(01) NOT NULL DEFAULT 'M',

  CONSTRAINT PK_Conj PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Conj FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli),

  CONSTRAINT CH_Conj1 CHECK (Renda_Conj >= 0),
  CONSTRAINT CH_Conj2 CHECK (Sexo_Conj IN ('F', 'M'))

)
;

CREATE TABLE IF NOT EXISTS exemplo.Endereco (

  Cod_End SERIAL,
  Cod_TipoEnd BIGINT UNSIGNED NOT NULL,
  Cod_Cid BIGINT UNSIGNED NOT NULL,
  Cod_Cli BIGINT UNSIGNED NOT NULL,
  Nome_Rua VARCHAR(100) NOT NULL,
  Nome_Bairro VARCHAR(100) NOT NULL,
  Compl_End VARCHAR(100) NULL,

  CONSTRAINT PK_End PRIMARY KEY (Cod_End),

  CONSTRAINT FK_End1 FOREIGN KEY (Cod_TipoEnd) REFERENCES exemplo.TipoEnd (Cod_TipoEnd),
  CONSTRAINT FK_End2 FOREIGN KEY (Cod_Cid) REFERENCES exemplo.Cidade (Cod_Cid),
  CONSTRAINT FK_End3 FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Credito (

  Num_Lanc SERIAL,
  Cod_Cli BIGINT UNSIGNED NOT NULL,
  Cred_Cli DECIMAL(14,4) NOT NULL,
  Data_CredCli DATETIME NOT NULL,

  CONSTRAINT PK_Cred PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Cred FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli),

  CONSTRAINT CH_Cred CHECK (Cred_Cli > 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Fone (

  Num_Lanc SERIAL,
  Cod_Cli BIGINT UNSIGNED NOT NULL,
  Num_Fone CHAR(10) NOT NULL,
  Num_DDD CHAR(05) NOT NULL DEFAULT '011',

  CONSTRAINT PK_Fone PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Fone FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli)

)
;

CREATE TABLE IF NOT EXISTS exemplo.EMail (

  Num_Lanc SERIAL,
  Cod_Cli BIGINT UNSIGNED NOT NULL,
  EMail_Cli VARCHAR(255) NOT NULL,

  CONSTRAINT PK_Email PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Emails FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli)

)
;

CREATE TABLE IF NOT EXISTS exemplo.StatusPedido (

  Cod_Sta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  Sta_Ped VARCHAR(100) NOT NULL,

  CONSTRAINT PK_StatusPed PRIMARY KEY (Cod_Sta),

  CONSTRAINT UQ_StatusPed UNIQUE KEY (Sta_Ped)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Funcionario (

  Cod_Func SERIAL,
  Nome_Func VARCHAR(100) NOT NULL,
  Data_CadFunc TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Sexo_Func CHAR(01) NOT NULL DEFAULT 'F',
  Sal_Func DECIMAL(14,4) NOT NULL DEFAULT 200,
  End_Func VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Func PRIMARY KEY (Cod_Func),

  -- CONSTRAINT CH_Func1 CHECK (Data_CadFunc >= CURDATE()),
  CONSTRAINT CH_Func2 CHECK (Sexo_Func IN ('F', 'M')),
  CONSTRAINT CH_Func3 CHECK (Sal_Func >= 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Bonus (

  Num_Lanc SERIAL,
  Cod_Func BIGINT UNSIGNED NOT NULL,
  Data_Bonus TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Bonus DECIMAL(14,4) NOT NULL,

  CONSTRAINT PK_Bonus PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Bonus FOREIGN KEY (Cod_Func) REFERENCES exemplo.Funcionario (Cod_Func),

  -- CONSTRAINT CH_Bonus1 CHECK (Data_Bonus >= CURDATE()),
  CONSTRAINT CH_Bonus2 CHECK (Val_Bonus > 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Pontuacao (

  Num_Lanc SERIAL,
  Cod_Func BIGINT UNSIGNED NOT NULL,
  Data_Pto TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Pto_Func DECIMAL(4,2) NOT NULL,

  CONSTRAINT PK_Pto PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Pto FOREIGN KEY (Cod_Func) REFERENCES exemplo.Funcionario (Cod_Func),

  -- CONSTRAINT CH_Pto1 CHECK (Data_Pto >= CURDATE()),
  CONSTRAINT CH_Pto2 CHECK (Pto_Func > 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Historico (

  Num_Lanc SERIAL,
  Cod_Func BIGINT UNSIGNED NOT NULL,
  Data_Hist TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Sal_Ant DECIMAL(14,4) NOT NULL,
  Sal_Atual DECIMAL(14,4) NOT NULL,

  CONSTRAINT PK_Hist PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Hist FOREIGN KEY (Cod_Func) REFERENCES exemplo.Funcionario (Cod_Func),

  -- CONSTRAINT CH_Hist1 CHECK (Data_Hist >= CURDATE()),
  CONSTRAINT CH_Hist2 CHECK (Sal_Ant >= 0),
  CONSTRAINT CH_Hist3 CHECK (Sal_Ant > 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Dependente (

  Cod_Dep SERIAL,
  Cod_Func BIGINT UNSIGNED NOT NULL,
  Nome_Dep VARCHAR(100) NOT NULL,
  Data_NascDep DATETIME NOT NULL,
  Sexo_Dep CHAR(01) NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Dep PRIMARY KEY (Cod_Dep),

  CONSTRAINT FK_Dep FOREIGN KEY (Cod_Func) REFERENCES exemplo.Funcionario (Cod_Func),

  CONSTRAINT CH_Dep CHECK (Sexo_Dep IN ('F', 'M'))

)
;

CREATE TABLE IF NOT EXISTS exemplo.Pedido (

  Num_Ped SERIAL,
  Cod_Cli BIGINT UNSIGNED NOT NULL,
  Cod_Func BIGINT UNSIGNED NOT NULL,
  Cod_Sta BIGINT UNSIGNED NOT NULL,
  Data_Ped TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Ped DECIMAL(14,4) NOT NULL DEFAULT 0,

  CONSTRAINT PK_Pedido PRIMARY KEY (Num_Ped),

  CONSTRAINT FK_Pedido1 FOREIGN KEY (Cod_Cli) REFERENCES exemplo.Cliente (Cod_Cli),
  CONSTRAINT FK_Pedido2 FOREIGN KEY (Cod_Func) REFERENCES exemplo.Funcionario (Cod_Func),

  -- CONSTRAINT CH_Pedido1 CHECK (Data_Ped >= CURDATE()),
  CONSTRAINT CH_Pedido2 CHECK (Val_Ped >=0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Parcela (

  Num_Par BIGINT UNSIGNED NOT NULL,
  Num_Ped BIGINT UNSIGNED NOT NULL,
  Data_Venc TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Val_Venc DECIMAL(14,4) NOT NULL,
  Data_Pgto DATETIME NULL,
  Val_Pgto DECIMAL(14,4) /*M!100200 AS (
    CASE Data_Pgto < Data_Venc WHEN TRUE THEN
        Val_Venc * 0.9
    ELSE
      CASE Data_Pgto = Data_Venc WHEN TRUE THEN
        Val_Venc
      ELSE
        Val_Venc * 1.1
      END
    END) */,

  CONSTRAINT PK_Parcela PRIMARY KEY (Num_Par,Num_Ped),

  CONSTRAINT FK_Parcela FOREIGN KEY (Num_Ped) REFERENCES exemplo.Pedido (Num_Ped),

  -- CONSTRAINT CH_Parcela1 CHECK (Data_Venc >= CURDATE()),
  CONSTRAINT CH_Parcela2 CHECK (Val_Venc >= 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.TipoProd (

  Cod_TipoProd SERIAL,
  Nome_TipoProd VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoProd PRIMARY KEY (Cod_TipoProd),

  CONSTRAINT UQ_TipoProd UNIQUE KEY (Nome_TipoProd)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Produto (

  Cod_Prod SERIAL,
  Cod_TipoProd BIGINT UNSIGNED NOT NULL,
  Nome_Prod VARCHAR(100) NOT NULL,
  Qtd_EstqProd BIGINT UNSIGNED NOT NULL DEFAULT 0,
  Val_UnitProd DECIMAL(14,4) NOT NULL Check (Val_UnitProd > 0),
  Val_Total DECIMAL(14,4) /*M!100200 AS (Qtd_EstqProd * Val_UnitProd) */,

  CONSTRAINT PK_Prod PRIMARY KEY (Cod_Prod),

  CONSTRAINT FK_Prod FOREIGN KEY (Cod_TipoProd) REFERENCES exemplo.TipoProd (Cod_TipoProd),

  CONSTRAINT UQ_Prod UNIQUE KEY (Nome_Prod),

  CONSTRAINT CH_Prod1 CHECK (Qtd_EstqProd >= 0),
  CONSTRAINT CH_Prod2 CHECK (Val_UnitProd > 0)

)
;

CREATE TABLE IF NOT EXISTS exemplo.Itens (

  Num_Ped BIGINT UNSIGNED NOT NULL,
  Cod_Prod BIGINT UNSIGNED NOT NULL,
  Qtd_Vend BIGINT UNSIGNED NOT NULL,
  Val_Vend DECIMAL(14,4) NOT NULL,

  CONSTRAINT PK_Itens PRIMARY KEY (Num_Ped,Cod_Prod),

  CONSTRAINT FK_Itens1 FOREIGN KEY (Num_Ped) REFERENCES exemplo.Pedido (Num_Ped),
  CONSTRAINT FK_Itens2 FOREIGN KEY (Cod_Prod) REFERENCES exemplo.Produto (Cod_Prod),

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
