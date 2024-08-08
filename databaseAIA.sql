DROP DATABASE IF EXISTS INSURANCE_AIA ;
CREATE DATABASE IF NOT EXISTS INSURANCE_AIA;
SHOW DATABASES;
USE INSURANCE_AIA;

-- customer 1
DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
	cus_ID					CHAR(8) NOT NULL, 		 
	cus_Fname 				NVARCHAR(65)  NOT NULL,
    cus_Lname 				NVARCHAR(65)  NOT NULL,
    cus_email 				NVARCHAR(65) NOT NULL,
    career 					NVARCHAR(65)  NOT NULL,
	cus_phone 				CHAR(10) NOT NULL,
    cus_identity_Number	 	CHAR(13) NOT NULL,
    cus_fam_info 			NVARCHAR(65) NOT NULL,
    cus_sex 				NVARCHAR(6) NOT NULL,
    cus_DOB 				DATETIME NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (cus_ID)
);

-- AGENT 2
DROP TABLE IF EXISTS Agent;
CREATE TABLE Agent (
	agent_ID	              CHAR(8)	not null unique ,
	agent_Fname	              NVARCHAR(30) not null ,				
	agent_Lname	              NVARCHAR(30) not null ,				
	agent_identity_number     CHAR(13) not null ,		
	agent_email	              VARCHAR(50) ,				
	agent_phone		          CHAR(10) ,
    CONSTRAINT PK_Agent PRIMARY KEY (agent_ID)
);

-- Care_taker 3
DROP TABLE IF EXISTS Care_taker;
CREATE TABLE Care_taker(
	care_ID 					CHAR(8) NOT NULL,
	care_Fname 					VARCHAR(20) NOT NULL,
    care_Lname 					VARCHAR(20)  NOT NULL,
    care_email 					VARCHAR(65),
    care_graduation 			VARCHAR(20) NOT NULL,
    care_experience				VARCHAR(65) ,
    care_DOB 					DATE NOT NULL,
    T_care_ID 					CHAR(8) references Care_taker(care_ID)  ,
    PRIMARY KEY (care_ID) ,
    FOREIGN KEY (T_care_ID) REFERENCES Care_taker (care_ID)
);

-- Insurance plan Table 4
drop table if exists Insurance_plan;
create table Insurance_plan (
	insurance_ID	          CHAR(8) not null unique ,
    cost	                  INT(9) not null ,
    period		              DECIMAL not null ,
    insurance_name            VARCHAR(70) ,
    constraint PK_Insurance_plan primary key (insurance_ID)
);
-- Promotion Table 5
DROP TABLE IF EXISTS Promotion;
CREATE TABLE Promotion (
	promotion_ID              CHAR(10) not null unique ,
    PM_type                   CHAR(1) not null ,
    PM_name                   NVARCHAR(30) not null ,
    PM_start_date             DATETIME not null ,
    PM_due_date               DATETIME not null ,
	constraint PK_Promotion primary key (promotion_ID) ,
    constraint check_type check ( PM_type in ('F', 'N' )) 
);

-- Privilege Table 6
DROP TABLE IF EXISTS Privilege;
CREATE TABLE Privilege (
	PV_no 					CHAR(5) NOT NULL, 		 
	PV_start_date 			DATETIME NOT NULL,
    PV_Type 				NVARCHAR(50) NOT NULL,
    PV_due_date				DATETIME NOT NULL,
    PV_quota  				VARCHAR(50) NOT NULL,
    Claim_methods			VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Privilege PRIMARY KEY (PV_no)
    );
    
-- Point accumulation 7
DROP TABLE IF EXISTS Point_accumulation;
CREATE TABLE Point_accumulation (
	point_ID 				CHAR(5) NOT NULL, 		 
    Pcondition 				VARCHAR(20),
    point_name 				VARCHAR(20)  NOT NULL,
    PRank 					VARCHAR(20),
    point_quantity 			VARCHAR(20),
    point_due_date 			DATETIME,
    CONSTRAINT PK_Point_accumulation PRIMARY KEY (point_ID)
);

-- course 8
DROP TABLE IF EXISTS Course;
CREATE TABLE Course(
	course_no 				CHAR(8) NOT NULL,
	course_location 		VARCHAR(100) NOT NULL,
    course_type 			VARCHAR(100)  NOT NULL,
    course_start_date 		DATETIME,
    course_content  		VARCHAR(100) NOT NULL,
    course_due_date 		DATETIME NOT NULL,
    CONSTRAINT PK_Course PRIMARY KEY (course_no)
);

-- Insurance_license_exam 9
DROP TABLE IF EXISTS Insurance_license_exam;
CREATE TABLE Insurance_license_exam(
	exam_ID 			CHAR(8) NOT NULL,
	exam_type 			VARCHAR(100) NOT NULL,
    exam_score 			INT  NOT NULL,
    attendee_quota 		INT NOT NULL,
    exam_due_date 		DATETIME NOT NULL,
    exam_location 		VARCHAR(100) NOT NULL,
    exam_start_date 	DATETIME NOT NULL,
    PRIMARY KEY (exam_ID) 
);
SET FOREIGN_KEY_CHECKS=0; 
-- Problem Table 10
DROP TABLE IF EXISTS Problem;
CREATE table Problem(
	Topic 			varchar(20) not null,
	pb_data 		datetime not null,
	details 		varchar (65) not null,
	solution 		varchar (65) not null,
    cus_ID 			CHAR(8)  REFERENCES Customer(cus_ID)
	
);

-- get 11
DROP TABLE IF exists `get` ;
CREATE TABLE `get` (
    cus_id 			CHAR(8) NOT NULL,
    PV_no 			CHAR(5) NOT NULL,
    CONSTRAINT PK_Get PRIMARY KEY (cus_id, PV_no),
    CONSTRAINT FK_Get_Customer FOREIGN KEY (cus_id) REFERENCES Customer(cus_ID),
    CONSTRAINT FK_Get_Privilege FOREIGN KEY (PV_no) REFERENCES Privilege(PV_no)
);
-- exchange 12
DROP TABLE IF exists `exchange` ;
CREATE TABLE `exchange` (
    cus_id 			CHAR(8) NOT NULL ,
    point_id 		CHAR(5) NOT NULL,
	FOREIGN KEY (cus_id) REFERENCES Customer(cus_ID),
    FOREIGN KEY (point_id) REFERENCES Point_accumulation(point_ID)
);
-- have 13
drop table if exists have;
create table have (
	insurance_ID	CHAR(8) not null ,
    promotion_ID	CHAR(10) not null ,
    constraint FK_have foreign key (insurance_ID) references Insurance_plan(insurance_ID) ,
    constraint FK_have_2 foreign key (promotion_ID) references Promotion(promotion_ID)
);

-- sell Table 14
drop table if exists sell;
create table sell (
	agent_ID	              CHAR(8) not null ,
    insurance_ID	          CHAR(8) not null ,
    sell_date		          DATETIME not null ,
    payment		              CHAR(4) not null ,
    constraint FK_sell foreign key (agent_ID) 
    references Agent(agent_ID) ,
    constraint FK_sell_2 foreign key (insurance_ID) 
    references Insurance_plan(insurance_ID)
);

-- Lean Table 15
DROP TABLE IF EXISTS Learn;
CREATE TABLE Learn (
	course_no 		CHAR(8) NOT NULL,
    APC_ID CHAR(8)  REFERENCES Applicant (course_no ),
	PRIMARY KEY (course_no, APC_ID),
    FOREIGN KEY (course_no) REFERENCES Course (course_no)
    
);

-- exam Table 16
DROP TABLE IF EXISTS exam;
CREATE TABLE exam (
	exam_ID 		CHAR(8) NOT NULL,
    APC_ID 			CHAR(8) REFERENCES Applicant (exam_ID),
	PRIMARY KEY (exam_ID,APC_ID) ,
    FOREIGN KEY (exam_ID) REFERENCES Insurance_license_exam (exam_ID)
);

-- Applicant 17
DROP TABLE IF EXISTS Applicant;
CREATE TABLE Applicant(
	APC_ID 					CHAR(8) NOT NULL,
	APC_Fname 				VARCHAR(20) NOT NULL,
    APC_Lname 				VARCHAR(20)  NOT NULL,
    ACP_identity_Number 	CHAR(13) NOT NULL,
    ACP_phone 				INT NOT NULL,
    APC_graduation 			VARCHAR(20) NOT NULL,
    APC_DOB 				DATE NOT NULL,
    APC_email 				VARCHAR(50),
    care_ID 				char(8) NOT NULL references Care_taker(care_ID)  ,
	PRIMARY KEY (APC_ID),
    FOREIGN KEY (care_ID) REFERENCES Care_taker(care_ID)
);

-- Agent_license 18
drop table if exists Agent_license;
CREATE TABLE Agent_license (
	license_num 			CHAR(10) NOT NULL, 
	license_picture 		VARCHAR(70), 
    license_type 			NVARCHAR(20) NOT NULL,
    license_Date 			DATE NOT NULL,
    license_barcode			NVARCHAR(75) NOT NULL, 
    license_due_date 		DATE NOT NULL,
	CONSTRAINT PK_Agent_license PRIMARY KEY (license_num)
);

-- take_care 19
DROP TABLE IF EXISTS take_care;
 CREATE TABLE take_care(
	cus_ID   			CHAR(8) NOT NULL,
    agent_ID			CHAR(8) NOT NULL,
    PRIMARY KEY (cus_ID,agent_ID),
	CONSTRAINT FK_customer  FOREIGN KEY (cus_ID) REFERENCES customer(cus_ID),
	CONSTRAINT FK_Agent  FOREIGN KEY (agent_ID) REFERENCES Agent(agent_ID)
);   

-- regist 20
DROP TABLE IF EXISTS regist;
create table regist(
	APC_ID 				char(8) not null ,
    agent_ID 			char(8)  ,
	status_license 		char(2) not null,
    PRIMARY KEY (APC_ID,agent_ID),
    foreign key (APC_ID) references applicant(APC_ID) ,
    foreign key (agent_ID) references agent(agent_ID));
    
-- buy 21
DROP TABLE IF EXISTS buy;
create table buy(
	cus_ID 				char(8) not null ,
    insurance_ID 		char(8) not null ,
    foreign key (cus_ID) references customer(cus_ID) ,
    foreign key (insurance_ID) references insurance_plan(insurance_ID));
-- INSERT DATA

-- Customer
INSERT INTO Customer (cus_ID, cus_Fname, cus_Lname, cus_email, career, cus_phone, cus_identity_Number, cus_fam_info, cus_sex, cus_DOB)
VALUES ('CUS00001', 'Somchai', 'Chaiyoo', 'Somchai.Chaiyoo@gmail.com', 'Engineer', '0991231668', '5444963733517', 'Spouse: Jame Chaiyoo', 'Male', '1990-01-15'),
('CUS00002', 'Suman', 'Thar', 'Suman.Thar@gmail.com', 'Doctor', '0854432661', '2932333368509', 'Children: 2', 'Female', '1985-08-25'),
('CUS00003', 'Ratapol', 'Polmung', 'Ratapol.Polmung@gmail.com', 'Lawyer', '0997765742', '7298656052166', 'Single', 'Male', '1995-11-02'),
('CUS00004', 'Ariya', 'Thongsawong', 'Ariya.Thongsawong@gmail.com', 'Teacher', '0988876779', '8610788670263', 'Children: 1', 'Female', '1992-03-12'),
('CUS00005', 'Ganda', 'Gingkew', 'Ganda.Gingkew@gmail.com', 'Accountant', '0884726221', '9483830382405', 'Spouse: Sarah Gingkew', 'Male', '1988-07-20'),
('CUS00006', 'Ratchanon', 'Ramamog', 'Ratchanon.Ramamog@gmail.com', 'Graphic Designer', '0998878990', '5279023790501', 'Single', 'Female', '1997-09-08');

-- AGENT
insert into Agent (agent_ID, agent_Fname, agent_Lname, agent_identity_number, agent_email, agent_phone) values
('62440001', 'Phan', 'Riety', '1846657133284', 'Phan.rie@aia.insurance.ac.th', '0884561129') ,
('60440001', 'Minnie', 'Gidle', '1627892334166', 'Minnie.gid@aia.insurance.ac.th', null) ,
('60440002', 'Shuhua', 'Gidle', '1627892334167', 'Shuhua.gid@aia.insurance.ac.th', '0912364789') ,
('62450001', 'Soobin', 'Leader', '1659970133280', null, '0932547786'),
('64450003', 'Hueningkai', 'Vocal', '1365634011574', 'Hueningkai.vol@aia.insurance.ac.th', '0854627913'),
('62440002', 'Yeonjun', 'Rapper', '1365634011574', 'Yeonjun.rap@aia.insurance.ac.th', '0845679921'),
('62440003', 'Beomgyu', 'Dancer', '1476652479130', 'Beomgyu.dan@aia.insurance.ac.th', '0945687512'),
('64450002', 'Teahyun', 'Vocal', '1645792008314', 'Teahyun.vol@aia.insurance.ac.th', '0845124380') ;

-- Care_taker
INSERT INTO Care_taker(care_ID,care_Fname,care_Lname,care_email,care_graduation,care_experience,care_DOB,T_care_ID)
VALUES ("ct000001","Anshisa","Intarama","anshisa.int@gmail.com","Diploma Vocational","พนักงานคลินิกเสริมความงาม","1999-12-03",null),
("ct000002","Thawan","Tanajaroenkij","thawan.tana@gmail.com", "Bachelor Degrees","พนักงานร้านสะดวกซื้อ" , "1994-03-23" , null),
("ct000003","Jakarin" , "Makmee","jakarin.makk@gmail.com","Diploma Vocational","แพ็คสินค้า" , "1995-11-17","ct000002") , 
("ct000004" ,"Tara","Siripachasab","tara.siripa@gmail.com","Diploma Vocational" ,"ขับรถ", "1994-02-14","ct000003"),
("ct000005", "Thida","Paisarn","thida.paisarn@gmail.com","Bachelor Degrees","บรรณารักษ์" , "1993-04-25","ct000003"),
("ct000006","Piyada","Preedasirikul","piyada.preeda@gmail.com","Diploma Vocational","พนักงานต้อนรับในโรงแรม","1999-02-12","ct000005");

-- Insurance_plan
-- ID -> department -- ,type(nomal 01, special 00) ,number ----
insert into Insurance_plan (insurance_ID, cost, period, insurance_name) values
('44010056', 500000 , 1 , 'AI/RCC | สัญญาเพิ่มเติมกลุ่มอุบัติเหตุ') ,
('44016169', 20000 , 0.5 , 'MICRO200 | ประกันอุบัติเหตุส่วนบุคคล') ,
('44010005', 10000000 , 20 , 'AIA Health Saver - UDR | ประกันสุขภาพเหมาจ่าย' ) ,
('45013796', 20000000 , 99 , 'AIA Issara Plus (Unit Linked) | ประกันชีวิตแบบยูนิต ลิงค์') ,
('45012365', 1000000 , 50 , 'AIA Annuity Fix | ประกันชีวิตแบบบำนาญ') ,
('45001069', 590000 , 10 , 'AIA Senior Happy | ประกันชีวิตเพื่อความคุ้มครอง') ,
('45010896', 2300000 , 10 , 'Term 5 / 10 / 15 / 20 | ประกันชีวิตเพื่อความคุ้มครอง') ; 

-- Promotion
-- ID -> do not know ---- ,department -- ,number ----
insert into Promotion (promotion_ID, PM_type, PM_name, PM_start_date, PM_due_date) values
('5462440025', 'F', 'Sabaidee' ,'2018-01-01 00:00:00', '2018-01-02 00:00:00') ,
('2548440120', 'F', 'Teddybear' ,'2020-12-02 13:40:00', '2020-12-02 14:40:00') ,
('1576450136', 'N', 'Tomorrow' ,'2018-02-13 23:59:00', '2018-02-14 00:00:00') ,
('5432450025', 'F', 'Together' ,'2018-02-20 00:00:00', '2018-05-20 23:59:00') ,
('6287440079', 'N', 'Springday' ,'2019-08-14 16:00:00', '2019-08-31 16:00:00') ,
('2398440156', 'F', 'Dum Dum' ,'2020-07-21 17:30:00', '2020-07-21 23:55:00') ,
('6987440099', 'F', 'Savagelove' ,'2022-10-02 18:30:00', '2022-10-20 00:00:00') ;

-- Privilege
INSERT INTO Privilege (PV_no, PV_start_date, PV_Type, PV_due_date, PV_quota, Claim_methods)
VALUES 
('PV001', '2023-07-21 09:00:00', 'Gold', '2024-07-20 23:59:59', '5000 Points', 'Online Claim'),
('PV002', '2023-07-21 10:30:00', 'Silver', '2024-07-20 23:59:59', '3000 Points', 'In-person Claim'),
('PV003', '2023-07-21 13:45:00', 'Platinum', '2024-12-31 23:59:59', '10000 Points', 'Online Claim'),
('PV004', '2023-07-21 14:20:00', 'Bronze', '2024-07-20 23:59:59', '2000 Points', 'In-person Claim'),
('PV005', '2023-07-21 15:25:00', 'Bronze', '2024-07-20 23:59:59', '3000 Points', 'In-person Claim'),
('PV006', '2023-07-21 16:10:00', 'Gold', '2024-07-20 23:59:59', '5000 Points', 'Online Claim');

-- Point_accumulation
INSERT INTO Point_accumulation (point_ID, Pcondition, point_name, PRank, point_quantity, point_due_date)
VALUES 
('P0001', 'Spend 1,000 THB', 'Bonus Points', 'Silver', '100', '2024-07-31 23:59:59'),
('P0002', 'Spend 5,000 THB', 'Extra Points', 'Gold', '500', '2024-12-31 23:59:59'),
('P0003', 'Spend 2,000 THB', 'Additional Points', 'Silver', '200', '2024-07-31 23:59:59'),
('P0004', 'Spend 10,000 THB', 'Super Points', 'Platinum', '1000', '2024-12-31 23:59:59'),
('P0005', 'Spend 15,000 THB', 'Super Extra Points', 'PlatinumPlus', '1500', '2024-12-31 23:59:59'),
('P0006', 'Spend 500 THB', 'Basic Points', 'Bronze', '50', '2024-07-31 23:59:59');

-- Course
INSERT INTO Course
VALUES ("no.00001","วิทยาลัยเทคโนโลยีศรีธนาพณิชยการ ","การประกันวินาศภัย","2022-08-12 09:00:00","หลักสูตรการขอรับใบอนุญาตเป็นตัวแทนประกันชีวิต","2022-08-12 17:00:00"),
("no.00002", "มหาวิทยาลัยสงขลานครินทร","ประกันภัย","2022-12-12 09:00:00","หลักสูตรการขอรับใบอนุญาตเป็นตัวแทนประกันชีวิต","2022-12-12 17:00:00"),
("no.00003","มหาวิทยาลัยบูรพา","ประกันชีวิต","2023-01-14 09:00:00","หลักสูตรการขอรับใบอนุญาตเป็นตัวแทนประกันชีวิต","2023-01-14 17:00:00"),
("no.00004","มหาวิทยาลัยราชภัฏอุตรดิตถ","การประกันวินาศภัย","2023-02-16 09:00:00","หลักสูตรการขอต่ออายุใบอนุญาตเป็นตัวแทนประกันชีวิต" ,"2023-02-16 17:00:00"),
("no.00005","มหาวิทยาลัยขอนแก่น","ประกันภัย","2023-04-11 09:00:00","หลักสูตรการขอต่ออายุใบอนุญาตเป็นตัวแทนประกันชีวิต" ,"2023-04-11 17:00:00"),
("no.00006","มหาวิทยาลัยราชภัฏอุบลราชธานี","ประกันชีวิต","2023-05-20 09:00:00","หลักสูตรการขอต่ออายุใบอนุญาตเป็นตัวแทนประกันชีวิต" ,"2023-05-20 17:00:00");

-- Insurance_license_exam
INSERT INTO Insurance_license_exam
VALUES ("EX000001","ประกันภัย", 100,50,"2022-02-10 08:30:00","วิทยาลัยเทคโนโลยีศรีธนาพณิชยการ","2022-02-10 10:30:00"),
("EX000002","ประกันชีวิต", 100,50,"2022-02-10 08:30:00","มหาวิทยาลัยสงขลานครินทร","2022-02-10 10:30:00"),
("EX000003","การประกันวินาศภัย", 100,50,"2022-12-15 08:30:00","มหาวิทยาลัยบูรพา","2022-12-15 10:30:00"),
("EX000004","ประกันภัย", 100,50,"2023-01-03 08:30:00","มหาวิทยาลัยราชภัฏอุตรดิตถ","2023-01-03 10:30:00"),
("EX000005","ประกันชีวิต", 100,50,"2023-02-20 08:30:00","มหาวิทยาลัยขอนแก่น","2022-02-20 10:30:00"),
("EX000006","การประกันวินาศภัย", 100,50,"2023-04-30 08:30:00","มหาวิทยาลัยราชภัฏอุบลราชธานี","2023-04-30 10:30:00");

-- Problem
Insert Into Problem 
Values ("การบริการ", "2023-09-08" , "การีบริการดำเนินเงานช้ามากทำให้เสียเวลา" , "ปรับปรุงแก้ไขการบริการให้เร็วขึ้น","CUS00003"),
("ระบบ" , "2023-08-09" , "เข้าสู้ระบบไม่ได้" , "ทำการแก้ไขระบบ","CUS00001"),
("พนักงาน" , "2023-07-03" , "พนักงานไม่รอบคอบในการบริการ" , "อบรบพนักงานใหม่","CUS00004"),
("การชำระเงิน" , "2023-06-05" , "ช่องทางการชำระเงินน้อย" , "เพิ่มช่องทางการชำระเงิน","CUS00002") ;

-- gets
INSERT INTO `get` (cus_id, PV_no)
VALUES
('CUS00001', 'PV001'),
('CUS00002', 'PV002'),
('CUS00001', 'PV003'),
('CUS00003', 'PV001'),
('CUS00002', 'PV004'),
('CUS00004', 'PV005'),
('CUS00005', 'PV002'),
('CUS00004', 'PV003'),
('CUS00006', 'PV006'),
('CUS00002', 'PV005') ;

-- exchanges
INSERT INTO `exchange` (cus_id, point_id)
VALUES
('CUS00001', 'P0001'),
('CUS00002', 'P0002'),
('CUS00003', 'P0003'),
('CUS00001', 'P0004'),
('CUS00002', 'P0001'),
('CUS00004', 'P0003'),
('CUS00005', 'P0006'),
('CUS00004', 'P0004'),
('CUS00003', 'P0002'),
('CUS00002', 'P0001') ;

-- have
insert into have (insurance_ID, promotion_ID) values
('45001069', '5432450025') ,
('45013796', '6987440099') ,
('44010005', '5432450025') ,
('44010056', '2548440120') ,
('45001069', '2548440120') ,
('45013796', '1576450136') ,
('45013796', '6287440079') ,
('45013796', '2398440156') ,
('45012365', '6287440079') ,
('44016169', '1576450136') ,
('45010896', '6987440099') ,
('44010005', '2548440120') ;

-- sell
insert into sell  values
('60440001', '44010056', '2022-06-18 09:16:23', 'cash') ,
('62440001', '44016169', '2019-02-16 10:12:55', 'code') , 
('62450001', '45013796', '2019-02-16 15:28:00', 'code') , 
('62450001', '44010005', '2020-11-01 14:23:10', 'card') , 
('62440001', '45001069', '2020-03-31 07:07:02', 'cash') , 
('64450002', '45013796', '2021-05-28 20:26:41', 'cash') ,
('64450002', '45001069', '2022-06-13 13:23:10', 'card') ,
('64450003', '44016169', '2021-12-02 17:45:23', 'card') ,
('62440001', '45001069', '2022-08-05 14:48:48', 'code') ,
('62440001', '44010056', '2021-06-23 16:25:07', 'card') ,
('60440002', '44016169', '2020-07-19 21:00:09', 'code') ,
('60440002', '45013796', '2019-10-26 19:56:28', 'cash') ;

-- lean
INSERT INTO learn
VALUES ("no.00001","AP000001"),
("no.00002","AP000002"),
("no.00003","AP000003"),
("no.00004","AP000004"),
("no.00005","AP000005"),
("no.00006","AP000006") ;

-- exam
INSERT INTO exam
VALUES ("EX000001","AP000001"),
("EX000002","AP000002"),
("EX000003","AP000003"),
("EX000004","AP000004"),
("EX000005","AP000005"),
("EX000006","AP000006") ;

-- Applicant
INSERT INTO Applicant (APC_ID,APC_Fname,APC_Lname,ACP_identity_Number,ACP_phone,APC_graduation,APC_DOB,APC_email,care_ID)
values ("AP000001","Paktima" , "Rassameedech",1100087654321,0884445555,"Diploma Vocational", "1998-12-20" ,"paktima.ras@gmail.com","ct000001"),
("AP000002","Chayapoom", "Sabma",1100087654322,0991122334,"Diploma Vocational ","1998-04-03" ,"chayapoom.sab@gmail.com","ct000002"),
("AP000003","Nattawee", "Jongjanya",1100087654321,0884445555,"Bachelor Degrees","1999-05-12" ,NULL,"ct000003"),
("AP000004","Punnapoj" , "Jaroenpolwattana ",1100087654321,0884445555,"Diploma Vocational ","1995-08-22" ,"paktima.ras@gmail.com","ct000004"),
("AP000005","Kanoknuch" , "Srisuk",1100087654321,0884445555,"Bachelor Degrees","2000-01-13" ,"paktima.ras@gmail.com","ct000005"),
("AP000006","Nichapa", "Kommak",1100087654321,0884445555,"Diploma Vocational ","1994-03-11" ,NULL,"ct000006");

-- 
INSERT INTO take_care
values ('CUS00001' , '62440001'),
('CUS00002' , '60440001'),
('CUS00003' , '62440001'),
('CUS00004' , '62450001') ,
('CUS00005' , '62440001'),
('CUS00006' , '64450003'),
('CUS00007' , '62440001'),
('CUS00008' , '64450003'),
('CUS00009' , '62440001'),
('CUS00010' , '60440002');

INSERT INTO regist (apc_ID , agent_ID , status_license)
values ('AP000001' , null , 'F'),
('AP000002' , '62440001' , 'P'),
('AP000003' , null , 'F'),
('AP000001' , '64450002' , 'F'),
('AP000004' , null , 'F'),
('AP000003' , null , 'F'),
('AP000005' , '60440002' , 'P'),
('AP000003' , '64450003' , 'P'),
('AP000004' , '62440002' , 'P'),
('AP000006' , '62440004' , 'P'),
('AP000007' , null , 'F');


INSERT INTO buy
values ('CUS00001' , '44010056'),
('CUS00002' , '44016169'),
('CUS00001' , '45010896'),
('CUS00004' , '44010005') ,
('CUS00007' , '45012365'),
('CUS00008' , '44010056'),
('CUS00005' , '45012365'),
('CUS00006' , '45013796'),
('CUS00006' , '45001069'),
('CUS00007' , '45010896'),
('CUS00008' , '44010056'),
('CUS00009' , '45012365');

insert into Agent_license (license_num, license_picture, license_type, license_Date, license_barcode, license_due_date) values
( '4452010001', 'https://www.google.com/', 'Heath', '2022-02-10', 'www.google.com/tomorrowxtogether', '2024-02-09') ,
( '2687930001', 'https://www.google.com/', 'Accident', '2018-12-07', 'www.pinkvilla.com', '2019-12-06') ,
( '2687930003', 'https://www.google.com/', 'UnitLinked', '2020-06-15', 'www.kpoptop.com', '2021-06-14') ,
( '2687930002', 'https://www.google.com/', 'Life', '2019-04-19', 'www.kpopofficial.com', '2020-04-18') ,
( '4452010002', 'https://www.google.com/', 'UnitLinked', '2022-08-23', 'www.celebrities.id%2Fread%2Fsoobin', '2024-08-22') ,
( '3697450002', 'https://www.google.com/', 'Heath', '2020-07-05', 'https:www.allkpop.com', '2021-07-04') ,
( '3697450001', 'https://www.google.com/', 'Accident', '2019-02-02', 'www.celebrities.id%2Fread%2Fsoobin', '2020-02-01') ;

