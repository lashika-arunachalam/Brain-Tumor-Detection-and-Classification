
function varargout = mainfile(varargin)
% MAINFILE MATLAB code for mainfile.fig

% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainfile_OpeningFcn, ...
                   'gui_OutputFcn',  @mainfile_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code 

function mainfile_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for mainfile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = mainfile_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in IMPORTIMAGE.
function IMPORTIMAGE_Callback(hObject, eventdata, handles)

global Im path
[fname,path]=uigetfile('T/*.jpg');
Im=imread(fullfile(path,fname));
Im=imresize(Im,[256,256]);

axes(handles.a1);
imshow(Im);

title('Test Image')

% --- Executes on button press in PREPROCESSIMAGE.
function PREPROCESSIMAGE_Callback(hObject, eventdata, handles)

global Im G
%% preprocessimage
if size(Im,3)==3
G=rgb2gray(Im);
else
    G=Im;
end

%% filtering
[M,N]=size(G);
G=medfilt2(G,[3,3]);
axes(handles.a2);
imshow(uint8(G));
title('Preprocessed image');

% --- Executes on button press in SEGMENTIMAGE.
function SEGMENTIMAGE_Callback(hObject, eventdata, handles)

global Im G
%% Kmeans

wd=256;
Im2=imresize(Im,[256,256]);

% Convert to grayscale
if size(Im2,3)==3
    Im2=rgb2gray(Im2);
else
    Im2=Im2;
end

% Get the dimension of the Image
[r c] = size(Im2);
Length = r*c; 

% Create a one-dimensional array of the Image
Dataset = reshape(Im2,[Length,1]);

% Declare the number of clusters
Clusters=5;

% Initialize an array for each cluster
Cluster1=zeros(Length,1);
Cluster2=zeros(Length,1);
Cluster3=zeros(Length,1);
Cluster4=zeros(Length,1);
Cluster5=zeros(Length,1);

% Identify the extremas of the Image values
miniv = min(min(Im2));
maxiv = max(max(Im2));

% Evaluate the range and step size 
range = maxiv - miniv;
stepv = range/Clusters;
incrval = stepv;

% Initialize a centroid vector
for i = 1:Clusters
    K(i).centroid = incrval;
    % Increment the step
    incrval = incrval + stepv;
end

% Initialize the update variables
update1=0;
update2=0;
update3=0;
update4=0;
update5=0;

% Initialize the mean variables
means1=2;
means2=2;
means3=2;
means4=2;
means5=2;

% Iterate while all the means are not equal to the corresponding updates
while ((means1 ~= update1) & (means2 ~= update2) & (means3 ~= update3) & (means4 ~= update4) & (means5 ~= update5))
    
    % Obtain the mean from the previous iteration
    means1=K(1).centroid;
    means2=K(2).centroid;
    means3=K(3).centroid;
    means4=K(4).centroid;
    means5=K(5).centroid;
    
    % For each element in the Image
    for i=1:Length
        % For each of the clusters
        for j = 1:Clusters
            temp= Dataset(i);
            % Move the centroid
            difference(j) = abs(temp-K(j).centroid);
        end
        
        [y,ind]=min(difference);

        if ind==1
            Cluster1(i) = temp;
        end
        if ind==2
            Cluster2(i) = temp;
        end
        if ind==3
            Cluster3(i) = temp;
        end
        if ind==4
            Cluster4(i) = temp;
        end
        if ind==5
            Cluster5(i) = temp;
        end
    end
    
    % Count variable for each of the clusters
    cout1=0;
    cout2=0;
    cout3=0;
    cout4=0;
    cout5=0;
    
    for i=1:Length
        % Current cluster location
        Load1=Cluster1(i);
        Load2=Cluster2(i);
        Load3=Cluster3(i);
        Load4=Cluster4(i);
        Load5=Cluster5(i);

        % Increase the location by 1 unless it is 0
        if Load1 ~= 0
            cout1=cout1+1;
        end
        
        if Load2 ~= 0
            cout2=cout2+1;
        end

        if Load3 ~= 0
            cout3=cout3+1;
        end

        if Load4 ~= 0
            cout4=cout4+1;
        end
        
        if Load5 ~= 0
            cout5=cout5+1;
        end

    end
    
    % Calculate the mean cluster value
    Mean_Cluster(1)=sum(Cluster1)/cout1;
    Mean_Cluster(2)=sum(Cluster2)/cout2;
    Mean_Cluster(3)=sum(Cluster3)/cout3;
    Mean_Cluster(4)=sum(Cluster4)/cout4;
    Mean_Cluster(5)=sum(Cluster5)/cout5;

    % Update the centroids
    for i = 1:Clusters
        K(i).centroid = Mean_Cluster(i);
    end
    update1=K(1).centroid;
    update2=K(2).centroid;
    update3=K(3).centroid;
    update4=K(4).centroid;
    update5=K(5).centroid;

end

% Representative of each cluster
AA1=reshape(Cluster1,[wd wd]);
AA2=reshape(Cluster2,[wd wd]);
AA3=reshape(Cluster3,[wd wd]);
AA4=reshape(Cluster4,[wd wd]);
AA5=reshape(Cluster5,[wd wd]);

% Display the last image 
vector_image = AA5

axes(handles.a3);
imshow(vector_image);
title('Segmented  image');
vector_image = uint8(vector_image);

%% Skull removal
[M,N]=size(G);
G=medfilt2(G);

%% binarization using otsu method
th=graythresh(G);
B=im2bw(G,th);

%% morphological operation
SE = strel('periodicline', 2,[1 2]); %
B=imopen(B,SE);

B=bwareaopen(B,2000);
B=bwmorph(B,'erode');
B=imfill(B,'holes');

%%  find tumor
vector_image=vector_image.*uint8(B);
vector_image=vector_image>=230;
vector_image=bwareaopen(vector_image,50);
if nnz(vector_image) == 0 
    tu = 'Output : No Tumor';
    set(handles.tu,'string',num2str(tu));
else
    tr = 'Output : Tumor Detected';
    set(handles.tr,'string',num2str(tr));
end    
    
axes(handles.a4);
imshow(vector_image);
title('Detected Tumor');

%%  extract features
global Contrast Correlation Energy Homogeneity Area Mean StandardDeviation Entropy RMS Variance Smoothness Kurtosis Skewness IDM

%select region of interest
G=double(G);
ROI=zeros(M,N);
ROI(B)=G(B);

%Create gray-level co-occurrence matrix from image
glcm = graycomatrix(ROI);

%Properties of gray-level co-occurrence matrix
stats = graycoprops(glcm,'all');

Contrast=stats.Contrast;

%Correlation
Correlation=stats.Correlation;

%Energy
Energy=stats.Energy;

%.homogeneity
Homogeneity=stats.Homogeneity;

%% area
Area=nnz(B)/numel(B);

Mean = mean2(ROI);
StandardDeviation = std2(ROI);
Entropy = entropy(ROI);
RMS = mean2(rms(ROI));
Variance = mean2(var(double(ROI)));
a = sum(double(ROI(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(ROI(:)));
Skewness = skewness(double(ROI(:)));

% Inverse Difference Movement
m = size(ROI,1);
n = size(ROI,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = ROI(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
fet=[Contrast,Correlation,Energy,Homogeneity,Area,Mean, StandardDeviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];

% --- Executes on button press in DETECTTUMOR.
function DETECTTUMOR_Callback(hObject, eventdata, handles)

% --- Executes on button press in EXTRACTFEATURES.
function EXTRACTFEATURES_Callback(hObject, eventdata, handles)

global Contrast Correlation Energy Homogeneity Area Mean StandardDeviation Entropy RMS Variance Smoothness Kurtosis Skewness IDM

set(handles.Contrast,'string',num2str(Contrast));
set(handles.Correlation,'string',num2str(Correlation));
set(handles.Energy,'string',num2str(Energy));
set(handles.Homogeneity,'string',num2str(Homogeneity));
set(handles.Area,'string',num2str(Area));
set(handles.Mean,'string',num2str(Mean));
set(handles.StandardDeviation,'string',num2str(StandardDeviation));
set(handles.Entropy,'string',num2str(Entropy));
set(handles.RMS,'string',num2str(RMS));
set(handles.Variance,'string',num2str(Variance));
set(handles.Smoothness,'string',num2str(Smoothness));
set(handles.Kurtosis,'string',num2str(Kurtosis));
set(handles.Skewness,'string',num2str(Skewness));
set(handles.IDM,'string',num2str(IDM));

% --- Executes on button press in CLASSIFICATION.
function CLASSIFICATION_Callback(hObject, eventdata, handles)

classify

% --- Executes on button press in REFRESH.
function REFRESH_Callback(hObject, eventdata, handles)

close(mainfile);
close(classify);
mainfile
