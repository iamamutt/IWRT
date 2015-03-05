function WriteTobiiData(tobiifile, lefteye, righteye, gazetimes, tettimes, ptbtimes)
%Write tobii data to file

outData = horzcat(double(gazetimes), double(tettimes), double(ptbtimes), double(lefteye), double(righteye));

tobiiWrite = fopen(tobiifile, 'w');

tobiiHeaders = {'tet_musec', 'tet_musec_onset', 'ptb_musec_onset', ...
    'left_eye_ucs_x','left_eye_ucs_y','left_eye_ucs_z',...
    'left_eye_tcs_x','left_eye_tcs_y','left_eye_tcs_z',...
    'left_gaze_acs_x','left_gaze_acs_y',...
    'left_gaze_ucs_x','left_gaze_ucs_y','left_gaze_ucs_z',...
    'left_pupil_diameter','left_validity',...
    'right_eye_ucs_x','right_eye_ucs_y','right_eye_ucs_z',...
    'right_eye_tcs_x','right_eye_tcs_y','right_eye_tcs_z',...
    'right_gaze_acs_x','right_gaze_acs_y',...
    'right_gaze_ucs_x','right_gaze_ucs_y','right_gaze_ucs_z',...
    'right_pupil_diameter','right_validity'};

writeLine(tobiiWrite, tobiiHeaders);

for i = 1:size(outData, 1)
    for j = 1:size(outData, 2)
        if j ~= size(outData, 2)
            fprintf(tobiiWrite, '%f,', outData(i,j));
        else
            fprintf(tobiiWrite, '%f\n', outData(i,j));
        end
    end
end

fclose(tobiiWrite);

end