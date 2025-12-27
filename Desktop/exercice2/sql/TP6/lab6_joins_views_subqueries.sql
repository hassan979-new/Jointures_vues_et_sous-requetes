CREATE VIEW vue_emprunts_par_abonne AS
SELECT a.id, a.nom, COUNT(e.abonne_id) AS total_emprunts
FROM abonne a
LEFT JOIN emprunt e
  ON e.abonne_id = a.id
GROUP BY a.id, a.nom;

CREATE VIEW vue_emprunts_mensuels AS
SELECT
  YEAR(date_debut) AS annee,
  MONTH(date_debut) AS mois,
  COUNT(*) AS total_emprunts
FROM emprunt
GROUP BY annee, mois;

CREATE VIEW vue_abonnes_actifs_par_mois AS
SELECT
    YEAR(date_debut) AS annee,
    MONTH(date_debut) AS mois,
    COUNT(DISTINCT abonne_id) AS abonnes_actifs
FROM emprunt
GROUP BY YEAR(date_debut), MONTH(date_debut);

SELECT e.abonne_id, a.nom, e.date_debut
FROM emprunt e
INNER JOIN abonne a ON e.abonne_id = a.id;

SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
FROM ouvrage o
LEFT JOIN emprunt e ON e.ouvrage_id = o.id
GROUP BY o.id, o.titre;

SELECT a.nom AS abonne, au.nom AS auteur
FROM abonne a
CROSS JOIN auteur au;

SELECT *
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 0;

SELECT titre,
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

SELECT v.annee, v.mois, v.total_emprunts
FROM vue_emprunts_mensuels v
WHERE v.total_emprunts = (
  SELECT MAX(total_emprunts)
  FROM vue_emprunts_mensuels
  WHERE annee = v.annee
);

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

SELECT
    o.id,
    o.titre,
    a.nom AS dernier_abonne,
    e.date_debut AS date_dernier_emprunt
FROM ouvrage o
JOIN emprunt e ON e.ouvrage_id = o.id
JOIN abonne a ON a.id = e.abonne_id
WHERE e.date_debut = (
    SELECT MAX(e2.date_debut)
    FROM emprunt e2
    WHERE e2.ouvrage_id = o.id
);
