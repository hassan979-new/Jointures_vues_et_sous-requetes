-- ===============================
-- DATABASE SELECTION
-- ===============================
USE bibiliotheque;
USE bibliotheque;

-- ===============================
-- EMPUNT & ABONNE QUERIES
-- ===============================
SELECT e.id, a.nom, e.date_debut
FROM emprunt e
INNER JOIN abonne a
  ON e.abonne_id = a.id;

SELECT e.abonne_id, a.nom, e.date_debut
FROM emprunt e
INNER JOIN abonne a
  ON e.abonne_id = a.id;

SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
FROM ouvrage o
LEFT JOIN emprunt e
  ON e.ouvrage_id = o.id
GROUP BY o.id, o.titre;

SELECT a.nom AS abonne, au.nom AS auteur
FROM abonne a
CROSS JOIN auteur au;

-- ===============================
-- VIEWS
-- ===============================
CREATE VIEW vue_emprunts_par_abonne AS
SELECT a.id, a.nom, COUNT(e.abonne_id) AS total_emprunts
FROM abonne a
LEFT JOIN emprunt e
  ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

SELECT *
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 5;

SELECT *
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 1;

SELECT *
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 0;

DROP VIEW vue_emprunts_par_abonne;

-- ===============================
-- SUBQUERY QUERIES
-- ===============================
SELECT
  titre,
  (SELECT COUNT(*)
   FROM emprunt e
   WHERE e.ouvrage_id = o.id
  ) AS nb_emprunts
FROM ouvrage o;

SELECT nom, email
FROM abonne
WHERE id IN (
  SELECT abonne_id
  FROM emprunt
  GROUP BY abonne_id
  HAVING COUNT(*) > 3
);

SELECT nom, email
FROM abonne
WHERE id IN (
  SELECT abonne_id
  FROM emprunt
  GROUP BY abonne_id
  HAVI
;

SELECT nom, email
FROM abonne
WHERE id IN (
  SELECT abonne_id
  FROM emprunt
  GROUP BY abonne_id
  HAVING COUNT(*) > 0
);

SELECT a.nom,
  (SELECT o.titre
   FROM emprunt e2
   JOIN ouvrage o ON e2.ouvrage_id = o.id
   WHERE e2.abonne_id = a.id
   ORDER BY e2.date_debut
   LIMIT 1
  ) AS premier_titre
FROM abonne a;

-- ===============================
-- VIEWS BY MONTH
-- ===============================
CREATE VIEW vue_emprunts_mensuels AS
SELECT
  YEAR(date_debut) AS annee,
  MONTH(date_debut) AS mois,
  COUNT(*) AS total_emprunts
FROM emprunt
GROUP BY annee, mois;

SELECT v.annee, v.mois, v.total_emprunts
FROM vue_emprunts_mensuels v
WHERE v.total_emprunts = (
  SELECT MAX(total_emprunts)
  FROM vue_emprunts_mensuels
  WHERE annee = v.annee
);

DROP VIEW vue_emprunts_mensuels;

-- ===============================
-- AUTEUR & OUVRAGE QUERIES
-- ===============================
SELECT a.id, a.nom
FROM auteur a
LEFT JOIN ouvrage o ON o.auteur_id = a.id
WHERE o.id IS NULL;

SELECT a.id, a.nom
FROM auteur a
LEFT JOIN ouvrage o ON o.auteur_id = a.id
WHERE o.id IS NOT NULL;

SELECT * FROM ouvrage;
SELECT * FROM auteur;

-- ===============================
-- CREATE UNIVERSITY SCHEMA
-- ===============================
CREATE DATABASE universite CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE universite;

CREATE TABLE (
;

CREATE TABLE etudiant (
id INT PRIMARY KEY,
nom VARCHAR(50) UNIQUE,
departement VARCHAR(50)
) ENGINE=InnoDB;

DROP TABLE etudiant;

SHOW TABLES;

CREATE TABLE etudiant (
    -> id INT PRIMARY KEY,
    -> nom VARCHAR(50),
    -> email VARCHAR(50) UNIQUE
    -> ) ENGINE=InnoDB;

CREATE TABLE etudiant (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    email VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE professeur (
id INT AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(50),
email VARCHAR(50) UNIQUE,
departement VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE cours(
id AUTO_INCREMENT PRIMARY KEY,
titre VARCHAR(50),
code VARCHAR(50) UNIQUE,
credits INT
) ENGINE = InnoDB;

CREATE TABLE cours(
id INT AUTO_INCREMENT PRIMARY KEY,
titre VARCHAR(50),
code VARCHAR(50) UNIQUE,
credits INT
) ENGINE InnoDB;

CREATE TABLE enseignement(
cours_id INT NOT NULL,
professeur_id INT NOT NULL,
semestre VARCHAR(25) NOT NULL,
PRIMARY KEY (cours_id, professeur_id),
FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (professeur_id) REFERENCES professeur(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE enseignement(
    cours_id INT,
    professeur_id INT,
    semestre VARCHAR(25) NOT NULL,
    PRIMARY KEY (cours_id, professeur_id),
    FOREIGN KEY (cours_id) REFERENCES cours(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professeur_id) REFERENCES professeur(id) ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE=InnoDB;

CREATE TABLE inscription(
etudiant_id INT,
enseignement_cours_id INT,
enseignement_professeur_id INT,
date_inscreption DATE,
PRIMARY KEY (etudiant_id, enseignement_cours_id, enseignement_professeur_id, date_inscreption),
FOREIGN KEY (etudiant_id) REFERENCES etudiant(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (enseignement_cours_id, enseignement_professeur_id) REFERENCES enseignement(cours_id, professeur_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE examen (
id INT AUTO_INCREMENT PRIMARY KEY,
inscription_etudiant_id INT ,
inscription_cours_id INT ,
inscription_professeur_id INT ,
inscription_date_inscription DATE,
date_examen DATE ,
score DECIMAL(4,2) ,
CHECK (score BETWEEN 0 AND 20),
FOREIGN KEY (
inscription_etudiant_id,
inscription_cours_id,
inscription_professeur_id,
inscription_date_inscription
) REFERENCES inscription(
etudiant_id,
enseignement_cours_id,
enseignement_professeur_id,
date_inscreption
)
ON DELETE CASCADE
) ENGINE=InnoDB;

-- ===============================
-- INSERT DATA
-- ===============================
INSERT INTO professeur(nom, email, departement) VALUES 
("Hamid Alami", "alamihamid@gmail.com", "Informatique"), 
("Jamal Nassiri", "nassirijamal@gmail.com", "Mathematique");

INSERT INTO cours (titre, code, credits) VALUES
('Programmation Java', 'CS101', 6),
('Algèbre Linéaire', 'MATH201', 5),
('Bases de Données', 'CS102', 6);

INSERT INTO etudiant (nom, email) VALUES
('Karim', 'karim@mail.com'),
('Samir', 'samir@mail.com'),
("Hassan", "hassan@gmail.com");

INSERT INTO enseignement (cours_id, professeur_id, semestre) VALUES
(1, 1, 'S1'),
(2, 2, 'S1');

INSERT INTO inscription (etudiant_id, enseignement_cours_id, enseignement_professeur_id, date_inscreption) VALUES
(1, 1, 1, '2025-09-01'),
(1, 2, 2, '2025-09-02'),
(2, 1, 1, '2025-09-01'),
(2, 2, 2, '2025-09-02');

INSERT INTO examen(inscription_etudiant_id, inscription_cours_id, inscription_professeur_id, inscription_date_inscription, date_examen, score) VALUES (1, 2, 2, "2025-12-27");
INSERT INTO examen(inscription_etudiant_id, inscription_cours_id, inscription_professeur_id, inscription_date_inscription, date_examen, score) VALUES (1, 2, 2, "2025-09-02", "2025-12-27",25);
INSERT INTO examen(inscription_etudiant_id, inscription_cours_id, inscription_professeur_id, inscription_date_inscription, date_examen, score) VALUES (1, 2, 2, "2025-09-02", "2025-12-27",12);

-- ===============================
-- SELECT QUERIES ON STUDENTS & COURSES
-- ===============================
SELECT * FROM etudiant;
SELECT e.nom from etudiant e JOIN inscription i ON etudiant_id = e.id;
select * from enseingment;
select * from enseignement;
select e.nom from etudiant e JOIN inscription i ON etudiant_id = e.id
JOIN cours c ON enseignement_cours_id = c.id
WHERE c.code = "CS101";

-- ===============================
-- SELECT QUERIES ON PROFESSOR
-- ===============================
SELECT nom, email FROM professeur WHERE departement = "Informatique";

-- ===============================
-- INSCRIPTION & EXAM QUERIES
-- ===============================
SELECT i.*
FROM inscription i
JOIN etudiant e ON i.etudiant_id = e.id
WHERE e.nom = 'Alice'
ORDER BY i.date_inscreption DESC;

SELECT
    e.nom AS etudiant,
    c.titre AS cours,
    ens.semestre,
    i.date_inscreption
FROM inscription i
JOIN etudiant e
    ON i.etudiant_id = e.id
JOIN enseignement ens
    ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c
    ON ens.cours_id = c.id
ORDER BY i.date_inscreption;

-- ===============================
-- STATISTICS & VIEWS
-- ===============================
CREATE VIEW vue_etudiant_charges AS
SELECT
e.nom AS etudiant,
COUNT(i.enseignement_cours_id) AS nombre_inscription,
SUM(c.credits) AS somme_credits
FROM etudiant e JOIN inscription i ON e.id = i.etudiant_id
JOIN enseignement ens ON i.enseignement_cours_id = ens.cours_id AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c ON ens.cours_id = c.id
GROUP BY e.id, e.nom;

SELECT * FROM vue_etudiant_charges;

-- ===============================
-- COURSE INSCRIPTIONS COUNT
-- ===============================
SELECT
    c.titre AS cours,
    COUNT(i.etudiant_id) AS nb_inscriptions
FROM cours c
JOIN enseignement ens
    ON c.id = ens.cours_id
JOIN inscription i
    ON ens.cours_id = i.enseignement_cours_id
    AND ens.professeur_id = i.enseignement_professeur_id
GROUP BY c.id, c.titre;

-- ===============================
-- EXAM STATISTICS
-- ===============================
SELECT
    ens.semestre,
    ROUND(AVG(ex.score), 2) AS moyenne_score
FROM examen ex
JOIN inscription i
    ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
JOIN enseignement ens
    ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
GROUP BY ens.semestre;

SELECT
    etu.nom AS etudiant,
    c.titre AS cours,
    ex.date_examen,
    ex.score
FROM examen ex
JOIN inscription i
    ON ex.inscription_etudiant_id = i.etudiant_id
    AND ex.inscription_cours_id = i.enseignement_cours_id
    AND ex.inscription_professeur_id = i.enseignement_professeur_id
    AND ex.inscription_date_inscription = i.date_inscreption
JOIN enseignement ens
    ON i.enseignement_cours_id = ens.cours_id
    AND i.enseignement_professeur_id = ens.professeur_id
JOIN cours c
    ON ens.cours_id = c.id
JOIN etudiant etu
    ON i.etudiant_id = etu.id
ORDER BY ex.date_examen;

-- ===============================
-- CROSS JOINS
-- ===============================
SELECT e.nom AS etudiant, p.nom AS professeur
FROM etudiant e
CROSS JOIN professeur p
LIMIT 20;

CREATE VIEW vue_performances AS
    SELECT
    e.id AS etudiant_id,
    ->     e.nom,
    ->     ROUND(AVG(ex.score), 2) AS moyenne_score
    -> FROM etudiant e
    -> LEFT JOIN inscription i
    ->     ON e.id = i.etudiant_id
    -> LEFT JOIN examen ex
    ->     ON ex.inscription_etudiant_id = i.etudiant_id
    ->     AND ex.inscription_cours_id = i.enseignement_cours_id
    ->     AND ex.inscription_professeur_id = i.enseignement_professeur_id
    ->     AND ex.inscription_date_inscription = i.date_inscreption
    -> GROUP BY e.id, e.nom;

WITH top_cours AS (
    ->     SELECT
    ->         c.id AS cours_id,
    ->         c.titre,
    ->         c.credits,
    ->         AVG(ex.score) AS moyenne_score
    ->     FROM examen ex
    ->     JOIN inscription i
    ->         ON ex.inscription_etudiant_id = i.etudiant_id
    ->         AND ex.inscription_cours_id = i.enseignement_cours_id
    ->         AND ex.inscription_professeur_id = i.enseignement_professeur_id
    ->         AND ex.inscription_date_inscription = i.date_inscreption
    ->     JOIN enseignement ens
    ->         ON i.enseignement_cours_id = ens.cours_id
    ->         AND i.enseignement_professeur_id = ens.professeur_id
    ->     JOIN cours c
    ->         ON ens.cours_id = c.id
    ->     GROUP BY c.id, c.titre, c.credits
    ->     ORDER BY moyenne_score DESC
    ->     LIMIT 3
    -> )
    -> SELECT titre, credits, ROUND(moyenne_score,2) AS moyenne_score
    -> FROM top_cours;
