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

-- Write queries (using JOIN) to answer the following questions

-- What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- List all animals that are Pokemon (their type is Pokemon)
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, including those who don't own any animals.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT s.name, COUNT(*) AS animal_count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Who owns the most animals?
SELECT o.full_name, COUNT(*) AS animal_count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- Write queries to answer the following:
-- Who was the last animal seen by William Tatcher?
SELECT animals.name
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Vet William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
  SELECT DISTINCT animals.name AS animal_name
  FROM visits
  LEFT JOIN animals ON animals.id = visits.animal_id
  LEFT JOIN vets ON vets.id = visits.vet_id
  WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vet.name AS vet_name, species.name AS species_name FROM vets vet 
LEFT JOIN  specializations ON specializations.vet_id = vet.id
LEFT JOIN species ON specializations.species_id = species_id
ORDER BY vet.name;


-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON v.animal_id = a.id
JOIN vets vet ON vet.id = v.vet_id
WHERE vet.name = 'Stephanie Mendez'
  AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

  -- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(*) AS visit_count
FROM animals a
JOIN visits v ON v.animal_id = a.id
GROUP BY a.id
ORDER BY visit_count DESC
LIMIT 1;

    --  Who was Maisy Smith's first visit?
    SELECT a.name AS animal_name, v.visit_date AS visit_date FROM visits v
    JOIN animals a ON a.id = v.animal_id
    JOIN vets vet ON vet_id = v.vet_id
    WHERE vet.name = ' Maisy Smith'
    ORDER BY v.visit_date ASC
    LIMIT 1;

 -- Details for the most recent visit: animal information, vet information, and date of visit.
 SELECT a.name AS animal_name, vet.name AS vet_name, v.visit_date
FROM visits v
JOIN animals a ON a.id = v.animal_id
JOIN vets vet ON vet.id = v.vet_id
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS count
FROM visits v
JOIN animals a ON a.id = v.animal_id
JOIN vets vet ON vet.id = v.vet_id
LEFT JOIN specializations spec ON spec.vet_id = vet.id AND spec.species_id = a.species_id
WHERE spec.id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS specialty, COUNT(*) AS number_of_visits
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY number_of_visits DESC
LIMIT 1;