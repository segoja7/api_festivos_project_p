--Ejecutar primero
DROP DATABASE Festivos WITH (FORCE);
--Ejecutar segundo
CREATE DATABASE Festivos;

--Para las siguientes instrucciones, se debe cambiar la conexión

--Crear la tabla TIPO
CREATE TABLE Tipo(
	Id SERIAL PRIMARY KEY,
	Tipo VARCHAR(100) NOT NULL
	);

--Crear la tabla PAIS
CREATE TABLE Pais(
	Id SERIAL PRIMARY KEY,
	Nombre VARCHAR(100) NOT NULL
	);

--Crear la tabla FESTIVO
CREATE TABLE Festivo(
	Id SERIAL PRIMARY KEY,
	IdPais INT NOT NULL,
	CONSTRAINT fkFestivo_Pais FOREIGN KEY (IdPais) REFERENCES Pais(Id),
	Nombre VARCHAR(100) NOT NULL,
	Dia INT NOT NULL,
	Mes INT NOT NULL,
	DiasPascua INT NOT NULL,
	IdTipo INT NOT NULL,
	CONSTRAINT fkFestivo_Tipo FOREIGN KEY (IdTipo) REFERENCES Tipo(Id)
	);

--Crear secuencias
CREATE SEQUENCE secuencia_pais
    INCREMENT 1
    START 1
    MINVALUE 1
    OWNED BY pais.id;

CREATE SEQUENCE secuencia_tipo
    INCREMENT 1
    START 1
    MINVALUE 1
    OWNED BY tipo.id;


CREATE SEQUENCE secuencia_festivo
    INCREMENT 1
    START 1
    MINVALUE 1
    OWNED BY festivo.id;