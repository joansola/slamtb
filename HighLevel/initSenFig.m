function SenFig = initSenFig(Sen)

% initialize the figure for each sensors.
% the figure id begin at '10' and grow by 1-steps until all sensors

SenFig.figs = [] ; % array of figures


for sen = 1:numel(Sen)
    
    % Sen(sen).imSize
    
    % Figure
    SenFig.figs(sen).fig = figure(9+sen); % if sen==1, [figure_id=10]
    set(SenFig.figs(sen).fig,...
        'renderer','opengl');
    %     'position',[ 1   331   410   340],...
    clf
    
    
    % Sensor type:
    % ------------
    switch Sen(sen).type
        
        % camera pinhole
        % --------------
        case {'pinHole'}
            % axes
            axis equal
            ax21 = gca;
            set(get(ax21,'title'),...
                'string',['Robot [',Sen(sen).robot,']''s sensor [',Sen(sen).name,'] view [',Sen(sen).type,']']);
            set(ax21,...
                'position',[.05 .05 .9 .9],...
                'xlim',[0 Sen(sen).imSize(1)],...
                'xaxislocation','top',...
                'ylim',[0,Sen(sen).imSize(2)],... % size of the image of sensor
                'ydir','reverse',...
                'layer','top',...
                'fontsize',8);  
            

        % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
        % case {'newSensor'}
            % do something
        
        
        % unknown
        % -------
        otherwise
            % TODO : print an error and go out
            fprintf(['\n Error, the sensor type is unknows in (initSenFig.m), cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,'!\n\n\n']);
    end

end



