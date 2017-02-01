# Recursos da disciplina Bancos de Dados

2016.2

## Dropando o banco (SQL Server)

```sql

USE master;
ALTER DATABASE Exemplo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Exemplo;

```