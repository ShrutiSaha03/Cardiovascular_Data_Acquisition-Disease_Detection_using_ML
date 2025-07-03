
%PPG 
clc
clearvars
close all 



[fname,path]=uigetfile('*.txt','-ascii');% select the unfiltered file 
fname1 = strrep(fname,'.txt',''); %remove .txt from name ; strrep=string replace 




fname = strcat(path,fname);
y=load(fname);
y = y(:,2);% select data column
N = size(y);



txt = sprintf('Total data poin available:%d\n',N(1,1));
disp(txt)
L = input('Enter data points required:');


y =y (1:L);
ppg=y;
N=length(ppg);
fs=250;%sample freq
t=(0:N-1)/fs;%corresponding time vector 



% figure(1);
% plot(t,ppg);
% xlabel('time(s)')
% ylabel('Amp(v)')
% title('original PPG wave');
% grid on 


% Band pass filtering 

fn = fs/2;%Nyquist criterion 
N = 2;
[a,b] = butter(N,[0.03 10]/fn);% 2nd order Butterworth fill
ppg2 = filtfilt(a,b,ppg); % filtfilt helps avoiding phase distortion


base = ppg - ppg2 ;% baseline drift between raw & filtered signal 
N1 = length(ppg2);
t1 = (0:N1-1)/fs;


% figure(2);
% plot(t1,ppg2,'r','Linewidth',2);
% xlabel('time(s)')
% ylabel('Amp(v)')
% title(' PPG wave after bandpass filter ');
% grid on 



%---plot multiple figures in the same window
figure(3);
plot(t,ppg,'g','LineWidth',2);
xlabel("time(S)")
ylabel('Amplitude(V)')
title("Original PPG Waveform and signal after bandpass filtering")
grid on
hold on %command matlab to hold on to add another plot
plot(t1,ppg2,'r','LineWidth',2);
hold off



%Amplitude Normalization through dynamic range matching
MX1 = max(ppg);
MN1 = min(ppg);
D1 = MX1 - MN1 ; %Spread of the original signal

MX2 = max(ppg);
MN2 = min(ppg);
D2 = MX2 - MN2 ; %Sprea of the filtered signal

D =D1/D2; %spread ratio

ppg3 = ppg*D; %Scale the filtered signal to match its dynamic range with the original
ppg4 = ppg3-min(ppg3); %Removes negative amplitudes

figure(4);
subplot(2,1,1)
plot(t1,ppg-min(ppg),'b','LineWidth',2);
xlabel('Time (S)')
ylabel('Amplitude(V)')
title('Original PPG waveform');
subplot(2,1,2)
plot(t1,ppg4,'r',t1,(ppg-min(ppg)-ppg4),'k--','LineWidth',2);
ylim([-0.5 1.5])
legend('Filtered PPG','Baseline')
xlabel('Time (S)')
ylabel('Amplitude(V)')
title('BP filtered PPG waveform with the removed baseline');


fname2 = strcat(fname1,'_filtered.txt');% file name ta change holo ; 'NORMAL_PPG_1' theke 'NORMAL_PPG_1_filtered.txt'
save(fname2,'ppg4','-ascii');

