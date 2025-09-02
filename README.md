# Projeto SQL - Consulta de Maiores Salários por Departamento

Este projeto contém um script SQL para demonstrar uma consulta que encontra a pessoa com o maior salário em cada departamento de uma empresa fictícia.

## Conteúdo do Script

O script SQL realiza as seguintes ações:

1.  **Limpeza**: Remove as tabelas `Pessoa` e `Departamento` se elas já existirem, garantindo que o script possa ser executado múltiplas vezes sem conflitos.
2.  **Criação de Tabelas**: Cria as tabelas `Departamento` e `Pessoa` com suas respectivas colunas e chaves.
3.  **Criação de Índice**: Adiciona um **índice não clusterizado** (`IX_Pessoa_DeptId_Salario`) na tabela `Pessoa` para otimizar as consultas que buscam dados por departamento e salário.
4.  **Inserção de Dados**: Popula as tabelas com dados de exemplo para simular uma empresa.
5.  **Consulta Principal**: Executa uma consulta usando uma **Common Table Expression (CTE)** para classificar os funcionários por salário dentro de cada departamento.
6.  **Resultado**: Exibe o nome do departamento, o nome do funcionário e o salário da pessoa com o maior salário em cada departamento.

## Como Usar

Para executar este script, siga estes passos:

1.  Abra um cliente de banco de dados SQL Server (como SQL Server Management Studio ou Azure Data Studio).
2.  Conecte-se ao seu servidor de banco de dados.
3.  Crie um novo banco de dados chamado `empresa_ficticia` ou altere o nome da base de dados na primeira linha do código.
4.  Abra o script e execute-o por completo.

---

## Análise do Código

### Relação entre as Tabelas

As tabelas `Pessoa` e `Departamento` estão conectadas por uma **chave estrangeira**.

-   A tabela `Departamento` possui a chave primária (`PRIMARY KEY`) `Id`, que identifica unicamente cada departamento.
-   A tabela `Pessoa` possui a chave estrangeira (`FOREIGN KEY`) `DeptId`, que referencia o `Id` da tabela `Departamento`.

Essa relação garante a integridade dos dados, assegurando que cada pessoa seja associada a um departamento válido. É essa ligação que permite que o `INNER JOIN` una as informações das duas tabelas na consulta principal.

### Otimização com Índice

A linha `CREATE NONCLUSTERED INDEX IX_Pessoa_DeptId_Salario ON Pessoa (DeptId, Salario DESC) INCLUDE (Nome);` cria um **índice não clusterizado** na tabela `Pessoa`.

-   **O que é um índice?** Um índice é uma estrutura de dados que acelera a busca e a recuperação de informações. Pense nele como o índice de um livro, que te ajuda a encontrar um tópico rapidamente sem ter que ler o livro inteiro.
-   **Por que ele é útil aqui?** A consulta principal busca os dados por `DeptId` e os ordena por `Salario`. O índice foi criado exatamente nessas colunas, o que permite que o banco de dados encontre e ordene os dados de forma muito mais eficiente.
-   **`INCLUDE (Nome)`**: A coluna `Nome` é incluída no índice para que a consulta possa obter o nome da pessoa diretamente do índice, sem precisar acessar a tabela original. Isso reduz a carga de I/O do banco de dados e melhora o desempenho da consulta.

### Observações

* **Cláusula `NOLOCK`**: A cláusula `(NOLOCK)` foi utilizada na consulta principal para evitar travamentos em ambientes com alta concorrência. No entanto, é importante notar que ela pode, em raras ocasiões, retornar dados não confirmados. Avalie seu uso de acordo com o contexto e as necessidades de integridade do seu banco de dados.
