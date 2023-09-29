/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

/* table for animals */
CREATE Table animals(
  id  INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(50),
  date_of_birth DATE,
  escape_attempts INTEGER,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  PRIMARY KEY(id)
);

-- add species column to animals table
ALTER TABLE animals
ADD species VARCHAR(100);

-- creating owner table
CREATE Table owners(
  id  INTEGER GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(50),
  age INT,
  PRIMARY KEY(id)
);

-- creating species table
CREATE Table species(
  id  INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(50),
  PRIMARY KEY(id)
);

-- remove species column
ALTER TABLE animals
DROP  COLUMN  species;

--add foreign key to animals table
ALTER TABLE animals
ADD FOREIGN KEY (species_id ) REFERENCES species(id);
ADD FOREIGN KEY (owner_id ) REFERENCES owners(id);
