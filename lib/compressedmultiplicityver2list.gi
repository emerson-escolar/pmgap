#
#These are codes for calculating compress multiplicity defined in the paper
#"Approximation by interval-decomposables and interval resolutions of persistence modules" by Hideto Asashiba, Emerson G. Escolar, Ken Nakashima, Michio Yoshiwaki
#See https://arxiv.org/abs/2207.03663
#The defefinition of the compressed multiplicity is in Definition 5.1 in the above paper.
#

#_____________________


#The codes below make a representaion over 1←2→3←4→5 from a representation over 2D grids (2*m grids for m in positive integers).
#See the section 5 of "Approximation by interval-decomposables and interval resolutions of persistence modules" by Hideto Asashiba, Emerson G. Escolar, Ken Nakashima, Michio Yoshiwaki
#https://arxiv.org/abs/2207.03663

#_______________________

__ChangeCLtoTypeAForTwoRows:=function(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco)#Reco:=__MatricesOnPaths(CLrep)
local a,b,listSo,listSink,size,i,lst,
y_k,y_l,y_i,x_i,x_j,Q,kQ,Zigzagmodule,
dim_yk,dim_yi,dim_yl,dim_xi,dim_xj,Mat_1,Mat_2,Mat_3,Mat_4;;

listSo:=SourceVertices(CLIntervalrep); 
listSink:=SinkVertices(CLIntervalrep);
size:= Length(DimensionVector(CLrep))/2;



if Length(listSo) = 2 then
y_k:=[2,listSo[2][2]];
else
y_k:=[2, listSo[1][2]];
fi;

if Length(listSo) = 2 then
y_i:=[2,listSo[1][2] ];
else
y_i:=[2 ,listSo[1][2]];
fi;

if Length(listSink) = 2 then
y_l:=[2,listSink[2][2]];
else
y_l:=[2,listSink[1][2]];
fi;

if Length(listSo) = 2 then
x_i:=[1,listSo[1][2]]; 
else
x_i:=[1,listSo[1][2]];
fi;

if Length(listSink) = 2 then
x_j:=[1,listSink[1][2]]; 
else
x_j:=[1,listSink[1][2]];
fi;

a:=y_k[2];
dim_yk:=DimensionVector(CLrep)[size+a];
a:=x_i[2];
dim_yi:=DimensionVector(CLrep)[size+a];
a:=y_l[2];
dim_yl:=DimensionVector(CLrep)[size+a];
a:=x_i[2];
dim_xi:=DimensionVector(CLrep)[a];
a:=x_j[2];
dim_xj:=DimensionVector(CLrep)[a];


#_
a:=y_k[2];
b:=y_i[2];
Mat_2:=IdentityMat(dim_yk,field); 
if a<b then 
   for i in [1.. Length(Reco.(b-a))] do
      if Reco.(b-a)[i][1]=y_k and Reco.(b-a)[i][2]=y_i then 
         Mat_2:= Reco.(b-a)[i][3];
         
      fi;
    od;
fi;
#_
a:=y_k[2];
b:=y_l[2];
Mat_1:=Mat_2; ##In case Mat_1 is identity mat.
if a<b then
  for i in [1.. Length(Reco.(b-a))] do
      if Reco.(b-a)[i][1]=y_k and Reco.(b-a)[i][2]=y_l then 
         Mat_1:= Reco.(b-a)[i][3];
         #break;
      fi;
  od;
fi;
#_

a:=x_i[2];
Mat_3:=MatricesOfPathAlgebraModule(CLrep)[2*(size-1)+a];#We do not need matrix calculation.So We do not use Reco.

#__
a:=x_i[2];
b:=x_j[2];
Mat_4:=IdentityMat(dim_xi,field);
if a<b then
  for i in [1.. Length(Reco.(b-a))] do
      if Reco.(b-a)[i][1]=x_i and Reco.(b-a)[i][2]=x_j then 
         Mat_4:= Reco.(b-a)[i][3];
          #break;
      fi;
  od;
fi;
#__
lst:=[];
if dim_yk<>0 and dim_yl<>0 then
Append(lst, [["a",Mat_1 ]]);
fi;

if dim_yk<>0 and dim_yi<>0 then
Append(lst, [["b",Mat_2 ]]);
fi;

if dim_yi<>0 and dim_xi<>0 then
Append(lst, [["c",Mat_3 ]]);
fi;

if dim_xj<>0 and dim_xi<>0 then
Append(lst, [["d",Mat_4 ]]);
fi;

Zigzagmodule:=RightModuleOverPathAlgebra( ZigzagPathAlgebra, [dim_yl,dim_yk,dim_yi,dim_xi,dim_xj],lst );
return Zigzagmodule;
end;

# --------------------  --------------------

__ChangeCLtoTypeAForDownRow:=function(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco)#Reco:=MatricesOnPaths(CLrep)
local a,b,i,listSo,listSink,size,lst,
x_i,x_j,Q,kQ,Zigzagmodule,
dim_xi,dim_xj,Mat_4,End_xj,End_xi;;

listSo:=SourceVertices(CLIntervalrep); 
listSink:=SinkVertices(CLIntervalrep);
size:= Length(DimensionVector(CLrep))/2;

x_i:=[1,listSo[1][2]];
x_j:=[1,listSink[1][2]];

a:=x_i[2];
dim_xi:=DimensionVector(CLrep)[a];
a:=x_j[2];
dim_xj:=DimensionVector(CLrep)[a];

a:=x_i[2];
b:=x_j[2];
Mat_4:=IdentityMat(dim_xi,field);
if a<b then
  for i in [1.. Length(Reco.(b-a))] do
      if Reco.(b-a)[i][1]=x_i and Reco.(b-a)[i][2]=x_j then 
         Mat_4:= Reco.(b-a)[i][3];
         break;
      fi;
  od;
fi;

End_xi:=IdentityMat(dim_xi,field);

lst:=[];
if dim_xj<>0 and dim_xi<>0 then
Append(lst, [["a",Mat_4 ]]);
Append(lst, [["d",Mat_4 ]]);
fi;

if dim_xi<>0 then
Append(lst, [["b",End_xi ]]);
Append(lst, [["c",End_xi ]]);
fi;

Zigzagmodule:=RightModuleOverPathAlgebra( ZigzagPathAlgebra, 
[dim_xj,dim_xi,dim_xi,dim_xi,dim_xj],
lst);

return Zigzagmodule;
end;


# --------------------  --------------------


__ChangeCLtoTypeAForUpRow:=function(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco)#Reco:=__MatricesOnPaths(CLrep)
local a,b,i,listSo,listSink,size,lst,
y_k,y_l,Q,kQ,Zigzagmodule,
dim_yk,dim_yl,Mat_1,End_yk;;

listSo:=SourceVertices(CLIntervalrep); 
listSink:=SinkVertices(CLIntervalrep);
size:= Length(DimensionVector(CLrep))/2;


y_k:=[2, listSo[1][2]];
y_l:=[2,listSink[1][2]];


a:=y_k[2];
dim_yk:=DimensionVector(CLrep)[size+a];
a:=y_l[2];
dim_yl:=DimensionVector(CLrep)[size+a];


a:=y_k[2];
b:=y_l[2];


Mat_1:=IdentityMat(dim_yk,field);  ##IdentityMat(3,field);
if a<b then
  for i in [1.. Length(Reco.(b-a))] do
      if Reco.(b-a)[i][1]=y_k and Reco.(b-a)[i][2]=y_l then 
         Mat_1:= Reco.(b-a)[i][3];
         #break;
      fi;
  od;
fi;


End_yk:=IdentityMat(dim_yk,field); 

lst:=[];
if dim_yl<>0 and dim_yk<>0 then
Append(lst, [["a",Mat_1 ]]);
Append(lst, [["d",Mat_1 ]]);
fi;

if dim_yk<>0 then
Append(lst, [["b",End_yk ]]);
Append(lst, [["c",End_yk ]]);
fi;


Zigzagmodule:=RightModuleOverPathAlgebra( ZigzagPathAlgebra, 
[dim_yl,dim_yk,dim_yk,dim_yk,dim_yl],
lst );

return Zigzagmodule;
end;

# --------------------  --------------------

#The code below tell us the form of interval representations over 2D Grids.
 
CheckKindOfCLInterval:=function(CLIntervalrep)
local listSo,listSink;;

listSo:=SourceVertices(CLIntervalrep); 
listSink:=SinkVertices(CLIntervalrep);

if Length(listSo) = 2  or Length(listSink) = 2 then
    return "2Rows";
elif listSo[1][1] = 1  and listSink[1][1] = 2 then
    return "2Rows";
elif listSo[1][1] = 1  and listSink[1][1] = 1 then
    return "1RowDown";
elif listSo[1][1] = 2  and listSink[1][1] = 2 then
    return "1RowUp";
fi;
end;

# --------------------  --------------------


__ChangeCLtoTypeA:=function(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco)#Reco:=__MatricesOnPaths(CLrep)
if  CheckKindOfCLInterval(CLIntervalrep)= "2Rows" then
return __ChangeCLtoTypeAForTwoRows(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco);
elif CheckKindOfCLInterval(CLIntervalrep)= "1RowDown" then
return __ChangeCLtoTypeAForDownRow(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco);
elif CheckKindOfCLInterval(CLIntervalrep)= "1RowUp" then
return __ChangeCLtoTypeAForUpRow(CLrep,CLIntervalrep,ZigzagPathAlgebra,field,Reco);
fi;
end;

##______


#This code gives us matrix 
#|M_1, O |
#| O ,M_2|
#from Mat_1 and Mat_2
 
Directsum:=function(Mat_1,Mat_2,field)
local dim_1,dim_2,b,c,d,x,y,z,test1,test2,Q,kQ;;

Q := Quiver(2,[[1,2,"x"]]);
kQ := PathAlgebra(field, Q);

dim_1:=Length(Mat_1);
dim_2:=Length(TransposedMat(Mat_1));
test1:=RightModuleOverPathAlgebra( kQ, [dim_1,dim_2], [["x", Mat_1]] );
dim_1:=Length(Mat_2);
dim_2:=Length(TransposedMat(Mat_2));
test2:=RightModuleOverPathAlgebra( kQ, [dim_1,dim_2], [["x", Mat_2]] );

return MatricesOfPathAlgebraModule(DirectSumOfQPAModules([test1,test2]))[1];
end;
#________
#To caliculate the number of the 
# interval representaion I:=[1,1,1,1,1,1] as a direct summand in a 
# representation M over the quiver
#   1←2→3←4→5,
# we caluculate dim(Hom(I,M)),dim(Hom(I,A)),dim(Hom(I,B)),dim(Hom(I,X)),
# where A:=[1,1,1,1,0], B:=[0,1,1,1,1],  X:=τ^{-1}(I)=[0,1,1,1,0], and
# 0 → I →　A\oplus B →　X →0 is an alomost split sequence.
#Then the number of the interval representaion I:=[1,1,1,1,1,1] as a direc summand in M
# is dimHom(I,M)+ DimHom(X,M)-DimHom(A,M)-DimHom(B,M).
#If you want to know the reason why the caluculation tell us such an information,
#see the paper "Decomposition theory of modules: the case of Kronecker algebra" by Hideto Asashiba, Ken Nakashima, Michio Yoshiwaki.
#https://arxiv.org/abs/1703.07906
#________

#dimHom(X,M)
DimHomX:=function(M)
local mat,mat1,mat2,field;;

field:=LeftActingDomain(M);
if DimensionVector(M)[2]=0 and DimensionVector(M)[4]=0 then
return 0;
fi;

if DimensionVector(M)[2]=0 and DimensionVector(M)[4]<>0 then
return  DimensionVector(M)[4] - 
RankMat(StackMatricesHorizontalCopy(MatricesOfPathAlgebraModule(M)[3],
MatricesOfPathAlgebraModule(M)[4] ) );
fi;

if DimensionVector(M)[2]<>0 and DimensionVector(M)[4]=0 then
return  DimensionVector(M)[2] - 
RankMat(StackMatricesHorizontalCopy(MatricesOfPathAlgebraModule(M)[1],
MatricesOfPathAlgebraModule(M)[2] ) );
fi;

if DimensionVector(M)[2]<>0 and DimensionVector(M)[4]<>0  and DimensionVector(M)[3]=0 then
  if DimensionVector(M)[1]<>0 and DimensionVector(M)[5]<>0 then
  return DimensionVector(M)[4]+DimensionVector(M)[2]
  -RankMat
  (Directsum(MatricesOfPathAlgebraModule(M)[1],MatricesOfPathAlgebraModule(M)[1],field));
   elif DimensionVector(M)[1]=0 and DimensionVector(M)[5]<>0 then
   return DimensionVector(M)[4]+DimensionVector(M)[2]
  -RankMat(MatricesOfPathAlgebraModule(M)[4]);
   elif DimensionVector(M)[1]<>0 and DimensionVector(M)[5]=0 then
   return DimensionVector(M)[4]+DimensionVector(M)[2]
  -RankMat(MatricesOfPathAlgebraModule(M)[1]);
   elif DimensionVector(M)[1]=0 and DimensionVector(M)[5]=0 then
   return DimensionVector(M)[4]+DimensionVector(M)[2];
   fi;
elif DimensionVector(M)[2]<>0 and DimensionVector(M)[4]<>0  and DimensionVector(M)[3]<>0 then
   mat1:=StackMatricesVerticalCopy(MatricesOfPathAlgebraModule(M)[2],MatricesOfPathAlgebraModule(M)[3]);
   mat2:= Directsum(MatricesOfPathAlgebraModule(M)[1],MatricesOfPathAlgebraModule(M)[4],field);
   mat:=StackMatricesHorizontalCopy(mat1,mat2);
   return DimensionVector(M)[4]+DimensionVector(M)[2]
    - RankMat(mat);
  fi;
      
 end;
#_______


#dimHom(I,M)
DimHomI:= function(M)
local mat,field;;
field := LeftActingDomain(M);
mat:=StackMatricesVerticalCopy(MatricesOfPathAlgebraModule(M)[2],
MatricesOfPathAlgebraModule(M)[3]);
return DimensionVector(M)[4]+DimensionVector(M)[2] 
-RankMat(mat);
end;

#______
#dimHom(A,M)

DimHomA:= function(M)
local mat,mat1,mat2,zeromat,field;;
field := LeftActingDomain(M);
if DimensionVector(M)[2]=0 then
   mat:=StackMatricesHorizontalCopy
   (MatricesOfPathAlgebraModule(M)[3],MatricesOfPathAlgebraModule(M)[4]); 
   return  DimensionVector(M)[4]- RankMat(mat);
fi;

if  DimensionVector(M)[2]<>0 then
    if DimensionVector(M)[5]=0 then
       mat:=StackMatricesVerticalCopy(MatricesOfPathAlgebraModule(M)[2],MatricesOfPathAlgebraModule(M)[3]);
       return DimensionVector(M)[2] + DimensionVector(M)[4]-RankMat(mat);
    else 
       mat1:=StackMatricesVerticalCopy(MatricesOfPathAlgebraModule(M)[2],MatricesOfPathAlgebraModule(M)[3]);
       zeromat:=NullMat(DimensionVector(M)[2],DimensionVector(M)[5],field);
       mat2:=StackMatricesVerticalCopy(zeromat,MatricesOfPathAlgebraModule(M)[4]);
       mat:=StackMatricesHorizontalCopy(mat1,mat2);
       return DimensionVector(M)[4]+DimensionVector(M)[2] -RankMat(mat);
    fi;
fi;
end;

#_________

#dimHom(B,M)

DimHomB:= function(M)
local mat,mat1,mat2,zeromat,field;;
field := LeftActingDomain(M);
if DimensionVector(M)[4]=0 then
mat:=StackMatricesHorizontalCopy(MatricesOfPathAlgebraModule(M)[1],MatricesOfPathAlgebraModule(M)[2]); 
return DimensionVector(M)[2]- RankMat(mat);
fi;

if  DimensionVector(M)[4]<>0 then
  if DimensionVector(M)[1]=0 then
    mat:=StackMatricesVerticalCopy(MatricesOfPathAlgebraModule(M)[2],MatricesOfPathAlgebraModule(M)[3]);
    return DimensionVector(M)[2] + DimensionVector(M)[4]-RankMat(mat);
  else 
    mat1:=StackMatricesHorizontalCopy(MatricesOfPathAlgebraModule(M)[1],MatricesOfPathAlgebraModule(M)[2]);
    zeromat:=NullMat(DimensionVector(M)[4],DimensionVector(M)[1],field);
    mat2:=StackMatricesHorizontalCopy(zeromat,MatricesOfPathAlgebraModule(M)[3]);
    mat:=StackMatricesVerticalCopy(mat1,mat2);
    return DimensionVector(M)[4]+DimensionVector(M)[2]-RankMat(mat);
  fi;
fi;
end;
#________

#This code gives us the number of [1,1,1,1,1] in the representation M over the quiver
#1←2→3←4→5.
final:= function(M)
return DimHomI(M)+ DimHomX(M)-DimHomA(M)-DimHomB(M);
end;
#_____________
CompressedMultiplicityVer2List:=function(CLrep)
local A,B,RCLrep,RCLIntervalrep,Q,ZigzagPathAlgebra,field,Reco,ListOfIntervalReps,ListOfCompressMultiplicity2;;
field := LeftActingDomain(CLrep);
A:=RightActingAlgebra(CLrep);
ListOfCompressMultiplicity2:=[];
Reco:=__MatricesOnPaths(CLrep);
Q := Quiver(5,[[2,1,"a"],[2,3,"b"],[4,3,"c"],[4,5,"d"]]);
ZigzagPathAlgebra := PathAlgebra(field, Q);
ListOfIntervalReps:=IntervalRepnsList(A);

for B in ListOfIntervalReps do
    RCLrep:=__ChangeCLtoTypeA(CLrep,B,ZigzagPathAlgebra,field,Reco);
    #RCLIntervalrep:=__ChangeCLtoTypeA(B,B,ZigzagPathAlgebra,field,Reco);
    if IsZero(RCLrep) then
       ##do nothing;
    else
	Add(ListOfCompressMultiplicity2,[B,final(RCLrep)]);
       
    fi;
od;	
return  ListOfCompressMultiplicity2 ;
end;
#___________________