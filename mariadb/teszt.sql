create database teszt;
use teszt;
create table ttab(a numeric);
insert into ttab values (1);
commit;

use teszt;
select * from ttab;
insert into ttab values (1);
select * from ttab;
commit;


STOP SLAVE;
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;
START SLAVE;
SHOW SLAVE STATUS \G;

STOP SLAVE;
START SLAVE;
SHOW SLAVE STATUS \G;
