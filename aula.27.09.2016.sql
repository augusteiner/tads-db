/**
 *
 * Script da aula do dia 27/09/2016
 *
 */

/*!40001 SET sql_mode = 'TRADITIONAL' */;

/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;

/*!40001 SET storage_engine = InnoDB */;
/*!50503 SET default_storage_engine = InnoDB */;
/*!40001 SET innodb_strict_mode = ON */;

CREATE DATABASE /*! IF NOT EXISTS */ vendas_27_09_2016;

USE vendas_27_09_2016;

/*!
ALTER DATABASE

CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci

DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci
*/
;

CREATE TABLE /*! IF NOT EXISTS */ cliente (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  cpf VARCHAR(11) NOT NULL,

  nome VARCHAR(100) NOT NULL,

  endereco VARCHAR(100) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  estado CHAR(2) NOT NULL,
  -- estado ENUM('RN', ..., 'RS') NOT NULL,

  CONSTRAINT pk_cliente
    PRIMARY KEY (id)

)
/*!50506 ROW_FORMAT=Compressed */
;

CREATE TABLE /*! IF NOT EXISTS */ pedido (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  data DATETIME NOT NULL,
  valor DECIMAL(14, 4) UNSIGNED NOT NULL,

  clienteId INT UNSIGNED NOT NULL,

  CONSTRAINT pk_pedido
    PRIMARY KEY (id),

  CONSTRAINT fk_pedido__cliente
    FOREIGN KEY (clienteId)
    REFERENCES cliente (id)
    /*!
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    */

)
/*!50506 ROW_FORMAT=Compressed */
;

CREATE TABLE /*! IF NOT EXISTS */ produto (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  descricao VARCHAR(100) NOT NULL,

  qteEstoque INT UNSIGNED NOT NULL,
  precoVenda DECIMAL(14, 4) UNSIGNED NOT NULL,

  CONSTRAINT pk_produto
    PRIMARY KEY (id)

)
/*!50506 ROW_FORMAT=Compressed */
;

CREATE TABLE /*! IF NOT EXISTS */ pedido_item (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  qteVenda INT UNSIGNED NOT NULL,
  precoVenda DECIMAL(14, 4) UNSIGNED NOT NULL,

  pedidoId INT UNSIGNED NOT NULL,
  produtoId INT UNSIGNED NOT NULL,

  CONSTRAINT pk_pedido_item
    PRIMARY KEY (id),

  CONSTRAINT uk_pedido_item__pedido_produto
    UNIQUE KEY (pedidoId, produtoId),

  CONSTRAINT fk_pedido_item__pedido
    FOREIGN KEY (pedidoId)
    REFERENCES pedido (id)
    /*!
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    */,

  CONSTRAINT fk_pedido_item__produto
    FOREIGN KEY (produtoId)
    REFERENCES produto (id)
    /*!
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    */

)
/*!50506 ROW_FORMAT=Compressed */
;

CREATE TABLE /*! IF NOT EXISTS */ fornecedor (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  cnpj VARCHAR(14) NOT NULL,
  razaoSocial VARCHAR(100) NOT NULL,

  endereco VARCHAR(100) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  estado CHAR(2) NOT NULL,
  -- estado ENUM('RN', ..., 'RS') NOT NULL,

  CONSTRAINT pk_fornecedor
    PRIMARY KEY (id)

)
/*!50506 ROW_FORMAT=Compressed */
;

CREATE TABLE /*! IF NOT EXISTS */ fornecedor_produto (

  id INT UNSIGNED NOT NULL /*! AUTO_INCREMENT */,

  fornecedorId INT UNSIGNED NOT NULL,
  produtoId INT UNSIGNED NOT NULL,

  -- qte INT UNSIGNED NOT NULL,
  precoCompra DECIMAL(14, 4) UNSIGNED NOT NULL,

  CONSTRAINT pk_fornecedor_produto
    PRIMARY KEY (id),

  CONSTRAINT fk_fornecedor_produto__fornecedor
    FOREIGN KEY (fornecedorId)
    REFERENCES fornecedor (id)
    /*!
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    */,

  CONSTRAINT fk_fornecedor_produto__produto
    FOREIGN KEY (produtoId)
    REFERENCES produto (id)
    /*!
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    */

)
/*!50506 ROW_FORMAT=Compressed */
;

