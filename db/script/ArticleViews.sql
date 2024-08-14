CREATE TABLE ArticleViews (
    Id SERIAL PRIMARY KEY,
    ArticleId INTEGER NOT NULL,
    IpAddress VARCHAR(255) NOT NULL,
    ViewDate TIMESTAMP NOT NULL,
    CONSTRAINT fk_article FOREIGN KEY (articleId) REFERENCES articles(id)
);