#include<stdio.h>
#include<string.h>
FILE *f1,*f2,*F3,*filecheck;
int main(int argc,char * argv[])
{
//check for 2 programs
if(argc!=3)
{
printf("Enter Two Program");
return 0;
}
else
{
f1= fopen(argv[1] , "r");//1st program
F3=fopen("out.txt","w");
char prg1_str[4000],prg2_str[4000];
float output=0,total_compare=0,similar=0;
while(!feof(f1))
{
f2=fopen(argv[2], "r");//2nd program open--- for every line in first program
fscanf(f1,"%s",prg1_str);
if(checkforline(prg1_str))
{
continue;
}
else
{
total_compare+=1;
while(!feof(f2))
{
fscanf(f2,"%s",prg2_str);
if(strcmp(prg1_str,prg2_str)==0)
{fprintf(F3,"%s %s\n",prg1_str,prg2_str);similar+=1;break;}
}
}
memset(prg1_str,'\0',sizeof(prg1_str));
memset(prg1_str,'\0',sizeof(prg1_str));
}
output=(similar/total_compare)*100;
fprintf(F3,"%f %f %f",total_compare,similar,output);
}
return 0;
}
int checkforline(char str[])
{filecheck=fopen("removeline.txt","r");
char checkstr[4000];
fscanf(filecheck,"%s",checkstr);
while(!feof(filecheck))
{
if(strcmp(str,checkstr)==0)
return 1;
fscanf(filecheck,"%s",checkstr);}
return 0;}