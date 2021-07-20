 CREATE TABLE tbl_gallery (
    img_seq NUMBER PRIMARY KEY,
   img_title nVARCHAR2(125),
   img_text nVARCHAR2(1000),
   img_file nVARCHAR2(255)
);

CREATE SEQUENCE SEQ_GALLERY
START WITH 1 INCREMENT BY 1;

CREATE TABLE tbl_images(
    IMG_FILE_SEQ NUMBER PRIMARY KEY,
    IMG_FILE_P_CODE NUMBER,
    IMG_FILE_ORIGIN_NAME nVARCHAR2(255),
    IMG_FILE_UPLOAD_NAME nVARCHAR2(255)
);

CREATE SEQUENCE SEQ_IMAGES START WITh 1 INCREMENT BY 1;

-- 200107 테이블 수정

DELETE FROM tbl_images;
DELETE FROM tbl_gallery;

ALTER TABLE tbl_images ADD CONSTRAINT FK_IMAGE FOREIGN KEY (img_file_p_code)
REFERENCES tbl_gallery(img_seq) ON DELETE CASCADE; -- tbl_gallery 테이블의 레코드가 삭제되면 같이 tbl_image의 연관된 레코드를 모두 삭제

ALTER TABLE tbl_images DROP CONSTRAINT FK_IMAGE;

-- 200108 유저 테이블 생성
CREATE TABLE "TBL_USER" 
   (	"U_ID" VARCHAR2(125 BYTE) NOT NULL ENABLE, 
	"U_NICK" NVARCHAR2(125), 
	"U_NAME" NVARCHAR2(125) NOT NULL ENABLE, 
	"U_PASSWORD" VARCHAR2(125 BYTE) NOT NULL ENABLE, 
	"U_TEL" VARCHAR2(20 BYTE), 
	"U_GRADE" VARCHAR2(5 BYTE), 
	 PRIMARY KEY ("U_ID")
);