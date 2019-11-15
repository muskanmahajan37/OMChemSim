within Simulator.Unit_Operations;

model Splitter
//============================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Splitter;
  parameter Integer Nc = 2 "Number of Components", No = 2 "Number of outlet streams";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  parameter String CalcType "Split_Ratio, Mass_Flow or Molar_Flow";
  
//=============================================================================
//Model Variables
  Real Pin(min = 0, start = 101325) "Inlet pressure", Tin(min = 0, start = 273.15) "Inlet Temperature", Pout_s[No](each min = 0, each start = 101325) "Outlet Pressure", Tout_s[No](each min = 0, each start = 273.15) "Outlet Temperature", xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Inlet Mixture Mole Fraction", xout_sc[No, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Outlet Mixture Molar Fraction", SplRat_s[No](each min = 0, each max = 1) "Split ratio", MW(each min = 0) "Average molecular weight", Fin(min = 0, start = 100) "Inlet Mixture Molar Flow", Fout_c[No](each min = 0, each start = 100) "Outlet Mixture Molar Flow", Fmout_c[No](each min = 0, each start = 100) "Outlet Mixture Mass Flow", SpecVal_s[No] "Specification value";

//==============================================================================
//Instantiation of Connectors
  Simulator.Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out[No](each Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  equation
//==============================================================================
//Connector equations
  In.P = Pin;
  In.T = Tin;
  In.x_pc[1, :] = xin_c[:];
  In.F = Fin;
  for i in 1:No loop
    Out[i].P = Pout_s[i];
    Out[i].T = Tout_s[i];
    Out[i].x_pc[1, :] = xout_sc[i, :];
    Out[i].F = Fout_c[i];
  end for;
//================================================================================
//Specification value assigning equation
  if CalcType == "Split_Ratio" then
    SplRat_s[:] = SpecVal_s[:];
  elseif CalcType == "Molar_Flow" then
    Fout_c[:] = SpecVal_s[:];
  elseif CalcType == "Mass_Flow" then
    Fmout_c[:] = SpecVal_s[:];
  end if;
//=================================================================================
//Balance equation
  for i in 1:No loop
    Pin = Pout_s[i];
    Tin = Tout_s[i];
    xin_c[:] = xout_sc[i, :];
    SplRat_s[i] = Fout_c[i] / Fin;
    MW * Fout_c[i] = Fmout_c[i];
  end for;
//==================================================================================
//Average Molecular Weight Calculation
algorithm
  MW := 0;
  for i in 1:Nc loop
    MW := MW + C[i].MW * xin_c[i];
  end for;
end Splitter;