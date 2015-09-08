function [Facs, newFactors] = makeGtsamFactors(Rob,Sen,Lmks,Obss,Frms,Facs,Opt,newFactors)

import gtsam.*

facs = [Facs.used];

verboseCheirality = Opt.map.gtsam.verboseCheirality;
throwCheirality = Opt.map.gtsam.throwCheirality;

for fac = [Facs(facs).fac]
    switch Facs(fac).type
        case 'absolute'
            if ~isempty(Facs(fac).frames)
                newFactors.add( PriorFactorPose3(                   ... % Pose prior:
                    symbol('x',Frms( Facs(fac).frames).id),         ... %   Frame key
                    qpose2gtsampose( Facs(fac).meas.y),             ... %   Prior measurement
                    noiseModel.Gaussian.Covariance( Facs(fac).err.Z))); %   Prior Error
            else
                error('GTSAM prior factor on idpLmk not yet implemented');
            end
            
        case 'motion'
            newFactors.add( BetweenFactorPose3(                ... % Motion factor:
                symbol('x',Frms(Facs(fac).frames(1)).id),      ... %   'From' frame key
                symbol('x',Frms(Facs(fac).frames(2)).id),      ... %   'To' frame key
                qpose2gtsampose( Facs(fac).meas.y ),           ... %   Motion measurement
                noiseModel.Gaussian.Covariance(Facs(fac).err.Z))); %   Motion error
            
        case 'measurement'
            % Only add factors to a landmark if it was set to be optimized
            if ~Lmks(Facs(fac).lmk).optim
                continue;
            end
            % TODO: Add support to camera with distortion
            calibration = Cal3_S2(                                         ... % Calibration WITHOUT distortion:
                Sen(Facs(fac).sen).par.k(3), Sen(Facs(fac).sen).par.k(4),  ... %   au, av
                0,                                                         ... %   skew
                Sen(Facs(fac).sen).par.k(1), Sen(Facs(fac).sen).par.k(2));     %   u0, v0
            switch Lmks(Facs(fac).lmk).type
                case 'papPnt'
                    if numel(Facs(fac).frames) == 1
                        newFactors.add( PAPoint3MainAnchorProjectionFactorCal3_S2( ... % Pap projection factor for a measurement from the main anchor:
                            Point2(Facs(fac).meas.y),                                ... %   Image measurement
                            noiseModel.Gaussian.Covariance(Facs(fac).err.Z),         ... %   Image measurement error
                            symbol('x',Frms(Facs(fac).frames).id),                   ... %   Main anchor frame key
                            symbol('l',Lmks(Facs(fac).lmk).id),                      ... %   Landmark key
                            calibration,                                             ... %   Camera calibration
                            throwCheirality, verboseCheirality,                      ... %   Flags: throw Cheirality? verbose Cheyrality?
                            qpose2gtsampose( Sen(Facs(fac).sen).frame.x )));             %   Camera pose in robot frame
                    elseif numel(Facs(fac).frames) == 2
                        newFactors.add( PAPoint3AssoAnchorProjectionFactorCal3_S2( ... % Pap projection factor for a measurement from the associated anchor:
                            Point2(Facs(fac).meas.y),                               ... %   Image measurement
                            noiseModel.Gaussian.Covariance(Facs(fac).err.Z),        ... %   Image measurement error
                            symbol('x',Frms(Facs(fac).frames(1)).id),               ... %   Main anchor frame key
                            symbol('x',Frms(Facs(fac).frames(2)).id),               ... %   Associated anchor frame key
                            symbol('l',Lmks(Facs(fac).lmk).id),                     ... %   Landmark key
                            calibration,                                            ... %   Camera calibration
                            throwCheirality, verboseCheirality,                     ... %   Flags: throw Cheirality? verbose Cheyrality?
                            qpose2gtsampose( Sen(Facs(fac).sen).frame.x )));            %   Camera pose in robot frame
                            
                    elseif numel(Facs(fac).frames) == 3
                        newFactors.add( PAPoint3ProjectionFactorCal3_S2(     ... % Pap projection factor for a measurement from another frame (not the ancrhos):
                            Point2(Facs(fac).meas.y),                        ... %   Image measurement
                            noiseModel.Gaussian.Covariance(Facs(fac).err.Z), ... %   Image measurement error
                            symbol('x',Frms(Facs(fac).frames(1)).id),        ... %   Main anchor frame key
                            symbol('x',Frms(Facs(fac).frames(2)).id),        ... %   Associated anchor frame key
                            symbol('x',Frms(Facs(fac).frames(3)).id),        ... %   Frame key from where the measurement was taken
                            symbol('l',Lmks(Facs(fac).lmk).id),              ... %   Landmark key
                            calibration,                                     ... %   Camera calibration
                            throwCheirality, verboseCheirality,              ... %   Flags: throw Cheirality? verbose Cheyrality?
                            qpose2gtsampose( Sen(Facs(fac).sen).frame.x )));     %   Camera pose in robot frame
                    else
                        error('??? Something went wrong: papPnt meas factor has ''%s'' frames (3 frames max allowed).', numel(Fac.frames))
                    end
                    
                otherwise
                    error('??? GTSAM projection factor to lmk type ''%s'' not yet implemented.', Lmks(Fac.lmk).type);
                    
            end
            
        otherwise
                error('??? GTSAM projection factor to factor type ''%s'' not yet implemented.', Fac.type);
                
    end
    
end

end

