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
