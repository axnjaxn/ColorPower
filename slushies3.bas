'SLUSHIES 3.3
'3.0 20031106
'3.1 20040415
'3.2 20040420
'3.3 20200403
ClrText
Locate 1,1,"    -------------"
Locate 1,2,"       !  !  !"
Locate 1,3,"       !  !  !"
Locate 1,4,"   SLUSHIES PART 3"
Locate 1,5,"       !  !  !"
Locate 1,6,"       !  !  !"
Locate 1,7,"    -------------"
Do:LpWhile GetKey!=31
File6
ClrText
For 1->Z To 7
Locate 1,Z,"/////////////////////"
Next
For 2->Z To 6
Locate 2,Z,"                   "
Next
Locate 7,1,"MAIN MENU"
Locate 2,2,"[F1] NEW GAME"
Locate 2,3,"[F2] LOAD GAME"
Locate 2,4,"[F3] CREDITS"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=59 And G!=47
If G=79 Or G=69
Then If G=79
Then {100,0,100,10,1,0,0.50}->List 5
ClrGraph
ViewWindow 1,127,0,63,1,0
AxesOff
LabelOff
GridOff
CoordOff
Text 1,1,"2004 AD..."
Text 7,1,"YOUR CORPORATION, SLUSHIES"
Text 13,1,"INTERNATIONAL MAKERS"
Text 19,1,"INCORPORATED, OR SIM INC. FOR"
Text 25,1,"SHORT HAS GONE BELLY UP. YOU"
Text 31,1,"USED THE TIME MACHINE TO COME"
Text 37,1,"BACK ONE YEAR AND SAVE YOUR"
Text 43,1,"BUSINESS FROM BANKRUPTCY. YOU"
Text 49,1,"HAVE ONE YEAR TO FIX THINGS"
Text 55,1,"BEFORE THEY GO SOUTH AGAIN."
Do:LpWhile Getkey!=31
IfEnd
List 5[1]->M
List 5[2]->S
List 5[3]->H
List 5[4]->C
List 5[5]->D
List 5[6]->K
List 5[7]->P
Goto r
IfEnd
ClrText
Locate 1,1,"SLUSHIES..."
Locate 1,2,"CONCEPT"
Locate 4,3,"BRIAN JACKSON"
Locate 1,4,"BETA TESTING"
Locate 4,5,"DAVID DODGE"
Locate 4,6,"KORY BEIGHLE"
Do:LpWhile Getkey!=31
ClrText
Locate 1,1,"SLUSHIES 2..."
Locate 1,2,"CONCEPT"
Locate 4,3,"BRIAN JACKSON"
Locate 1,4,"BETA TESTING"
Locate 4,5,"ZACH HOLBROOK"
Locate 4,6,"DAVID STEPHAN"
Do:LpWhile Getkey!=31
ClrText
Locate 1,1,"SLUSHIES 3..."
Locate 1,2,"CONCEPT"
Locate 4,3,"BRIAN JACKSON"
Locate 1,4,"BETA TESTING"
Locate 4,5,"ZACH HOLBROOK"
Do:LpWhile Getkey!=31
ClrText
Stop
Lbl r
ViewWindow 1,127,0,63,1,0
F-Line 1,1,127,1
F-Line 127,1,127,53
F-Line 1,53,1,1
F-Line 1,9,127,9
F-Line 119,1,119,9
F-Line 125,3,121,7
F-Line 121,3,125,7
Text 3,48,"STATUS"
For 21->Z To 126 Step 21
F-Line Z-20,55,Z-20,63
F-Line Z-20,55,Z-1,55
Next
Text 57,3,"RUN"
Text 57,24,"SPLY"
Text 57,45,"FITE"
Text 57,66,"NITE"
Text 57,87,"CORT"
Text 57,108,"END"
Text 15,3,"MONEY"
Text 21,3,"SLUSHIES"
Text 27,3,"HEALTH"
Text 33,3,"CUSTOMERS"
Text 39,3,"DAY"
Text 45,3,"PRICE"
Lbl 0
{M,S,H,C,D,K,P}->List 5
For 15->Z To 45 Step 6
Orange Text Z,45,"                     "
Next
Orange Text 15,45,M
Orange Text 21,45,S
Orange Text 27,45,H
Orange Text 33,45,C
Orange Text 39,45,D
Orange Text 45,45,P
Lbl th
PxlOn 1,1
Do
Do
Getkey->G
LpWhile G=0
LpWhile G!=47 And G!=79 And G!=69 And G!=59 And G!=49 And G!=39 And G!=29 And G!=78
G=79=>Goto 1
G=69=>Goto 2
G=59=>Goto 3
G=49=>Goto 4
G=39=>Goto 5
G=29=>Goto 6
G=78=>Goto 8
ClrText
Cls
Stop
Lbl 2
ClrText
Locate 1,1,"SUPPLY---------------"
Locate 1,2,"[F1] BUY"
Locate 1,3,"[F2] PRICE"
Locate 1,4,"[F3] STEAL"
Locate 1,5,"[F4] EAT"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=59 And G!=49 And G!=47
G=79=>Goto A
G=69=>Goto B
G=59=>Goto C
G=49=>Goto D
Goto th
Lbl 3
ClrText
Locate 1,1,"FIGHT----------------"
Locate 1,2,"[F1] DOJO"
Locate 1,3,"[F2] STREET"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=47
G=79=>Goto E
G=69=>Goto F
Goto th
Lbl 4
ClrText
Locate 1,1,"NIGHT----------------"
Locate 1,2,"[F1] SLEEP"
Locate 1,3,"[F2] CLUBBING"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=47
G=79=>Goto G
G=69=>Goto H
Goto th
Lbl 5
ClrText
Locate 1,1,"COURT----------------"
Locate 1,2,"[F1] SUE COMPETITORS"
Locate 1,3,"[F2] FILE A CLAIM"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=47
G=79=>Goto I
G=69=>Goto J
Goto th
Lbl 6
ClrText
Locate 1,1,"END GAME-------------"
Locate 1,2,"[F1] YES"
Locate 1,3,"[F2] NO"
Do
Getkey->G
LpWhile G!=79 And G!=69
G=69=>Goto th
Lbl 9
''EXPANSION
'M>=10000 And D<=365=>Goto K
M>=50000 And D<=365=>Goto K
''
Goto L
Lbl A
ClrText
" "
Locate 1,1,"BUY------------------"
" "
Locate 1,2,"PRICE="
5(Int(9Ran#))+10->Z
Locate 7,2,Z
"HOW MANY BOXES"
"(0.1 = FULL)"?->Y
Y=0.1=>M/Z->Y
Y!=Int Y=>Int Y->Y
Y<0=>0->Y
If M<YZ
Then ClrText
Locate 1,1,"NOT ENOUGH"
Do:LpWhile Getkey!=31
Goto 0
IfEnd
M-YZ->M
S+50Y->S
Goto 0
Lbl B
ClrText
"NEW PRICE"?->Z
Z-P->Y
Int 4Y->Y
If Z>5
Then 5->Z
ClrText
Locate 1,1,"ADJUSTED PRICE"
Do:LpWhile Getkey!=31
IfEnd
C-Y->C
C<0=>0->C
Z->P
Goto 0
Lbl C
ClrText
Locate 1,1,"STEALING..."
Int (3Ran#)->Y
D+1->D
If Y=0
Then Locate 1,2,"SUCCESS!"
5(Int (10Ran#))+5->Z
Locate 1,3,"STOLE"
Locate 7,3,Z
Locate 10,3,"SLUSHIES"
S+Z->S
IfEnd
If Y=1
Then Locate 1,2,"SUCCESS!"
Locate 1,3,"BUT THE SLUSHIES WERE"
Locate 1,4,"CONTAMINATED AND"
Locate 1,5,"SOME CUSTOMERS LEFT"
C-Int (9Ran#)->C
C<0=>0->C
IfEnd
If Y=2
Then Locate 1,2,"YOU WERE CAUGHT"
Locate 1,3,"PAID A FINE AND SPENT"
Locate 1,4,"TWO WEEKS IN JAIL"
M-200->M
D+14->D
50->H
IfEnd
Do:LpWhile Getkey!=31
Goto 0
Lbl D
ClrText
Locate 1,1,"EAT HOW MANY?"
Locate 1,2,"[F1] 25"
Locate 1,3,"[F2] 50"
Locate 1,4,"[F3] FULL"
Do
Getkey->G
LpWhile G!=79 And G!=69 And G!=59
G=79=>25->Z
G=69=>50->Z
G=59=>100->Z
Z>(100-H)=>(100-H)->Z
Z>S=>S->Z
S-Z->S
H+Z->H
Goto 0
Lbl E
ClrText
If H<45
Then Locate 1,1,"YOU ARE TOO TIRED"
Do:LpWhile Getkey!=31
Goto th
IfEnd
Locate 1,1,"CURRENT RANK:"
Locate 15,1,K
Locate 1,2,"TRAINING..."
Locate 1,3,"DAY"
Int (15Ran#)+7->Y
For 1->Z To Y
Locate 5,3,D+Z
Next
Locate 1,4,"LEVEL UP!"
D+Z->D
K+1->K
H-45->H
C-1->C
C<0=>0->C
Do:LpWhile Getkey!=31
Goto 0
Lbl F
ClrText
90->Z
Int (15Ran#)->Y
If Y>=10 And Y<13
Then Locate 1,7,"ARNOLD ATTACK"
200->Z
IfEnd
If Y>=13
Then Locate 1,7,"RYU ATTACK"
2000->Z
IfEnd
Locate 1,1,"YOU"
Locate 1,2,"HIM"
Do
Locate 5,1,"   "
Locate 5,1,H
Locate 5,2,"    "
Locate 5,2,Z
H-Int (9Ran#)->H
Z-Int (3Ran#)-K->Z
Getkey=47=>Goto 0
LpWhile Z>=0 And H>=0
If H<0
Then M-250->M
10->H
Locate 1,6,"YOU LOST"
Else Locate 1,5,"MONEY+"
Int (80Ran#)->Z
Locate 7,5,Z
M+Z->M
IfEnd
Do:LpWhile Getkey!=31
Goto 0
Lbl G
ClrText
Locate 1,1,"RESTED    DAYS"
Int (H/10)->H
(10-H)->Z
Locate 8,1,Z
Z+D->D
100->H
Do:LpWhile Getkey!=31
Goto 0
Lbl H
ClrText
"HOW MANY NIGHTS"?->Y
Y=0=>Goto th
ClrText
Locate 1,1,"DANCING..."
For 1->Z To 150
Next
Locate 1,2,"BREAKDANCING..."
For 1->Z To 150
Next
Locate 1,3,"DJ'ING..."
0->Z
For 1->X To Y
Z+Int (9RRan#)+Int (Int (D/10)Ran#)->Z
Int (H/2)->H
Next
Locate 1,5,"MET"
Locate 5,5,Z
Locate Int (log Z)+7,5,"PEOPLE"
C+Z->C
D+Y->D
M-10Y->M
Do:LpWhile Getkey!=31
Goto 0
Lbl I
ClrText
Locate 1,1,"YOU"
Locate 1,2,"THEM"
25->Y~Z
Do
Int (2Ran#)=0=>Y-1->Y
Locate 6,1,"  "
Locate 6,1,Y
Int (2Ran#)=0=>Z-1->Z
Locate 6,2,"  "
Locate 6,2,Z
LpWhile Y!=0 And Z!=0
If Y!=0
Then Locate 1,4,"YOU WON"
Locate 1,5,"NEW TOTAL"
M+10Z+50->M
Locate 11,5,M
Else Locate 1,4,"YOU LOSE"
Locate 1,5,"NEW TOTAL"
M-10Y-50->M
Locate 11,5,M
IfEnd
Do:LpWhile Getkey!=31
Goto 0
Lbl J
ClrText
Int (D/2)->Z
12.5Z+Int ((100-C)Ran#)->Z
Z<250=>250->Z
If M<Z Or D>365
Then If M<Z
Then Locate 1,1,"YOU DON'T HAVE THE"
Locate 1,2,"MONEY FOR AN ATTORNEY"
Else Locate 1,1,"IT'S TOO LATE"
IfEnd
Do:LpWhile Getkey!=31
Goto th
IfEnd
Locate 1,1,"TO HIRE AN ATTORNEY"
Locate 1,2,"IT WILL COST"
Locate 14,2,Z
Locate 1,3,"[F1] YES"
Locate 1,4,"[F2] NO"
Do
Getkey->G
LpWhile G!=79 And G!=69
G=69=>Goto th
ClrText
If Int (10Ran#)=0
Then Locate 1,1,"YOUR ATTORNEY FAILED"
Locate 1,2,"BUT REFUNDED A LITTLE"
M-(Z/2)->M
Else Locate 1,1,"YOU WON"
M-Z->M
Int (D/2)->D
IfEnd
Do:LpWhile Getkey!=31
Goto 0
Lbl K
Cls
Text 1,1,"2005 AD..."
Text 7,1,"SIM INC. HAS BECOME THE MOST"
Text 13,1,"SUCCESSFUL CORPORATION ON"
Text 19,1,"EARTH. YOU ARE ITS FOUNDER."
Text 25,1,"YOU ARE ITS CEO. YOU ARE..."
Text 31,1,"THE RICHEST MAN ALIVE."
{1000000,1000,100,100,720,0,0.5}->List 5
Do:LpWhile Getkey!=31
If C>=100
Then Cls
Text 1,1,"EVERYONE LOVES YOU. YOU EVEN"
Text 7,1,"HAVE A FAN CLUB AND A TV SHOW."
Text 13,1,"EVERYONE RUSHES TO BUY YOUR"
Text 19,1,"PRODUCTS AND YOU SELL THEM"
Text 25,1,"ON A GLOBAL SCALE."
1000000->List 5[4]
Do:LpWhile Getkey!=31
IfEnd
If K>=12
Then Cls
Text 1,1,"YOU KICK BUTT. SINCE YOU HAVE"
Text 7,1,"MASTERED 25 FORMS OF MARTIAL"
Text 13,1,"ARTS, YOU ARE ALSO THE"
Text 19,1,"STRONGEST PERSON ALIVE. YOU"
Text 25,1,"COULD LEVEL A CITY WITH A"
Text 31,1,"SINGLE GLANCE. YOU NO LONGER"
Text 37,1,"NEED WEAPONS OR BODYGUARDS"
Text 43,1,"SINCE YOU CAN NUKE EVERYONE..."
50->List 5[6]
Do:LpWhile Getkey!=31
IfEnd
ClrText
Locate 8,4,"THE END"
Stop
Lbl L
Cls
If D>720
Then Text 1,1,"THE TIME MACHINE LIES"
Text 7,1,"UNUSED IN YOUR GARAGE. YOU"
Text 13,1,"TURN IT ON AND IT GLOWS A SOFT"
Text 19,1,"BLUE. YOU STEP IN..."
If C<1000000
Then 1000000-C->Z
M-5Z->M
D+Int (Z/8)->D
1000000->C
IfEnd
Text 31,1,"YOU STEP OUT IN THE FUTURE."
Text 37,1,"YOUR CUSTOMERS ARE SOMEHOW"
Text 43,1,"DIFFERENT NOW, THOUGH."
Do:LpWhile Getkey!=31
Goto r
IfEnd
Text 1,1,"2005 AD..."
Text 7,1,"YOU ARE BROKE. THE WORK YOU"
Text 13,1,"DID IN THE PAST WAS TOO"
Text 19,1,"LITTLE, TOO LATE. YOU LOSE."
Do:LpWhile Getkey!=31
{0,0,0,0,0,0,0}->List 5
Stop
Lbl 1
Do
ClrText
Int (10Ran#)-5->Y
If Y<=0
Then Locate 1,1,"YOU SOLD A SLUSHIE TO"
Int (CRan#)->Z
Z>S=>S->Z
Locate 1,2,Z
Locate 1,3,"CUSTOMERS"
M+ZP->M
S-Z->S
IfEnd
If Y=1
Then Locate 1,1,"SOME SLUSHIES MELTED"
S/4->Z
Int (ZRan#)->Z
S-Z->S
Locate 1,2,"YOU LOST"
Locate 10,2,Z
IfEnd
If Y=2
Then Locate 1,1,"SOME CUSTOMERS GOT"
Locate 1,2,"SICK OF SLUSHIES"
Locate 1,3,"YOU LOST"
C/4->Z
Int (ZRan#)->Z
Locate 10,3,Z
C-Z->C
IfEnd
If Y=3
Then Locate 1,1,"ARNOLD USED HIS"
Locate 1,2,"CALIFORNIA GOVERNOR"
Locate 1,3,"INFLUENCE TO HURT THE"
Locate 1,4,"SLUSHIE BUSINESS WHEN"
Locate 1,5,"HE BOUGHT ONE."
If K>=40 And Int ((55-K)Ran#)<=5
Then Locate 15,5,".."
Do:LpWhile Getkey!=31
ClrText
Locate 1,1,"BUT YOU OPENED A CAN"
Locate 1,2,"OF WHOOPIN ON HIS"
Locate 1,3,"BUTT AND TOOK HIS"
Locate 1,4,"WALLET."
M+Int (200Ran#)*10->M
Else S-Int (SRan#/2)->S
C-Int (15Ran#)->C
C<0=>0->C
IfEnd
IfEnd
If Y=4
Then Locate 1,1,"A FRENCH GERMAN"
Locate 1,2,"BAPTIST CATHOLIC NAZI"
Locate 1,3,"PIRATE NUN SLAPPED"
Locate 1,4,"YOU WITH A RULER."
H-5->H
If K>=12
Then Locate 14,".."
Do:LpWhile Getkey!=31
ClrText
Locate 1,1,"BUT YOU DEFENDED"
Locate 1,2,"YOURSELF AND K.O.'ED"
Locate 1,3,"HER."
H+5->H
C+1->C
IfEnd
IfEnd
Locate 1,6,"SLUSHIES="
Locate 12,6,S
Locate 1,7,"DAY"
Locate 5,7,"D"
D=365=>Goto 9
D+1->D
Do
Getkey->G
LpWhile G!=47 And G!=31
LpWhile G!=47
Goto 0
Lbl 8
ClrText
Locate 1,1,"4^3"
64->Z
Locate 20,2,Z
Locate 1,3,"Ans/8"
Z/8->Z
Locate 21,4,Z
Locate 1,5,"Ans*pi"
Z*pi->Z
Locate 11,6,Z
Do:LpWhile Getkey!=31
Goto th
'---------------------
' != substituted for not equal
' -> and => substituted for single and double arrow
' / substituted for division symbol (in equations)
' * substituted for multiplication symbol
' pi substituted for pi symbol