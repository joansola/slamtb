function Rob = resetMotion(Rob);

Rob.state.x = epose2qpose(zeros(6,1));
Rob.state.P = zeros(7,7);
