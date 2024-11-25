
CREATE DATABASE RestauranteGerenciamento;
USE RestauranteGerenciamento;

CREATE TABLE Mesa (
    ID_Mesa INT AUTO_INCREMENT PRIMARY KEY,
    Numero INT NOT NULL,
    Status ENUM('Livre', 'Ocupada', 'Sobremesa', 'Ocupada-Ociosa') NOT NULL
);

CREATE TABLE Cliente (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

CREATE TABLE Produto (
    ID_Produto INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(50) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Preco_Unitario DECIMAL(10, 2) NOT NULL,
    Quantidade_Estoque INT NOT NULL,
    Estoque_Minimo INT NOT NULL,
    Marca VARCHAR(50) NOT NULL
);

CREATE TABLE Forma_Pagamento (
    ID_Forma_Pagamento INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL
);


CREATE TABLE Venda (
    ID_Venda INT AUTO_INCREMENT PRIMARY KEY,
    Data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Valor_Total DECIMAL(10, 2) NOT NULL,
    ID_Cliente INT NULL,
    ID_Mesa INT NOT NULL,
    ID_Forma_Pagamento INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    FOREIGN KEY (ID_Mesa) REFERENCES Mesa(ID_Mesa),
    FOREIGN KEY (ID_Forma_Pagamento) REFERENCES Forma_Pagamento(ID_Forma_Pagamento)
);


CREATE TABLE Item_Venda (
    ID_Item_Venda INT AUTO_INCREMENT PRIMARY KEY,
    ID_Venda INT NOT NULL,
    ID_Produto INT NOT NULL,
    Quantidade INT NOT NULL,
    Preco_Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Venda) REFERENCES Venda(ID_Venda),
    FOREIGN KEY (ID_Produto) REFERENCES Produto(ID_Produto)
);

CREATE TABLE Mesa_Cliente (
    ID_Mesa INT NOT NULL,
    ID_Cliente INT NOT NULL,
    PRIMARY KEY (ID_Mesa, ID_Cliente),
    FOREIGN KEY (ID_Mesa) REFERENCES Mesa(ID_Mesa),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);


INSERT INTO Mesa (Numero, Status) VALUES 
(1, 'Livre'),
(2, 'Ocupada'),
(3, 'Sobremesa'),
(4, 'Ocupada-Ociosa');


INSERT INTO Cliente (Nome) VALUES 
('Lucas Almeida'),
('Juliana Costa'),
('Felipe Rocha'),
('Mariana Souza');


INSERT INTO Produto (Codigo, Nome, Preco_Unitario, Quantidade_Estoque, Estoque_Minimo, Marca) VALUES 
('B001', 'Coca-Cola Lata', 6.00, 120, 15, 'Coca-Cola'),
('P001', 'Pizza Calabresa', 30.00, 40, 10, 'Sabor & Cia'),
('S001', 'Torta de Limão', 12.00, 25, 5, 'Doces & Delícias'),
('B002', 'Suco Natural', 8.00, 60, 10, 'Vida Saudável');

INSERT INTO Forma_Pagamento (Descricao) VALUES 
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Pix');


INSERT INTO Venda (Data, Valor_Total, ID_Cliente, ID_Mesa, ID_Forma_Pagamento) VALUES 
('2024-11-25 14:00:00', 48.00, 1, 2, 1),
('2024-11-25 14:30:00', 64.00, 2, 3, 2),
('2024-11-25 15:00:00', 20.00, NULL, 4, 4);


INSERT INTO Item_Venda (ID_Venda, ID_Produto, Quantidade, Preco_Total) VALUES 
(1, 1, 2, 12.00),
(1, 2, 1, 30.00),
(1, 3, 1, 6.00),
(2, 2, 2, 60.00),
(2, 4, 1, 8.00),
(3, 4, 2, 16.00);


INSERT INTO Mesa_Cliente (ID_Mesa, ID_Cliente) VALUES 
(2, 1),
(2, 2),
(3, 3),
(4, 4);








2)a
SELECT 
    Cliente.Nome AS Nome_Funcionario, 
    Mesa.Numero AS Numero_Mesa, 
    SUM(Venda.Valor_Total) AS Total_Gasto
FROM 
    Venda
INNER JOIN 
    Cliente ON Venda.ID_Cliente = Cliente.ID_Cliente
INNER JOIN 
    Mesa ON Venda.ID_Mesa = Mesa.ID_Mesa
GROUP BY 
    Cliente.Nome, Mesa.Numero
ORDER BY 
    Cliente.Nome, Mesa.Numero;

b)
SELECT 
    Mesa.Numero AS Numero_Mesa, 
    Produto.Nome AS Produto_Consumido, 
    Item_Venda.Quantidade, 
    Item_Venda.Preco_Total
FROM 
    Item_Venda
INNER JOIN 
    Venda ON Item_Venda.ID_Venda = Venda.ID_Venda
INNER JOIN 
    Mesa ON Venda.ID_Mesa = Mesa.ID_Mesa
INNER JOIN 
    Produto ON Item_Venda.ID_Produto = Produto.ID_Produto;

c)
DELIMITER $$
DROP PROCEDURE IF EXISTS RedefinirMesaParaLivre $$

CREATE PROCEDURE RedefinirMesaParaLivre(IN mesaID INT)
BEGIN
    UPDATE Mesa
    SET Status = 'Livre'
    WHERE ID_Mesa = mesaID;
    
    SELECT CONCAT('O status da Mesa ', mesaID, ' foi alterado para Livre.') AS Mensagem;
END $$

DELIMITER ;

CALL RedefinirMesaParaLivre(2);




