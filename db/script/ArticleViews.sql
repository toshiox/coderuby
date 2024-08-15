CREATE TABLE article_views (
    id SERIAL PRIMARY KEY,
    article_id INTEGER NOT NULL,
    ip_address VARCHAR(255) NOT NULL,
    view_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_article FOREIGN KEY (article_id) REFERENCES articles(id)
);
