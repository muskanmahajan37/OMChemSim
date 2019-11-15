within Simulator.Files.Models;

 model Flash
    //this is basic flash model.  comp and Nc has to be defined in model. thermodyanamic model must also be extended along with this model for K value.
    import Simulator.Files.*;
    Real F_p[3](each min = 0, each start = 100), x_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), Cp_pc[3, Nc], H_pc[3, Nc], S_pc[3, Nc], Cp_p[3], H_p[3], S_p[3], xliq(min = 0, max = 1, start = 0.5), xvap(min = 0, max = 1, start = 0.5), P(min = 0, start = 101325), T(min = 0, start = 298.15);
    Real Pbubl(start = 101325, min = 0)"Bubble point pressure", Pdew(start = 101325, min = 0)"dew point pressure";
  equation
//Mole Balance
    F_p[1] = F_p[2] + F_p[3];
    x_pc[1, :] .* F_p[1] = x_pc[2, :] .* F_p[2] + x_pc[3, :] .* F_p[3];

  //Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ philbubl_c[:]);
  //Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* phivdew_c[:]);
    if P >= Pbubl then
      x_pc[3, :] = zeros(Nc);
  //    sum(x_pc[2, :]) = 1;
      F_p[3] = 0;
    elseif P >= Pdew then
    //VLE region
      for i in 1:Nc loop
  //      x_pc[3, i] = K[i] * x_pc[2, i];
        x_pc[2, i] = x_pc[1, i] ./ (1 + xvap * (K[i] - 1));
      end for;
      sum(x_pc[2, :]) = 1;
    //sum y = 1
    else
    //above dew point region
      x_pc[2, :] = zeros(Nc);
  //    sum(x_pc[3, :]) = 1;
      F_p[2] = 0;
    end if;
  //Energy Balance
    for i in 1:Nc loop
//Specific Heat and Enthalpy calculation
      Cp_pc[2, i] = Thermodynamic_Functions.LiqCpId(comp[i].LiqCp, T);
      Cp_pc[3, i] = Thermodynamic_Functions.VapCpId(comp[i].VapCp, T);
      H_pc[2, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      H_pc[3, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      (S_pc[2, i], S_pc[3, i]) = Thermodynamic_Functions.SId(comp[i].AS, comp[i].VapCp, comp[i].HOV, comp[i].Tb, comp[i].Tc, T, P, x_pc[2, i], x_pc[3, i]);
    end for;
    for i in 2:3 loop
      Cp_p[i] = sum(x_pc[i, :] .* Cp_pc[i, :]) + Cpres_p[i];
      H_p[i] = sum(x_pc[i, :] .* H_pc[i, :]) + Hres_p[i];
      S_p[i] = sum(x_pc[i, :] .* S_pc[i, :]) + Sres_p[i];
    end for;
    Cp_p[1] = xliq * Cp_p[2] + xvap * Cp_p[3];
    Cp_pc[1, :] = x_pc[1, :] .* Cp_p[1];
    H_p[1] = xliq * H_p[2] + xvap * H_p[3];
    H_pc[1, :] = x_pc[1, :] .* H_p[1];
    S_p[1] = xliq * S_p[2] + xvap * S_p[3];
    S_pc[1, :] = x_pc[1, :] * S_p[1];
//phase molar fractions
    xliq = F_p[2] / F_p[1];
    xvap = F_p[3] / F_p[1];
  end Flash;