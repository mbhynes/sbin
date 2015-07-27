% 
% /home/mike/gantt_plot.m
% =================================================
% Author: Michael B Hynes, mbhynes@uwaterloo.ca
% License: GPL 3
% Creation Date: Sat 06 Jun 2015 11:43:03 AM EDT
% Last Modified: Wed 10 Jun 2015 10:49:21 PM EDT
% =================================================

function gantt_plot()
	global TASK_HEIGHT = 1;
	total_slots = 32;
	fprintf('Finding files that match prefix..\n');
	tic
	[files,nums] = get_task_files();
	toc
	for k = 1 : length(files)
		file = files{k};
		fprintf('Plotting tasks from %s\n',file);
		plot([0,30],(k-1)*total_slots*TASK_HEIGHT*[1 1],'k--')
		hold on;
		plot_tasks(file,(k-1)*total_slots*TASK_HEIGHT,total_slots)
	end
	hold off;
	% set(gca,'yticklabel',files);
end

% plot all the tasks for a single node
function plot_tasks(file,yvalue,total_slots)
	global TASK_HEIGHT;
	if (nargin == 2)
		total_slots = 16;
	end
	[task_times,task_nums] = get_task_info(file);
	fprintf('Done loading task info from %s\n',file);
	ntasks = length(task_times);

	% store the time at which each slot becomes free
	slot_times = zeros(1,total_slots);
	k = 1;
	while (k < ntasks)
		t1 = task_times(k,1);
		t2 = task_times(k,2);
		delta = t1 - slot_times;
		candidates = find(delta > 0);
		if isempty(candidates)
			fprintf('WARNING: Conflict for slots! Everything is busy, but another task is running!');
			slot_num = 1;
		else
			slot_num = candidates(1);
		end
		% [val,slot_num] = max(delta);
		% if isinf(slot_times(slot_num))
		% 	fprintf('WARNING: Inf value found; something quirky is happening in scheduler.');
		% end
		slot_times(slot_num) = t2;
		% slot_times(slot_times < t2) = t2;
		fprintf('Task %d: time %f: duration %f: slot %d\n',k,t1,t2-t1,slot_num);
		plot_gantt_task(task_times(k,:),yvalue + 0.99*(slot_num - 1)*TASK_HEIGHT,TASK_HEIGHT,task_nums(k));
		% input('continue');
		hold on
		k++;
	end
end

function plot_gantt_task(times,yvalue,height,task_num);
	colour = [0.4 0.5 0.3];
	rectangle('position',[times(1) yvalue times(2)-times(1) height],'facecolor',colour);
	% mid = mean(times);
	% text(mid,yvalue,num2str(task_num));
end

function [t,n] = get_task_info(file)
	dat = dlmread(file);
	t = [dat(:,1), dat(:,1)+dat(:,end)]/1000;
	n = [dat(:,4)];
end

function [t,nums] = get_stage_times(file)
	dat = dlmread(file);
	t = [dat(:,1) ]/1000;
end

function [files,nums] = get_task_files()
	prefix='tasks-';
	suffix='.csv';
	[files,nums] = match_files(prefix,suffix);
end

function plot_stage_lines(t,vert_points,ls)
	if ( nargin == 1 )
		vert_points = [ ]
	end
	x = nan(1,3*length(t));
	x(1:3:end) = t;
	x(2:3:end) = t;
	y = x;
	y(1:3:end) = vert_points(1);
	y(2:3:end) = vert_points(2);
	plot(x,y,ls);
end
