CREATE DATABASE biblioteca;
USE biblioteca;
CREATE table Livros (
livro_id INT PRIMARY KEY,
titulo VARCHAR(50),
categoria VARCHAR(50),
isbn INT,
ano_publicacao INT,
valor VARCHAR(45),
autor VARCHAR(50),
cod_editora VARCHAR(20),
estoque_cod_livros VARCHAR(20),
emprestimo_cod_emprestimo VARCHAR(50)
);

CREATE table Leitor (
leitor_id INT PRIMARY KEY,
nome VARCHAR(50),
telefone_1 VARCHAR(15),
telefone_2 VARCHAR(15),
email VARCHAR(50),
rua VARCHAR(50),
bairro VARCHAR(50),
cidade VARCHAR(50),
estado VARCHAR(50)
);

CREATE table Exemplares (
exemplar_id INT PRIMARY key,
livro_id INT,
disponivel INT,
foreign key (livro_id) REFERENCES Livros (livro_id)
);

CREATE table Autor (
autor_id INT PRIMARY KEY,
cod_autor VARCHAR (50),
telefone_1 VARCHAR (15),
telefone_2 VARCHAR (15),
email VARCHAR (50),
nome_autor VARCHAR (50),
contato VARCHAR (50)

);



CREATE TABLE Emprestimo (
emprestimo_id INT PRIMARY KEY,
leitor_id INT,
autor_id INT,
data_retirada date,
data_devolucao date,
FOREIGN key (leitor_id) references leitor(leitor_id),
foreign key (autor_id) references autor (autor_id)
);	

INSERT INTO Autor (cod_autor, telefone_1, telefone_2, email, nome_autor, contato)
VALUES
    ('BR001', 'Telefone1', 'Telefone2', 'email1@example.com', 'Autor Brasileiro 1', 'Contato 1'),
    ('BR002', 'Telefone3', 'Telefone4', 'email2@example.com', 'Autor Brasileiro 2', 'Contato 2'),
    ('BR003', 'Telefone5', 'Telefone6', 'email3@example.com', 'Autor Brasileiro 3', 'Contato 3'),
    ('BR004', 'Telefone7', 'Telefone8', 'email4@example.com', 'Autor Brasileiro 4', 'Contato 4'),
    ('BR005', 'Telefone9', 'Telefone10', 'email5@example.com', 'Autor Brasileiro 5', 'Contato 5');

INSERT INTO Livros (titulo, categoria, isbn, ano_publicacao, valor, autor, cod_editora, estoque_cod_livros, emprestimo_cod_emprestimo)
VALUES
    ('Livro Fictício 1', 'Ficção', 1111, 2018, 'R$ 45.00', 'Autor Brasileiro 1', 'Editora 1', 'CodLivro1', 'CodEmprestimo1'),
    ('Livro Fictício 2', 'Aventura', 2222, 2020, 'R$ 50.00', 'Autor Brasileiro 2', 'Editora 2', 'CodLivro2', 'CodEmprestimo2'),
    ('Livro Fictício 3', 'Mistério', 3333, 2019, 'R$ 55.00', 'Autor Brasileiro 3', 'Editora 3', 'CodLivro3', 'CodEmprestimo3'),
    ('Livro Fictício 4', 'Romance', 4444, 2022, 'R$ 40.00', 'Autor Brasileiro 4', 'Editora 1', 'CodLivro4', 'CodEmprestimo4'),
    ('Livro Fictício 5', 'Fantasia', 5555, 2021, 'R$ 60.00', 'Autor Brasileiro 5', 'Editora 2', 'CodLivro5', 'CodEmprestimo5');

INSERT INTO Leitor (nome, telefone_1, telefone_2, email, rua, bairro, cidade, estado)
VALUES
    ('Leitor Fictício 1', 'Telefone1', 'Telefone2', 'email1@example.com', 'Rua 1', 'Bairro 1', 'Cidade 1', 'Estado 1'),
    ('Leitor Fictício 2', 'Telefone3', 'Telefone4', 'email2@example.com', 'Rua 2', 'Bairro 2', 'Cidade 2', 'Estado 2'),
    ('Leitor Fictício 3', 'Telefone5', 'Telefone6', 'email3@example.com', 'Rua 3', 'Bairro 3', 'Cidade 3', 'Estado 3'),
    ('Leitor Fictício 4', 'Telefone7', 'Telefone8', 'email4@example.com', 'Rua 4', 'Bairro 4', 'Cidade 4', 'Estado 4'),
    ('Leitor Fictício 5', 'Telefone9', 'Telefone10', 'email5@example.com', 'Rua 5', 'Bairro 5', 'Cidade 5', 'Estado 5');


INSERT INTO Emprestimo (leitor_id, autor_id, data_retirada, data_devolucao)
VALUES
    (1, 1, '2023-10-30', '2023-11-30'),
    (2, 2, '2023-10-30', '2023-11-30'),
    (3, 3, '2023-10-30', '2023-11-30'),
    (4, 4, '2023-10-30', '2023-11-30'),
    (5, 5, '2023-10-30', '2023-11-30'),
    (1, 2, '2023-10-30', '2023-11-30'),
    (2, 3, '2023-10-30', '2023-11-30'),
    (3, 4, '2023-10-30', '2023-11-30'),
    (4, 5, '2023-10-30', '2023-11-30'),
    (5, 1, '2023-10-30', '2023-11-30');


DELIMITER //
CREATE function QuantidadeExemplaresDisponiveisPorAutor (autor VARCHAR(50) ) returns INT
 BEGIN
DECLARE disponiveis INT;
SELECT disponivel INTO disponiveis
FROM Exemplares 
INNER JOIN livros ON Exemplares.livro_id = livros.livro_id
WHERE livros.autor = autor;
return disponiveis; 
END;
//
DELIMITER ;

DELIMITER //
CREATE procedure RegistrarEmprestimo(LeitorID INT, exemplarID INT, data_retirada DATE, data_devolucao DATE) 
BEGIN
IF QuantidadeExemplaresDisponiveisPorAutor(autor) > 0 THEN 
INSERT into  Emprestimos (leitor_id, exemplar_id, data_retirada, data_devolucao)
VALUES (leitorID, exemplarID, data_retirada, data_devolucao);
UPDATE Exemplares SET disponivel = disponiveis - 1 WHERE exemplar_id = exemplarID;
ELSE
SIGNAL SQLSTATE '4500'
SET message_text = 'Exemplar nao disponivel para emprestimo';
END if;
END;
//
DELIMITER ;

CREATE view DetalhesEmprestimo AS
SELECT
E.emprestimo_id,
L.titulo AS titulo_livro,
L.autor AS autor_livro,
LR.nome AS nome_autor,
E.data_retirada,
E.data_devolucao
FROM Emprestimo E
	INNER JOIN Livros L ON E.livro_id = L.livro_id 
    INNER JOIN Leitores LR ON E.leitor_id = LR.leitor_id;
    
    SELECT distinct L.titulo, L.autor
    FROM livros L	
      INNER JOIN Exemplares E ON L.livro_id = E.livro_id
      INNER JOIN Emprestimo EM ON E.exemplar_id = EM.exemplar_id
      WHERE EM.data_devolucao >= CURDATE();
      
      
	SELECT distinct LR.nome 
    FROM Leitor LR 
    INNER JOIN Emprestimos EM ON LR.leitor_id = EM.leitor_id
    WHERE EM.data_devolucao < CURDATE();
 