create database ovs;
CREATE USER 'vault'@'%' IDENTIFIED BY 'p@ssw0rd';
GRANT ALL PRIVILEGES ON ovs.* TO 'vault'@'%' WITH GRANT OPTION;
GRANT CREATE USER ON *.* to 'vault'@'%';
FLUSH PRIVILEGES;

use ovs;
create table message (title VARCHAR(100));
insert into message (title) values ('testing');

select * from ovs.message;
