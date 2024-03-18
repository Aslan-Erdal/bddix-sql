-- requêtes création des tables

DROP TABLE IF EXISTS village CASCADE; 
DROP TABLE IF EXISTS habitant CASCADE;
DROP TABLE IF EXISTS resserre CASCADE;
DROP TABLE IF EXISTS trophee CASCADE;
DROP TABLE IF EXISTS province CASCADE;
DROP TABLE IF EXISTS categorie CASCADE;
DROP TABLE IF EXISTS qualite CASCADE;
DROP TABLE IF EXISTS potion CASCADE;
DROP TABLE IF EXISTS absorber CASCADE;
DROP TABLE IF EXISTS fabriquer CASCADE;

CREATE TABLE province  (
  num_province SERIAL PRIMARY KEY,
  nom_province VARCHAR(30) NOT NULL ,
  nom_gouverneur VARCHAR(30) NOT NULL 
);


CREATE TABLE categorie  (
  code_cat CHAR (3) PRIMARY KEY,
  nom_categ VARCHAR(50),
  nb_points INT
); 



CREATE TABLE qualite  (
  num_qualite SERIAL PRIMARY KEY ,
  lib_qualite VARCHAR(30)
);



CREATE TABLE village  (
  num_village SERIAL PRIMARY KEY ,
  nom_village VARCHAR(30) NOT NULL ,
  nb_huttes INT NOT NULL DEFAULT 1,
  num_province INT NOT NULL,
  constraint fk_province FOREIGN KEY (num_province) REFERENCES province (num_province)
) ;



CREATE TABLE resserre (
  num_resserre SERIAL PRIMARY KEY ,
  nom_resserre VARCHAR(30) NOT NULL ,
  superficie INT NOT NULL DEFAULT 0,
  num_village INT NOT NULL,
  CONSTRAINT fk_village FOREIGN KEY (num_village) REFERENCES village (num_village)
) ;



CREATE TABLE habitant (
  num_hab SERIAL PRIMARY KEY,
  nom VARCHAR(30),
  age INT,
  num_qualite INT,
  num_village INT,
  CONSTRAINT fk_qualite FOREIGN KEY (num_qualite) REFERENCES qualite (num_qualite),
  CONSTRAINT fk_village FOREIGN KEY (num_village) REFERENCES village (num_village)
);



CREATE TABLE trophee  (
  num_trophee SERIAL PRIMARY KEY ,
  date_prise DATE NOT NULL,
  code_cat CHAR(3),
  num_preneur INT,
  num_resserre INT,
  CONSTRAINT fk_habitant FOREIGN KEY (num_preneur) REFERENCES habitant (num_hab),
  CONSTRAINT fk_resserre FOREIGN KEY (num_resserre) REFERENCES resserre(num_resserre),
  CONSTRAINT fk_categorie FOREIGN KEY (code_cat) REFERENCES categorie (code_cat)
);



CREATE TABLE potion (
  num_potion SERIAL PRIMARY KEY ,
  lib_potion VARCHAR(40),
  formule VARCHAR(30),
  constituant_principal VARCHAR(30)
);


CREATE TABLE absorber  (
  num_potion INT NOT NULL,
  date_a DATE,
  num_hab INT,
  quantite INT,
  PRIMARY KEY (date_a, num_potion, num_hab),
  constraint fk_potion FOREIGN KEY (num_potion) REFERENCES potion (num_potion),
  CONSTRAINT fk_habitant FOREIGN KEY (num_hab) REFERENCES habitant (num_hab)
);



CREATE TABLE fabriquer (
    num_potion INT NOT NULL ,
    num_hab INT NOT NULL,  
    PRIMARY KEY (num_potion , num_hab),
    CONSTRAINT fk_habitant FOREIGN KEY (num_hab) REFERENCES habitant(num_hab),
    CONSTRAINT fk_potion FOREIGN KEY (num_potion) REFERENCES potion(num_potion)
);