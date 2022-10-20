SELECT * FROM jspwebmarket.member;
alter table board drop foreign key board_ibfk_1;
select * from information_schema.table_constraints where table_name = 'board';
select * from uploaddata;
select * from board;
select * from member;
select * from comment;
select * from reply;

create table member(
id varchar(10) not null,
pass varchar(10) not null,
name varchar(30) not null,
address varchar(50) not null,
regidate datetime default(sysdate()),
primary key (id)
);
-- alter table member add count int;
-- alter table member drop count;
-- alter table member drop tel;
-- alter table member drop addr;
-- alter table member add address varchar(50) not null;
alter table member add pwfind varchar(200);
alter table member add phone varchar(20);
drop table member;

create table uploaddata(
Lat decimal(21,16) not null,
lng decimal(21,16) not null,
memo varchar(50) not null,
regidate datetime default(sysdate()),
num int not null auto_increment,
title varchar(50) not null,
count int,
id varchar(10) not null,
primary key(num)
);
-- alter table uploaddata add regidate datetime default(sysdate());
-- alter table uploaddata add num int not null auto_increment;
-- alter table uploaddata add count int;
-- alter table uploaddata add id varchar(10) not null;
drop table uploaddata;
	
create table board(
num int not null auto_increment,
title varchar(200) not null,
content varchar(2000) not null,
id varchar(10) not null,
postdate date default (current_date),
visitcount int,
primary key (num)
);

create table comment(
deletePK int not null auto_increment,
num int not null,
content varchar(2000) not null,
id varchar(10) not null,
postdate datetime default(sysdate()),
primary key (deletePK)
);
drop table comment;
insert into comment (num, content, id) VALUES(1, '1234', 'ssh');
insert into comment (num, content, id) VALUES(2, '2222', 'ssh');
    
create table reply(
deletePK int not null auto_increment,
selectPK int not null, -- ����� ã�ư����� ���� Į��
num int not null,
content varchar(2000) not null,
id varchar(10) not null,
postdate datetime default(sysdate()),
primary key (deletePK)
);
    
SHOW VARIABLES LIKE 'event%';	
SET GLOBAL event_scheduler = on;
SELECT * FROM information_schema.events;
show events;
drop event uploaddata_reset;

DELIMITER $
CREATE EVENT uploaddata_reset
ON 
SCHEDULE
EVERY 1 DAY STARTS '2022-10-07 10:20:00'
DO 
begin
truncate uploaddata;
    END
    $
    DELIMITER ;