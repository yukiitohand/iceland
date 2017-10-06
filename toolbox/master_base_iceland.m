function [mbase] = master_base_iceland(d,sensorID)
% create a base basename from the name of the directroy and sensorID
%   Input parameters
%     d: directroy name, such as 'GU20160726_120703_0101'
%     sensorID: sensor ID {'L', 'S'}
%   Output
%     mbase: base of the basename of the images, such as 'GU2611L_120703'

dcell = strsplit(d,'_');
baseID = [d(1:2) d(9:10) d(20) d(22)];
mbase = [baseID sensorID '_' dcell{2} '_'];

end