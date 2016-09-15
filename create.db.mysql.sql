

CREATE DATABASE /*! IF NOT EXISTS */ Exemplo;

USE Exemplo;

-- específico do MySQL
/* SET @@default_storage_engine=InnoDB; */
/* ALTER DATABASE CHARACTER SET utf8mb4 COLLATE 'utf8mb4_unicode_ci'; */

CREATE TABLE IF NOT EXISTS TipoEnd
(

  Cod_TipoEnd INT NOT NULL AUTO_INCREMENT,
  Nome_TipoEnd VARCHAR(30) NOT NULL,

  CONSTRAINT PK_TipoEnd PRIMARY KEY (Cod_TipoEnd),

  CONSTRAINT UQ_TipoEnd UNIQUE (Nome_TipoEnd)

);

CREATE TABLE IF NOT EXISTS Estado
(

  Sigla_Est CHAR(02) NOT NULL,
  Nome_Est VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Est PRIMARY KEY (Sigla_Est),

  CONSTRAINT UQ_Est UNIQUE (Nome_Est)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Cidade
(

  Cod_Cid INT NOT NULL AUTO_INCREMENT,
  Sigla_Est CHAR(02) NOT NULL,
  Nome_Cid VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Cid PRIMARY KEY (Cod_Cid),

  CONSTRAINT FK_Cid FOREIGN KEY (Sigla_Est) REFERENCES Estado (Sigla_Est),

  CONSTRAINT UQ_Cid UNIQUE (Sigla_Est, Nome_Cid)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS TipoCli
(

  Cod_TipoCli INT NOT NULL AUTO_INCREMENT,
  Nome_TipoCli VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoCli PRIMARY KEY (Cod_TipoCli),
  CONSTRAINT UQ_TipoCli UNIQUE (Nome_TipoCli)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Cliente
(

  Cod_Cli INT NOT NULL AUTO_INCREMENT,
  Cod_TipoCli INT NOT NULL,
  Nome_Cli VARCHAR(100) NOT NULL,
  Data_CadCli DATETIME NOT NULL DEFAULT NOW(),
  Renda_Cli DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0,
  Sexo_Cli ENUM('F', 'M') NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Cli PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Cli FOREIGN KEY (Cod_TipoCli) REFERENCES TipoCli (Cod_TipoCli)

  -- CONSTRAINT CH_Cli1 Check(Renda_Cli >=0),
  -- CONSTRAINT CH_Cli2 Check(Sexo_Cli IN('F','M'))

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Conjuge
(

  Cod_Cli INT NOT NULL,
  Nome_Conj CHAR(30) NOT NULL,
  Renda_Conj DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0,
  Sexo_Conj ENUM('F', 'M') NOT NULL DEFAULT 'M',

  CONSTRAINT PK_Conj PRIMARY KEY (Cod_Cli),

  CONSTRAINT FK_Conj FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

  -- CONSTRAINT CH_Conj1 Check(Renda_Conj >=0),
  -- CONSTRAINT CH_Conj2 Check(Sexo_Conj IN ('F','M'))

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Endereco
(

  Cod_End INT NOT NULL AUTO_INCREMENT,
  Cod_TipoEnd INT NOT NULL,
  Cod_Cid INT NOT NULL,
  Cod_Cli INT NOT NULL,
  Nome_Rua VARCHAR(100) NOT NULL,
  Nome_Bairro VARCHAR(100) NOT NULL,
  Compl_End VARCHAR(100) NULL,

  CONSTRAINT PK_End PRIMARY KEY (Cod_End),

  CONSTRAINT FK_End1 FOREIGN KEY (Cod_TipoEnd) REFERENCES TipoEnd (Cod_TipoEnd),
  CONSTRAINT FK_End2 FOREIGN KEY (Cod_Cid) REFERENCES Cidade (Cod_Cid),
  CONSTRAINT FK_End3 FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Credito
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Cli INT NOT NULL,
  Cred_Cli DECIMAL(10,2) UNSIGNED NOT NULL,
  Data_CredCli DATETIME NOT NULL,

  CONSTRAINT PK_Cred PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Cred FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

  -- CONSTRAINT CH_Cred Check(Cred_Cli > 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Fone
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Cli INT NOT NULL,
  Num_Fone CHAR(10) NOT NULL,
  Num_DDD CHAR(05) NOT NULL DEFAULT '011',

  CONSTRAINT PK_Fone PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Fone FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS EMail
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Cli INT NOT NULL,
  EMail_Cli VARCHAR(255) NOT NULL,

  CONSTRAINT PK_Email PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Emails FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS StatusPedido
(

  Cod_Sta SMALLINT NOT NULL AUTO_INCREMENT,
  Sta_Ped VARCHAR(100) NOT NULL,

  CONSTRAINT PK_StatusPed PRIMARY KEY (Cod_Sta),

  CONSTRAINT UQ_StatusPed UNIQUE (Sta_Ped)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Funcionario
(

  Cod_Func INT NOT NULL AUTO_INCREMENT,
  Nome_Func VARCHAR(100) NOT NULL,
  Data_CadFunc DATETIME NOT NULL DEFAULT NOW(),
  Sexo_Func ENUM('F', 'M') NOT NULL DEFAULT 'F',
  Sal_Func DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 200,
  End_Func VARCHAR(100) NOT NULL,

  CONSTRAINT PK_Func PRIMARY KEY (Cod_Func)

  -- CONSTRAINT CH_Func1 Check(Data_CadFunc >= Getdate()),
  -- CONSTRAINT CH_Func2 Check(Sexo_Func IN ('F','M')),
  -- CONSTRAINT CH_Func3 Check(Sal_Func >=0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Bonus
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Func INT NOT NULL,
  Data_Bonus DATETIME NOT NULL DEFAULT NOW(),
  Val_Bonus DECIMAL(10,2) UNSIGNED UNSIGNED NOT NULL,

  CONSTRAINT PK_Bonus PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Bonus FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func)

  -- CONSTRAINT CH_Bonus1 Check(Data_Bonus >= Getdate()),
  -- CONSTRAINT CH_Bonus2 Check(Val_Bonus > 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Pontuacao
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Func INT NOT NULL,
  Data_Pto DATETIME NOT NULL DEFAULT NOW(),
  Pto_Func DECIMAL(4,2) UNSIGNED NOT NULL,

  CONSTRAINT PK_Pto PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Pto FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func)

  -- CONSTRAINT CH_Pto1 Check(Data_Pto >= Getdate()),
  -- CONSTRAINT CH_Pto2 Check(Pto_Func > 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Historico
(

  Num_Lanc INT NOT NULL AUTO_INCREMENT,
  Cod_Func INT NOT NULL,
  Data_Hist DATETIME NOT NULL DEFAULT NOW(),
  Sal_Ant DECIMAL(10,2) UNSIGNED NOT NULL,
  Sal_Atual DECIMAL(10,2) UNSIGNED NOT NULL,

  CONSTRAINT PK_Hist PRIMARY KEY (Num_Lanc),

  CONSTRAINT FK_Hist FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func)

  -- CONSTRAINT CH_Hist1 Check(Data_Hist >= Getdate()),
  -- CONSTRAINT CH_Hist2 Check(Sal_Ant >= 0),
  -- CONSTRAINT CH_Hist3 Check(Sal_Ant > 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Dependente
(

  Cod_Dep INT NOT NULL AUTO_INCREMENT,
  Cod_Func INT NOT NULL,
  Nome_Dep VARCHAR(100) NOT NULL,
  Data_NascDep DATETIME NOT NULL,
  Sexo_Dep ENUM('F', 'M') NOT NULL DEFAULT 'F',

  CONSTRAINT PK_Dep PRIMARY KEY (Cod_Dep),

  CONSTRAINT FK_Dep FOREIGN KEY (Cod_Func) REFERENCES Funcionario (Cod_Func)

  -- CONSTRAINT CH_Dep Check(Sexo_Dep IN ('F','M'))

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Pedido
(

  Num_Ped INT NOT NULL AUTO_INCREMENT,
  Cod_Cli INT NOT NULL,
  Cod_Func INT NOT NULL,
  Cod_Sta SMALLINT NOT NULL,
  Data_Ped DATETIME NOT NULL DEFAULT NOW(),
  Val_Ped DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0,

  CONSTRAINT PK_Pedido PRIMARY KEY (Num_Ped),

  CONSTRAINT FK_Pedido1 FOREIGN KEY (Cod_Cli) REFERENCES Cliente (Cod_Cli),
  CONSTRAINT FK_Pedido2 FOREIGN KEY (Cod_Cli) REFERENCES Funcionario (Cod_Func)

  -- CONSTRAINT CH_Pedido1 Check(Data_Ped >= getdate()),
  -- CONSTRAINT CH_Pedido2 Check(Val_Ped >= 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Parcela
(

  Num_Par SMALLINT NOT NULL,
  Num_Ped INT NOT NULL,
  Data_Venc DATETIME NOT NULL DEFAULT NOW(),
  Val_Venc DECIMAL(10,2) UNSIGNED NOT NULL,
  Data_Pgto DATETIME NULL,

  -- Val_Pgto DECIMAL(10,2) UNSIGNED AS CASE WHEN Data_Pgto < Data_Venc THEN Val_Venc * 0.9 WHEN Data_Pgto = Data_Venc THEN Val_Venc WHEN Data_Pgto > Data_Venc THEN Val_Venc * 1.1 END,
  Val_Pgto DECIMAL(10,2) UNSIGNED AS (
    CASE Data_Pgto < Data_Venc WHEN TRUE THEN
      Val_Venc * 0.9
    ELSE
      CASE Data_Pgto = Data_Venc WHEN TRUE THEN
        Val_Venc
      ELSE
        Val_Venc * 1.1
      END
    END),

  CONSTRAINT PK_Parcela PRIMARY KEY (Num_Par,Num_Ped),

  CONSTRAINT FK_Parcela FOREIGN KEY (Num_Ped) REFERENCES Pedido (Num_Ped)

  -- CONSTRAINT CH_Parcela1 Check(Data_Venc >= getdate()),
  -- CONSTRAINT CH_Parcela2 Check(Val_Venc >= 0),

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS TipoProd
(

  Cod_TipoProd INT NOT NULL AUTO_INCREMENT,
  Nome_TipoProd VARCHAR(100) NOT NULL,

  CONSTRAINT PK_TipoProd PRIMARY KEY (Cod_TipoProd),

  CONSTRAINT UQ_TipoProd UNIQUE (Nome_TipoProd)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Produto
(

  Cod_Prod INT NOT NULL AUTO_INCREMENT,
  Cod_TipoProd INT NOT NULL,
  Nome_Prod VARCHAR(100) NOT NULL,
  Qtd_EstqProd INT UNSIGNED NOT NULL DEFAULT 0,
  Val_UnitProd DECIMAL(10,2) UNSIGNED NOT NULL,
  Val_Total DECIMAL(10,2) UNSIGNED AS (Qtd_EstqProd * Val_UnitProd),

  CONSTRAINT PK_Prod PRIMARY KEY (Cod_Prod),
  CONSTRAINT UQ_Prod UNIQUE (Nome_Prod),

  CONSTRAINT FK_Prod FOREIGN KEY (Cod_TipoProd) REFERENCES TipoProd (Cod_TipoProd)

  -- CONSTRAINT CH_Prod1 Check(Qtd_EstqProd >= 0),
  -- CONSTRAINT CH_Prod2 Check(Val_UnitProd > 0)

)
/*! ENGINE=InnoDB */;

CREATE TABLE IF NOT EXISTS Itens
(

  Num_Ped INT NOT NULL,
  Cod_Prod INT NOT NULL,
  Qtd_Vend INT UNSIGNED NOT NULL,
  Val_Vend DECIMAL(10,2) UNSIGNED NOT NULL,

  CONSTRAINT PK_Itens Primary Key (Num_Ped,Cod_Prod),

  CONSTRAINT FK_Itens1 FOREIGN KEY (Num_Ped) REFERENCES Pedido (Num_Ped),
  CONSTRAINT FK_Itens2 FOREIGN KEY (Cod_Prod) REFERENCES Produto (Cod_Prod)

  -- CONSTRAINT CH_Itens1 Check(Qtd_Vend > 0),
  -- CONSTRAINT CH_Itens2 Check(Val_Vend > 0)

)
/*! ENGINE=InnoDB */;

SELECT * FROM Information_Schema.Tables
WHERE Table_Type = 'Base Table'

