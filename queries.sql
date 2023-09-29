/*Queries that provide answers to the questions from all projects.*/
SELECT * FROM animals WHERE name like '%mon';
SELECT name FROM animals WHERE date_of_birth >='2016-01-01' AND date_of_birth <= '2019-12-31';
SELECT name FROM animals WHERE neutered = 'true' AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts  FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = 'true';
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.3 AND weight_kg <= 17.3;



-- Start the transaction
BEGIN;
-- Update the animals table by setting the species column to 'unspecified
UPDATE animals 
SET species = 'unspecified'

-- Verify the changes
SELECT * FROM animals;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;

-- Start the transaction for delete
BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
-- Verify if all records in the animals table still exist
SELECT * FROM animals;
SAVEPOINT my_savepoint;
-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO SAVEPOINT my_savepoint;
-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

-- Write queries to answer the following questions

-- How many animals are there
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT( escape_attempts) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, COUNT(*) FROM animals WHERE escape_attempts > 0 GROUP BY neutered;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;