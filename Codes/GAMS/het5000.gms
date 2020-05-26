$set matout "'matsol.gdx',UTOTAL,xtotal";
$GDXIN data2
*if $exists metadata.gms $include metadata.gms;
SETS
K index of periods of time /1*24/
*i index of PEV /1*20/;
parameters
s  satisfication
$LOAD s
price(K)
$LOAD price
x0
$LOAD x0
$GDXIN
UTOTAL(K)
xtotal(K)
;
SCALAR
a  auu+bu+c       /0.0012/
b  b              /.11/
c  c              /-0.02/
beta capacity of battery  /12/
xreff  reference soc      /.90/
alpha  charging performance  /.90/;
VARIABLES
j objective function variable
POSITIVE VARIABLES
x(K) state of charge
u(K);
x.lo(K) = .15;
x.up(K) = .95;
u.lo(K) = 0;
*u.fx('24') = 0;
u.fx('1') = 0;
x.fx('1') = x0;
EQUATIONS
soc1
soc2
soc3
soc4
soc5
soc6
soc7
soc8
soc9
soc10
soc11
soc12
soc13
soc14
soc15
soc16
soc17
soc18
soc19
soc20
soc21
soc22
soc23
cost   objective function;
*cost.. j=e=100*((x('24')-xreff)*(x('24')-xreff))+ SUM(K,price(K)*u(K)+(a)*(u(K)*u(K))+(b)*u(K)+c+delta*(u(K)-gamma)*(u(K)-gamma));
cost.. j=e=(10*(x('24')-xreff)*(x('24')-xreff))+ SUM( K,price(K)*u(K)+(.5*s+a)*(u(K)*u(K))-(beta-b)*u(K)+c);
soc1.. x('2')=e=x('1')+(alpha/beta)*u('2');
soc2.. x('3')=e=x('2')+(alpha/beta)*u('3');
soc3.. x('4')=e=x('3')+(alpha/beta)*u('4');
soc4.. x('5')=e=x('4')+(alpha/beta)*u('5');
soc5.. x('6')=e=x('5')+(alpha/beta)*u('6');
soc6.. x('7')=e=x('6')+(alpha/beta)*u('7');
soc7.. x('8')=e=x('7')+(alpha/beta)*u('8');
soc8.. x('9')=e=x('8')+(alpha/beta)*u('9');
soc9.. x('10')=e=x('9')+(alpha/beta)*u('10');
soc10.. x('11')=e=x('10')+(alpha/beta)*u('11');
soc11.. x('12')=e=x('11')+(alpha/beta)*u('12');
soc12.. x('13')=e=x('12')+(alpha/beta)*u('13');
soc13.. x('14')=e=x('13')+(alpha/beta)*u('14');
soc14.. x('15')=e=x('14')+(alpha/beta)*u('15');
soc15.. x('16')=e=x('15')+(alpha/beta)*u('16');
soc16.. x('17')=e=x('16')+(alpha/beta)*u('17');
soc17.. x('18')=e=x('17')+(alpha/beta)*u('18');
soc18.. x('19')=e=x('18')+(alpha/beta)*u('19');
soc19.. x('20')=e=x('19')+(alpha/beta)*u('20');
soc20.. x('21')=e=x('20')+(alpha/beta)*u('21');
soc21.. x('22')=e=x('21')+(alpha/beta)*u('22');
soc22.. x('23')=e=x('22')+(alpha/beta)*u('23');
soc23.. x('24')=e=x('23')+(alpha/beta)*u('24');
MODEL uc /ALL/;
SOLVE uc USING nlp MINIMIZING j;
$ontext
Loop(i,

UTOTAL(i,K)=u.l(K);
xtotal(i,K)=x.l(K);
);
$offtext
UTOTAL(K)=u.l(K);
xtotal(K)=x.l(K);
display UTOTAL;
execute_unload %matout%;
