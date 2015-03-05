function PlotCalibrationPoints(calibStrct, Calib, pointOrder)
%PLOTCALIBRATIONPOINTS plots the calibration data for a calibration session

close All

rect = Calib.screen;
figh = figure('menuBar','none','name','Calibration Acc. - Press any key to continue','Color', [0.5, 0.5 0.5],'Renderer', 'Painters','keypressfcn','close;');
axes('Visible', 'off', 'Units', 'normalize','Position', [0 0 1 1],'DrawMode','fast','NextPlot','replacechildren');

figloc.x = rect(3)+1;
figloc.y = rect(2);
figloc.width =  rect(3);
figloc.height =  rect(4);

set(figh,'position',[figloc.x figloc.y figloc.width figloc.height]);

Calib.mondims = figloc;
xlim([1,Calib.mondims.width]);
ylim([1,Calib.mondims.height]);axis ij;
set(gca,'xtick',[]);set(gca,'ytick',[]);

hold on
[~, ~, avgerr] = ComputeCalibError(calibStrct, rect(3), rect(4));
cerr = round(100*(mean(avgerr)/Calib.error));
terr = ['Avg. calibration: ', num2str(cerr), '% of allowable error (', num2str(Calib.error),'px). Must be < 100%'];

for i = 1:length(calibStrct)
    plot(Calib.mondims.width*calibStrct(i).origs(1),...
        Calib.mondims.height*calibStrct(i).origs(2),...
        'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',20);
    
    for j = 1:size(calibStrct(i).point,2)
        if (calibStrct(i).point(j).validity(1)==1)
            line([Calib.mondims.width*calibStrct(i).origs(1) Calib.mondims.width*calibStrct(i).point(j).left(1)],...
                [Calib.mondims.height*calibStrct(i).origs(2) Calib.mondims.height*calibStrct(i).point(j).left(2)],...
                'Color','b');
            plot(Calib.mondims.width*calibStrct(i).point(j).left(1),...
                Calib.mondims.height*calibStrct(i).point(j).left(2),...
                'o','MarkerEdgeColor','b','MarkerSize',8);
        end
        if (calibStrct(i).point(j).validity(2)==1)
            line([Calib.mondims.width*calibStrct(i).origs(1) Calib.mondims.width*calibStrct(i).point(j).right(1)],...
                [Calib.mondims.height*calibStrct(i).origs(2) Calib.mondims.height*calibStrct(i).point(j).right(2)],...
                'Color','r');
            plot(Calib.mondims.width*calibStrct(i).point(j).right(1),...
                Calib.mondims.height*calibStrct(i).point(j).right(2),...
                'o','MarkerEdgeColor','r','MarkerSize',8);
        end
    end
    
    % draw point number
    for n = 1:Calib.points.n
        a = strcmp(num2str(calibStrct(i).origs(1)),num2str(Calib.points.x(pointOrder(n))));
        b = strcmp(num2str(calibStrct(i).origs(2)),num2str(Calib.points.y(pointOrder(n))));
        if ( a && b)
            px = Calib.mondims.width*calibStrct(i).origs(1);
            py = Calib.mondims.height*calibStrct(i).origs(2);
            text(double(px),double(py),num2str(pointOrder(n)),'FontSize',15,'color','white');
        end
    end
end

if cerr < 100
    tcolor = 'green';
else
    tcolor = 'yellow';
end

text(Calib.mondims.width*0.1,Calib.mondims.height*0.1, terr, 'FontSize',10,'color',tcolor);

drawnow

clc

%disp('Close plot window or press any key on plot window to continue');
end
