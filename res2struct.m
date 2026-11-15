function [Results] = res2struct(resul_graf)

% This function group the results obtained in a structur

Results.Crank_Angle          = resul_graf(:,1);
Results.Pressure             = resul_graf(:,2);
Results.Volume               = resul_graf(:,3);
Results.Fuel_mass            = resul_graf(:,4);
Results.Exhaust_gas_mass     = resul_graf(:,5);
Results.Air_mass             = resul_graf(:,6);
Results.Compression_ratio    = resul_graf(:,7);
Results.Gas_temperature      = resul_graf(:,8);
Results.Blow_by_mass         = resul_graf(:,9);
Results.Evaporated_mass      = resul_graf(:,10);
Results.Intake_mass          = resul_graf(:,11);
Results.Internal_energy      = resul_graf(:,12);
Results.Work                 = resul_graf(:,13);
Results.Fuel_Internal_energy = resul_graf(:,14);
Results.DFQL                 = resul_graf(:,15);
Results.dQ_Woschni           = resul_graf(:,16);
Results.ebb                  = resul_graf(:,17);
Results.FQL                  = resul_graf(:,18);

