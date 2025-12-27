# Jointures, vues et sous-requêtes
## Jointures classiques
### INNER JOIN : ne conserver que les lignes présentes dans les deux tables
récupérer tous les emprunts avec le nom de l’abonné
```sql
SELECT e.abonne_id, a.nom, e.date_debut
    FROM emprunt e
    INNER JOIN abonne a
    ON e.abonne_id = a.id;
+-----------+-------+------------+
| abonne_id | nom   | date_debut |
+-----------+-------+------------+
|         1 | Karim | 2025-06-18 |
|         3 | Samir | 2025-06-19 |
+-----------+-------+------------+
2 rows in set (0.02 sec)
```
### LEFT JOIN : inclure tous les enregistrements de la table de gauche
lister tous les ouvrages et, si disponibles, la date de leur dernier emprunt
```sql
SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
    FROM ouvrage o
    LEFT JOIN emprunt e
    ON e.ouvrage_id = o.id
    GROUP BY o.id, o.titre;
+---------------------+-----------------+
| titre               | dernier_emprunt |
+---------------------+-----------------+
| Les Misérables      | NULL            |
| 1984                | 2025-06-18      |
| Pride and Prejudice | 2025-06-19      |
+---------------------+-----------------+
3 rows in set (0.02 sec)
```
### CROSS JOIN : produit cartésien
combiner tous les abonnés avec tous les auteurs (attention au volume !)
```sql
SELECT a.nom AS abonne, au.nom AS auteur
    FROM abonne a
    CROSS JOIN auteur au;
+--------+---------------+
| abonne | auteur        |
+--------+---------------+
| Samir  | Victor Hugo   |
| Karim  | Victor Hugo   |
| Samir  | George Orwell |
| Karim  | George Orwell |
| Samir  | Jane Austen   |
| Karim  | Jane Austen   |
+--------+---------------+
6 rows in set (0.01 sec)
```
## Étape 3 – Création et utilisation de vues
### Créer une vue
Définir une vue qui regroupe le nom de l’abonné et le nombre total d’emprunts
Interroger la vue
Modifier et supprimer une vue
- <img width="960" height="1008" alt="image" src="https://github.com/user-attachments/assets/1b249fe6-e3b3-49db-92f8-c8beb171e1da" />
## Étape 4 – Sous-requêtes non corrélées
### Sous-requête dans SELECT
Récupérer pour chaque ouvrage le nombre d’emprunts :
```sql
SELECT
    titre,
    (SELECT COUNT(*)
    FROM emprunt e
    WHERE e.ouvrage_id = o.id
    ) AS nb_emprunts
    FROM ouvrage o;
+---------------------+-------------+
| titre               | nb_emprunts |
+---------------------+-------------+
| Les Misérables      |           0 |
| 1984                |           1 |
| Pride and Prejudice |           1 |
+---------------------+-------------+
3 rows in set (0.01 sec)
```
### Sous-requête dans WHERE
Lister les abonnés qui ont plus de 3 emprunts sans utiliser GROUP BY :
- <img width="480" height="147" alt="image" src="https://github.com/user-attachments/assets/85dedc37-2197-475f-acaf-ed7ee25ed7c8" />
- <img width="480" height="221" alt="image" src="https://github.com/user-attachments/assets/9bf1164c-7991-45c2-8b84-6d1f8adc2633" />
## Étape 5 – Sous-requêtes corrélées
###  pour chaque abonné, afficher son nom et le titre de son premier emprunt
```sql
SELECT a.nom,
    (SELECT o.titre
    FROM emprunt e2
    JOIN ouvrage o ON e2.ouvrage_id = o.id
    WHERE e2.abonne_id = a.id
    ORDER BY e2.date_debut
    LIMIT 1
    ) AS premier_titre
    FROM abonne a;
+-------+---------------------+
| nom   | premier_titre       |
+-------+---------------------+
| Karim | 1984                |
| Samir | Pride and Prejudice |
+-------+---------------------+
2 rows in set (0.01 sec)
```
## Étape 6 – Combiner vues et sous-requêtes
### Créer une vue résumant les emprunts par mois :
### Utiliser cette vue dans une sous-requête pour extraire les mois les plus chargés :
- <img width="480" height="370" alt="image" src="https://github.com/user-attachments/assets/35c84e73-6a19-4835-b748-7c55ccee53a2" />
## Étape 7 – Exercices pratiques
### Exercice 1 :
- <img width="480" height="436" alt="image" src="https://github.com/user-attachments/assets/342cf3a1-facd-4c40-bb9a-ab28b36a36b0" />
### Exercice 2 :
- <img width="480" height="273" alt="image" src="https://github.com/user-attachments/assets/47cf7345-02ac-4a77-a51b-bb2fa9902dfc" />
### Exercice 3 :
- <img width="480" height="317" alt="image" src="https://github.com/user-attachments/assets/bf38bb06-9407-47f6-b9b6-4de7685b7609" />
