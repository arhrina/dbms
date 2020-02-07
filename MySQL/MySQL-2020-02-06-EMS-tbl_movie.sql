USE emsdb;

CREATE TABLE tbl_movie(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    m_rank int UNIQUE,
    m_title VARCHAR(125),
    m_detail_url VARCHAR(255),
    m_img_url VARCHAR(255)
);