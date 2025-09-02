USE empresa_ficticia
GO

--Código pra facilitar os testes com a execução completa mais de uma vez
DROP TABLE IF EXISTS Pessoa;
DROP TABLE IF EXISTS Departamento;

CREATE TABLE Departamento (
    Id INT IDENTITY(1, 1) PRIMARY KEY,
    Nome VARCHAR(50)
);

CREATE TABLE Pessoa(
    Id INT IDENTITY(1, 1) PRIMARY KEY,
    Nome NVARCHAR(200),
    Salario DECIMAL(18, 2),
    DeptId INT,
    CONSTRAINT FK_PessoaDepartamento FOREIGN KEY (DeptId) REFERENCES Departamento (Id)
);

-- Criação de indice para evitar um scam na tabela na hora de fazer as buscas
CREATE NONCLUSTERED INDEX IX_Pessoa_DeptId_Salario
ON Pessoa (DeptId, Salario DESC)
INCLUDE (Nome);

INSERT INTO Departamento (Nome)
VALUES 
('Recursos Humanos'),
('Financeiro'),
('Tecnologia da Informação'),
('Marketing');

INSERT INTO Pessoa (Nome, Salario, DeptId)
VALUES
('João Silva', 3500.00, 1),
('Fernanda Lima', 4100.00, 1),
('Rafael Mendes', 2900.00, 1),
('Maria Oliveira', 4200.50, 2),
('Lucas Pereira', 5100.00, 2),
('Juliana Rocha', 3800.00, 2),
('Carlos Souza', 5500.75, 3),
('André Santos', 6200.00, 3),
('Beatriz Nogueira', 4700.00, 3),
('Ana Santos', 3100.00, 4),
('Paulo Costa', 3600.00, 4),
('Camila Almeida', 2800.00, 4);

WITH MaiorSalarioDepartamento AS (
    SELECT 
        Departamento.Nome AS Departamento, Pessoa.Nome AS Pessoa, Pessoa.Salario,
        ROW_NUMBER() OVER (PARTITION BY Departamento.Id ORDER BY Pessoa.Salario DESC) AS Posicao
    FROM Departamento (NOLOCK) 
    INNER JOIN Pessoa (NOLOCK) ON Pessoa.DeptId = Departamento.Id
)
SELECT 
    Departamento, Pessoa, Salario
FROM MaiorSalarioDepartamento
WHERE Posicao = 1;

/*
Obs: O uso de nolock se torna dispensável caso não haja muita concorrência e rotinas criticas 
envolvendo as tabelas Pessoa e Departamento. A clausula NOLOCK pode em alguns casos trazer dados "sujos",
porém evita travamento de processos. É algo a se avaliar dependendo do contexto do banco de dados.
*/