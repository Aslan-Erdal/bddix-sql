--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
select * from potion;
--2. Liste des noms des trophées rapportant 3 points. (2 lignes)
select distinct c.nom_categ, t.code_cat, c.code_cat from trophee as t join categorie c on t.code_cat = c.code_cat where c.nb_points = 3;
-- another solution
select c.nom_categ from categorie c where c.nb_points = 3;

--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
select nom_village from village where nb_huttes > 35;

--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT t.num_trophee
FROM trophee as t
WHERE t.date_prise  BETWEEN '2052-05-01' AND '2052-06-30';

--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
select h.nom 
from habitant h
where h.nom like 'A%r%';

--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
select distinct num_hab from absorber where num_potion= 1 or num_potion=3 or num_potion=4;

--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
select t.num_trophee, t.date_prise, c.nom_categ, h.nom from trophee t 
join categorie c on t.code_cat = c.code_cat 
join habitant h on t.num_preneur = h.num_hab;

--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
select nom from habitant h join village v on h.num_village = v.num_village where nom_village='Aquilona';

--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
select nom from habitant h 
join trophee t on h.num_hab = t.num_preneur 
join categorie c on t.code_cat = c.code_cat where c.nom_categ = 'Bouclier de Légat';

--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes)
select p.lib_potion, p.formule, p.constituant_principal from potion p 
join fabriquer f on p.num_potion = f.num_potion 
join habitant h on f.num_hab = h.num_hab where h.nom = 'Panoramix';

--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
select distinct p.lib_potion  from potion p 
join absorber a on p.num_potion = a.num_potion 
join habitant h on h.num_hab = a.num_hab where h.nom = 'Homéopatix';

--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
select h.nom as "Liste des habitants (noms)" from habitant h 
join absorber a on a.num_hab = h.num_hab
join potion p on a.num_potion = (
select p.num_potion from potion p 
join fabriquer f on f.num_potion = p.num_potion
join habitant h on f.num_hab = h.num_hab 
 where h.num_hab = 3
) group by h.nom;

--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
select h.nom as "Liste des habitants (noms)" from habitant h 
join absorber a on a.num_hab = h.num_hab
join potion p on a.num_potion = any(
(select array_agg(p2.num_potion) from potion p2 
join fabriquer f2 on f2.num_potion = p2.num_potion
join habitant h2 on h2.num_hab = f2.num_hab
 where h2.nom = 'Amnésix' limit 1)::INT[]
) group by h.nom; 

--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
select h.nom from habitant h where h.num_qualite is null;

--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
select h.nom from habitant h 
join absorber a on a.num_hab = h.num_hab 
join potion p on p.num_potion = a.num_potion where p.lib_potion = 'Potion magique n°1' 
and a.date_a BETWEEN '2052-02-01' AND '2052-02-28';

--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)
select h.nom, h.age from habitant h order by h.nom asc;

--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
select r.nom_resserre, v.nom_village from resserre r 
join village v on r.num_village = v.num_village order by r.superficie desc;
--***

--18. Nombre d'habitants du village numéro 5. (4)
select count(h.num_hab) as "Nombre d'habitants"  from habitant h join village v ON v.num_village = h.num_village where v.num_village = 5;

--19. Nombre de points gagnés par Goudurix. (5)
select sum(c.nb_points) as "Nombre de points" from habitant h
join trophee t on t.num_preneur  = h.num_hab  
join categorie c  on c.code_cat  = t.code_cat  where h.nom = 'Goudurix';

--20. Date de première prise de trophée. (03/04/52)
select distinct t.date_prise as "Date de première prise de trophée"  from trophee t order by t.date_prise asc limit 1;

--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
select sum(a.quantite) as "Nombre de louches de Potion magique n°2" from potion p 
join absorber a on a.num_potion = p.num_potion where p.lib_potion = 'Potion magique n°2';

--22. Superficie la plus grande. (895)
select r.superficie as "Superficie la plus grande" from resserre r order by r.superficie desc limit 1;
--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
SELECT v.nom_village, (SELECT COUNT(h.nom) FROM habitant h  WHERE v.num_village  = h.num_village) AS nombre FROM village v;

--24. Nombre de trophées par habitant (6 lignes)
select h.nom, count(t.num_preneur) as "Nombre de trophees par habitant" 
from trophee t join
     habitant h
     on t.num_preneur  = h.num_hab
group by h.nom , t.num_preneur;

--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
select p.nom_province, round(avg(h.age),0) as "Moyenne d'âge des habitans" from province p 
join village v on v.num_province = p.num_province
join habitant h on v.num_village = h.num_village
group by p.nom_province;

--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
select  h.nom as "Nom d'habitant", count(a.quantite) as "Nombre de potions différentes absorbées" from potion p 
join absorber a on a.num_potion = p.num_potion 
join habitant h on h.num_hab  = a.num_hab
group by h.nom;

--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)
select  h.nom as "Nom d'habitant", a.quantite from potion p 
join absorber a on a.num_potion = 4 
join habitant h on h.num_hab  = a.num_hab
 where a.quantite > 2
group by h.nom, a.quantite;

--***
--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
select v.nom_village as "Noms des villages dans lesquels on trouve une resserre" from village v 
join resserre r on v.num_village = r.num_village;
-- select v.nom_village as "Noms des villages dans lesquels on trouve une resserre" from village v join resserre r on v.num_village = r.num_village order by  v.nom_village asc;

--29. Nom du village contenant le plus grand nombre de huttes. (Gergovie)
select v.nom_village, v.nb_huttes as "contenant le plus grand nombre de huttes est"
from village v where v.nb_huttes = (select max(nb_huttes) from village);

--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
select h.nom, count(t.num_preneur) as trophées from habitant h 
join trophee t on h.num_hab = t.num_preneur
group by h.nom HAVING COUNT(t.num_preneur) > (select count(t.num_preneur) from trophee t 
join habitant h on t.num_preneur = h.num_hab where h.nom = 'Obélix');