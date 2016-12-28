classdef LinkerController < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axes;
        bgDraw;
        func1;
        func2;
        indicesCell;
        sList;
    end
    
    properties(Access = private)
        fgCell1;
        fgCell2;
        pointSize;
        groupNum;
    end
    
    properties(Constant)
        ActiveBGColor = [1,1,1];
        DeActiveBGColor = [0.9,0.9,0.9];
        ActiveTag = [0.47,0.67,0.19];
        DeActiveTag = [0.85,0.33,0.1];
    end
    
    methods
        function obj = LinkerController(func1,func2,varargin)
            obj.bgDraw = cell(1,2);
            obj.axes = cell(1,2);
            obj.func1 = func1;
            obj.func2 = func2;
            obj.indicesCell = cell(0);
            obj.sList = cell(0);
            obj.fgCell1 = cell(0);
            obj.fgCell2 = cell(0);
            if ~isempty(varargin)
                obj.pointSize = varargin{1};
            else
                obj.pointSize = 8;
            end
            obj.groupNum = 0;
            LinkPloter(obj);
        end
        function addAxes(obj,ah1,ah2)
            obj.axes{1} = ah1;
            set(ah1,'NextPlot','add');
            obj.axes{2} = ah2;
            set(ah2,'NextPlot','add');
            h1= obj.func1(ah1);
            set(h1,'ButtonDownFcn',@(varargin)disp(1))
            h2= obj.func2(ah2);
            set(h2,'ButtonDownFcn',@(varargin)disp(2))
            obj.bgDraw{1}=h1;
            obj.bgDraw{2}=h2;
        end
        function addRegion(obj,n,isHold,curGroupNum)
            rect = getrect(obj.axes{n});
            bL = LinkerController.inRect(obj.bgDraw{n}.XData,obj.bgDraw{n}.YData,rect);
            if sum(bL)<=0 
                return;
            else 
                if(isHold)
                    bL = or(obj.indicesCell{curGroupNum},bL);
                    set(obj.fgCell1{curGroupNum},'XData',obj.bgDraw{1}.XData(bL),...
                                         'YData',obj.bgDraw{1}.YData(bL));
                    set(obj.fgCell2{curGroupNum},'XData',obj.bgDraw{2}.XData(bL),...
                                         'YData',obj.bgDraw{2}.YData(bL));
                    obj.indicesCell{curGroupNum} = bL;
                else
                    obj.indicesCell{end+1}=bL;
                    obj.sList{end+1} = strcat('Group:',' ',num2str(obj.groupNum));
                    obj.groupNum = obj.groupNum + 1;
                    obj.fgCell1{end+1} = scatter(obj.axes{1},obj.bgDraw{1}.XData(bL),...
                                                obj.bgDraw{1}.YData(bL),...
                                                obj.pointSize,'filled');
                    obj.fgCell2{end+1} = scatter(obj.axes{2},obj.bgDraw{2}.XData(bL),...
                                                obj.bgDraw{2}.YData(bL),...
                                                obj.pointSize,'filled');  
                end        
            end
        end
        
        function clearRegion(obj,n)
            if and(n>0,n<=length(obj.fgCell1))
                delete(obj.fgCell1{n});
                delete(obj.fgCell2{n});
                obj.fgCell1(n) = [];
                obj.fgCell2(n) = [];
                obj.sList(n) = [];
            end    
        end
        
        function setVis(obj,n)
            if and(n<=length(obj.fgCell1),n>0)
                for m=1:1:length(obj.fgCell1)
                    set(obj.fgCell1{m},'Visible','off');
                    set(obj.fgCell2{m},'Visible','off');
                end
                set(obj.fgCell1{n},'Visible','on');
                set(obj.fgCell2{n},'Visible','on');
            else if n<0
                    for m=1:1:length(obj.fgCell1)
                        set(obj.fgCell1{m},'Visible','on');
                        set(obj.fgCell2{m},'Visible','on');
                    end
                end
            end
        end
    end
    
    methods(Static)
        function boolList = inRect(aryX,aryY,rect)
            dx = aryX - rect(1);
            dy = aryY - rect(2);
            boolX = and(dx > 0,dx<rect(3));
            boolY = and(dy > 0,dy<rect(4));
            boolList = and(boolX,boolY);
        end
    end
    
end

