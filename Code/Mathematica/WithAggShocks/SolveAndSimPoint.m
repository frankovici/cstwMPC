(* SolveAndSimPoint.m *)
(* This file runs the \[Beta]-Point model with point (unique) \[Beta] *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)

Print["============================================================="];
Print["Run \[Beta]-Point model"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Point model... "]
ModelType = Point;   (* Indicate that model is Point  *)
Rep       = False;   (* Indicate that model is not rep agent model *)

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;            (* Setup everything (routines etc.) *)
TimesToEstimateSmall = 5;          (* Number of times to estimate agg process *) 
(*
\[Beta] = 0.98875;                 (* Raw time preference factor *) 
*)
\[Beta] = Import["Beta.txt","List"][[1]]; (* Raw time preference factor *) 
\[Beta] = \[Beta] (1-ProbOfDeath); (* Effective time preference factor *) 

NumPeopleToSim         = 8000;               (* Number of people to simulate *)
 (* NumOfPeople needs to be a multiple of 1/ProbOfDeath *)
NumPeopleToSimLarge    = NumPeopleToSim;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)

(*
NumPeopleToSim         = 9000;     (* Number of people to simulate *)
NumPeopleToSimLarge    = 9000;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
*)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. at least TimesToEstimateSmall+2 times. *), 

   Print["Iteration ", Estimatet];   
       
   (* Construct consumption function *)
   StartConstructingFunc = SessionTime[]; 
(*
   Print[" Solving ind consumption function..."];
*)
 
   ConstructKSIndFunc;
   KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,1] := KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];

   EndConstructingFunc   = SessionTime[]; 
(*
   Print[" Time spent to solve consumption function (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]; 
*)

   (* Run simulation, show results, and estimate agg process *)
   SimulateKSInd;
       
   Estimatet++;

   ]; (* End While *)

(* Plot consumption function *)
maxis = Table[0.2 m, {m, 0, 400}]; (* Horizonal axis is cash on hand normalized by p (t)*wSS *)
mlist = maxis wSS; (* c func (normalized by AdjustedLByAggState but not wSS) can be used after multiplying by wSS *)
caxis =  KSIndcFunc[mlist, 1, 1, kSS, 1] /wSS;
  (* need to divide just by wSS bc when calculating c func, vars are (already) normalized by AdjustedLByAggState *)
(*
mlist = maxis wSS/AdjustedLByAggState[[1]]; (*Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxis =  KSIndcFunc[mlist, 1, 1, kSS, 1] AdjustedLByAggState[[1]]/wSS;
*)

Print[" Consumption function"]

Export["maxis.txt", maxis, "Table"]; 
Export["caxis.txt", caxis, "Table"]; 
maxis = Import["maxis.txt","List"]; 
caxis = Import["caxis.txt","List"]; 

<<PlotCFuncs.m;

(* Export data on wealth distribution *)
kLevListPointWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListPoint.txt", kLevListPointWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListPointWithAggShock.txt", kLevListPointWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsPointWithAggShock.txt", AggStatsWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListPointWithAggShock.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCPointWithAggShock.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodPoint.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodPoint.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadPoint.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadPoint.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Point model(minutes): ", (TimeEnd - TimeStart)/60]; 