DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS resources;
CREATE TABLE resources (
    id SERIAL PRIMARY KEY,
    author_id INT(11) NOT NULL,
    catalog_id INT(11) NOT NULL,
    title VARCHAR(20) NOT NULL,
    annotation VARCHAR(50) DEFAULT '',
    kind VARCHAR(20) DEFAULT '',
    usage_cond VARCHAR(100) DEFAULT '',
    link VARCHAR(100) DEFAULT ''
);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    date_of_birth DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS activities;
CREATE TABLE activities (
    id SERIAL PRIMARY KEY,
    user_id INT(11) NOT NULL,
    resource_id INT(11) NOT NULL
);
