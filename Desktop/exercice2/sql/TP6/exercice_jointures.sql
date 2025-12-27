-- A. Création du schéma de la base de données
CREATE DATABASE universite CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- On crée une base de données appelée "universite" avec un encodage pour les caractères spéciaux
USE universite;
-- On utilise cette base pour créer les tables et insérer les données

-- Création des tables

-- Table des étudiants
CREATE TABLE etudiant (
    id INT AUTO_INCREMENT PRIMARY KEY, -- identifiant unique pour chaque étudiant
    nom VARCHAR(50),                   -- nom de l'étudiant
    email VARCHAR(50) NOT NULL UNIQUE  -- email obligatoire et unique
) ENGINE=InnoDB;

-- Table des professeurs
CREATE TABLE professeur (
    id INT AUTO_INCREMENT PRIMARY KEY, -- identifiant unique pour chaque professeur
    nom VARCHAR(50),                   -- nom du professeur
    email VARCHAR(50) UNIQUE,          -- email unique
    departement VARCHAR(50)            -- département du professeur
) ENGINE=InnoDB;

-- Table des cours
CREATE TABLE cours (
    id INT AUTO_INCREMENT PRIMARY KEY, -- identifiant unique pour chaque cours
    titre VARCHAR(50),                 -- nom du cours
    code VARCHAR(50) UNIQUE,           -- code unique pour le cours
    credits INT                        -- nombre de crédits pour le cours
) ENGINE=InnoDB;

-- Table des enseignements (quelle prof enseigne quel cours)
CREATE TABLE enseignement (
    cours_id INT,
    professeur_id INT,
    semestre VARCHAR(25) NOT NULL,   -- semestre de l'enseignement
    PRIMARY KEY (cours_id, professeur_id), -- clé primaire composée
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professeur_id) REFERENCES professeur(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des inscriptions (quel étudiant suit quel cours)
CREATE TABLE inscription (
    etudiant_id INT,
    enseignement_cours_id INT,
    enseignement_professeur_id INT,
    date_inscreption DATE,  -- date de l'inscription
    PRIMARY KEY (etudiant_id, enseignement_cours_id, enseignement_professeur_id, date_inscreption),
    FOREIGN KEY (etudiant_id) REFERENCES etudiant(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (enseignement_cours_id, enseignement_professeur_id)
        REFERENCES enseignement(cours_id, professeur_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table des examens (notes des étudiants)
CREATE TABLE examen (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscription_etudiant_id INT,
    inscription_cours_id INT,
    inscription_professeur_id INT,
    inscription_date_inscription DATE,
    date_examen DATE,               -- date de l'examen
    score DECIMAL(4,2),             -- score avec 2 décimales
    CHECK (score BETWEEN 0 AND 20), -- la note doit être entre 0 et 20
    FOREIGN KEY (inscription_etudiant_id, inscription_cours_id, inscription_professeur_id, inscription_date_inscription)
        REFERENCES inscription(etudiant_id, enseignement_cours_id, enseignement_professeur_id, date_inscreption)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- C. Insertion des données

-- Ajouter des professeurs
INSERT INTO professeur(nom, email, departement) VALUES 
    ("Hamid Alami", "alamihamid@gmail.com", "Informatique"),
    ("Jamal Nassiri", "nassirijamal@gmail.com", "Mathematique");

-- Ajouter des cours
INSERT INTO cours (titre, code, credits) VALUES
    ('Programmation Java', 'CS101', 6),
    ('Algèbre Linéaire', 'MATH201', 5),
    ('Bases de Données', 'CS102', 6);

-- Ajouter des étudiants
INSERT INTO etudiant (nom, email) VALUES
    ('Karim', 'karim@mail.com'),
    ('Samir', 'samir@mail.com'),
    ('Hassan', 'hassan@gmail.com');

-- Associer professeurs et cours (enseignement)
INSERT INTO enseignement (cours_id, professeur_id, semestre) VALUES
    (1, 1, 'S1'),
    (2, 2, 'S1');

-- Inscriptions des étudiants aux cours
INSERT INTO inscription (etudiant_id, enseignement_cours_id, enseignement_professeur_id, date_inscreption) VALUES
    (1, 1, 1, '2025-09-01'),
    (1, 2, 2, '2025-09-02'),
    (2, 1, 1, '2025-09-01'),
    (2, 2, 2, '2025-09-02');

-- Notes des examens
INSERT INTO examen(inscription_etudiant_id, inscription_cours_id, inscription_professeur_id, inscription_date_inscription, date_examen, score) VALUES
    (1, 2, 2, "2025-09-02", "2025-12-27", 12);

-- D. Sélections et filtrages

-- Lister les noms des étudiants qui suivent le cours CS101
SELECT e.nom 
FROM etudiant e 
JOIN inscription i ON etudiant_id = e.id
JOIN cours c ON enseignement_cours_id = c.id
WHERE c.code = "CS101";

-- Afficher les infos des étudiants inscrits à CS101
SELECT e.id, e.nom, c.titre, c.code 
FROM etudiant e 
JOIN inscription i ON etudiant_id = e.id
JOIN cours c ON enseignement_cours_id = c.id
WHERE c.code = "CS101";

-- Afficher les professeurs du département Informatique
SELECT nom, email 
FROM professeur 
WHERE departement = "Informatique";

-- Inscriptions d'un étudiant spécifique, triées par date
SELECT i.* 
FROM inscription i 
JOIN etudiant e ON i.etudiant_id = e.id
WHERE e.nom = 'Karim'
ORDER BY i.date_inscreption DESC;

-- E. Jointures et sous-requêtes

-- Lister les étudiants avec leurs cours et semestre
SELECT
    e.nom AS etudiant,
    c.titre AS cours,
    ens.semestre,
    i.date_inscreption
FROM inscription i
JOIN etudiant e ON i.etudiant_id = e.id
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c ON ens.cours_id = c.id
ORDER BY i.date_inscreption;

-- Compter le nombre de cours par étudiant
SELECT
    e.nom AS etudiant,
    (
        SELECT COUNT(*)
        FROM inscription i
        WHERE i.etudiant_id = e.id
    ) AS total_cours
FROM etudiant e;

-- Créer une vue pour voir les charges des étudiants
CREATE VIEW vue_etudiant_charges AS
SELECT
    e.nom AS etudiant,
    COUNT(i.enseignement_cours_id) AS nombre_inscription,
    SUM(c.credits) AS somme_credits
FROM etudiant e
JOIN inscription i ON e.id = i.etudiant_id
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c ON ens.cours_id = c.id
GROUP BY e.id, e.nom;

-- F. Agrégations

-- Compter le nombre d'inscriptions par cours
SELECT c.titre, COUNT(i.enseignement_cours_id) AS nombre_inscriptions
FROM cours c
JOIN inscription i ON c.id = enseignement_cours_id
GROUP BY c.titre
HAVING COUNT(i.enseignement_cours_id) > 1;

-- Moyenne des scores par semestre
SELECT ens.semestre, ROUND(AVG(ex.score), 2) AS moyenne_score
FROM examen ex
JOIN inscription i ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
GROUP BY ens.semestre;

-- Exemple de INNER JOIN pour lister les examens
SELECT
    etu.nom AS etudiant,
    c.titre AS cours,
    ex.date_examen,
    ex.score
FROM examen ex
JOIN inscription i ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c ON ens.cours_id = c.id
JOIN etudiant etu ON i.etudiant_id = etu.id
ORDER BY ex.date_examen;

-- LEFT JOIN pour voir les étudiants même sans examens
SELECT
    e.nom AS etudiant,
    COUNT(ex.id) AS nb_examens
FROM etudiant e
LEFT JOIN inscription i ON e.id = i.etudiant_id
LEFT JOIN examen ex ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
GROUP BY e.id, e.nom
ORDER BY e.nom;

-- RIGHT JOIN pour compter les étudiants par cours
SELECT
    c.titre AS cours,
    COUNT(DISTINCT i.etudiant_id) AS nb_etudiants
FROM inscription i
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
RIGHT JOIN cours c ON ens.cours_id = c.id
GROUP BY c.id, c.titre;

-- CROSS JOIN pour combiner tous les étudiants avec tous les professeurs
SELECT e.nom AS etudiant, p.nom AS professeur
FROM etudiant e
CROSS JOIN professeur p
LIMIT 20;

-- Création d'une vue pour les performances des étudiants
CREATE VIEW vue_performances AS
SELECT
    e.id AS etudiant_id,
    e.nom,
    ROUND(AVG(ex.score), 2) AS moyenne_score
FROM etudiant e
LEFT JOIN inscription i ON e.id = i.etudiant_id
LEFT JOIN examen ex ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
GROUP BY e.id, e.nom;
