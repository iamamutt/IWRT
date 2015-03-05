function GazeData = ParseGazeData(LeftEyeArray, RightEyeArray)
%Turn left and right gaze arrays into structs

if ~isempty(LeftEyeArray)
    GazeData.left_eye_ucs.x = LeftEyeArray(:, 1);
    GazeData.left_eye_ucs.y = LeftEyeArray(:, 2);
    GazeData.left_eye_ucs.z = LeftEyeArray(:, 3);
    GazeData.left_eye_tcs.x = LeftEyeArray(:, 4);
    GazeData.left_eye_tcs.y = LeftEyeArray(:, 5);
    GazeData.left_eye_tcs.z = LeftEyeArray(:, 6);
    GazeData.left_gaze_acs.x = LeftEyeArray(:, 7);
    GazeData.left_gaze_acs.y = LeftEyeArray(:, 8);
    GazeData.left_gaze_ucs.x = LeftEyeArray(:, 9);
    GazeData.left_gaze_ucs.y = LeftEyeArray(:, 10);
    GazeData.left_gaze_ucs.z = LeftEyeArray(:, 11);
    GazeData.left_pupil_diameter = LeftEyeArray(:, 12);
    GazeData.left_validity = round(LeftEyeArray(:, 13));
end

if ~isempty(RightEyeArray)
    GazeData.right_eye_ucs.x = RightEyeArray(:, 1);
    GazeData.right_eye_ucs.y = RightEyeArray(:, 2);
    GazeData.right_eye_ucs.z = RightEyeArray(:, 3);
    GazeData.right_eye_tcs.x = RightEyeArray(:, 4);
    GazeData.right_eye_tcs.y = RightEyeArray(:, 5);
    GazeData.right_eye_tcs.z = RightEyeArray(:, 6);
    GazeData.right_gaze_acs.x = RightEyeArray(:, 7);
    GazeData.right_gaze_acs.y = RightEyeArray(:, 8);
    GazeData.right_gaze_ucs.x = RightEyeArray(:, 9);
    GazeData.right_gaze_ucs.y = RightEyeArray(:, 10);
    GazeData.right_gaze_ucs.z = RightEyeArray(:, 11);
    GazeData.right_pupil_diameter = RightEyeArray(:, 12);
    GazeData.right_validity = round(RightEyeArray(:, 13));
end

end
