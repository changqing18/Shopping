create table border
(
	orderid bigint not null,
	email varchar(30) not null,
	gid bigint not null,
	number int not null,
	buytime datetime default CURRENT_TIMESTAMP not null,
	constraint `PRIMARY`
		primary key (orderid)
)
;

create index gid
	on border (gid)
;

create table cart
(
	orderid bigint not null,
	email varchar(30) not null,
	gid bigint not null,
	number int not null,
	constraint `PRIMARY`
		primary key (orderid)
)
;

create index gid
	on cart (gid)
;

create table good
(
	gid bigint not null,
	gname varchar(100) not null,
	brand varchar(10) null,
	price float(6,2) not null,
	number int not null,
	constraint `PRIMARY`
		primary key (gid)
)
;

alter table border
	add constraint border_ibfk_1
		foreign key (gid) references web.good (gid)
;

alter table cart
	add constraint cart_ibfk_1
		foreign key (gid) references web.good (gid)
;

create table user
(
	username varchar(20) null,
	email varchar(30) not null,
	password varchar(20) not null,
	constraint `PRIMARY`
		primary key (email)
)
;

create procedure buy (IN pid bigint, IN pe varchar(30), IN pgid bigint, IN num int)  
CREATE PROCEDURE `buy`(`pid` BIGINT(20), `pe` VARCHAR(30), `pgid` BIGINT(20), `num` INT(11))
  BEGIN
    INSERT INTO border (orderid, email, gid, number) 
    VALUES (pid, pe, pgid, num);
    DELETE FROM cart
    WHERE orderid = pid;
    UPDATE good
    SET number = number - num
    WHERE gid = pgid;
  END;

create procedure cart_merge (IN pid bigint, IN pemail varchar(30), IN pgid bigint, IN num int)  
CREATE PROCEDURE `cart_merge`(`pid` BIGINT(20), `pemail` VARCHAR(30), `pgid` BIGINT(20), `num` INT(11))
  BEGIN
    DECLARE temp INT;
    SELECT number
    INTO temp
    FROM cart
    WHERE gid = pgid && email = pemail;
    IF temp IS NULL
    THEN INSERT INTO cart VALUES (pid, pemail, pgid, num);
    ELSE UPDATE cart
    SET orderid = pid, number = num + temp
    WHERE gid = pgid && email = pemail;
    END IF;
  END;

