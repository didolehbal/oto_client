package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.map.LosDetector;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.Dofus1Line;
   import com.ankamagames.jerakine.utils.display.Dofus2Line;
   
   public class IAInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function IAInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:Selection = null;
         var _loc5_:uint = 0;
         var _loc6_:MapPoint = null;
         var _loc7_:uint = 0;
         var _loc8_:Selection = null;
         var _loc9_:Lozenge = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:MapPoint = null;
         var _loc14_:MapPoint = null;
         var _loc15_:Vector.<uint> = null;
         var _loc16_:Selection = null;
         var _loc17_:uint = 0;
         var _loc18_:MapPoint = null;
         var _loc19_:uint = 0;
         var _loc20_:MapPoint = null;
         var _loc21_:* = undefined;
         var _loc22_:int = 0;
         var _loc23_:IDataMapProvider = DataMapProvider.getInstance();
         switch(param2)
         {
            case "debuglos":
               if(param3.length != 2)
               {
                  if(_loc4_ = SelectionManager.getInstance().getSelection("CellsFreeForLOS"))
                  {
                     _loc4_.remove();
                     param1.output("Selection cleared");
                  }
                  else
                  {
                     param1.output("Arguments needed : cell and range");
                  }
               }
               else if(param3.length == 2)
               {
                  _loc5_ = uint(param3[0]);
                  _loc6_ = MapPoint.fromCellId(_loc5_);
                  _loc7_ = uint(param3[1]);
                  _loc8_ = new Selection();
                  _loc10_ = (_loc9_ = new Lozenge(0,_loc7_,_loc23_)).getCells(_loc5_);
                  _loc8_.renderer = new ZoneDARenderer();
                  _loc8_.color = new Color(26112);
                  _loc8_.zone = new Custom(LosDetector.getCell(_loc23_,_loc10_,_loc6_));
                  SelectionManager.getInstance().addSelection(_loc8_,"CellsFreeForLOS");
                  SelectionManager.getInstance().update("CellsFreeForLOS");
               }
               return;
            case "calculatepath":
            case "tracepath":
               if(param3.length != 2)
               {
                  if(_loc4_ = SelectionManager.getInstance().getSelection("CellsForPath"))
                  {
                     _loc4_.remove();
                     param1.output("Selection cleared");
                  }
                  else
                  {
                     param1.output("Arguments needed : start and end of the path");
                  }
               }
               else if(param3.length == 2)
               {
                  _loc11_ = uint(param3[0]);
                  _loc12_ = uint(param3[1]);
                  _loc13_ = MapPoint.fromCellId(_loc12_);
                  if(_loc23_.height == 0 || _loc23_.width == 0 || !_loc23_.pointMov(_loc13_.x,_loc13_.y,true))
                  {
                     param1.output("Problem with the map or the end.");
                  }
                  else
                  {
                     _loc14_ = MapPoint.fromCellId(_loc11_);
                     _loc15_ = Pathfinding.findPath(_loc23_,_loc14_,_loc13_).getCells();
                     if(param2 == "calculatepath")
                     {
                        param1.output("Path: " + _loc15_.join(","));
                        return;
                     }
                     (_loc16_ = new Selection()).renderer = new ZoneDARenderer();
                     _loc16_.color = new Color(26112);
                     _loc16_.zone = new Custom(_loc15_);
                     SelectionManager.getInstance().addSelection(_loc16_,"CellsForPath");
                     SelectionManager.getInstance().update("CellsForPath");
                  }
               }
               return;
            case "debugcellsinline":
               if(param3.length != 2)
               {
                  if(_loc4_ = SelectionManager.getInstance().getSelection("CellsFreeForLOS"))
                  {
                     _loc4_.remove();
                     param1.output("Selection cleared");
                  }
                  else
                  {
                     param1.output("Arguments needed : cell and cell");
                  }
               }
               else if(param3.length == 2)
               {
                  _loc17_ = uint(param3[0]);
                  _loc18_ = MapPoint.fromCellId(_loc17_);
                  _loc19_ = uint(param3[1]);
                  _loc20_ = MapPoint.fromCellId(_loc19_);
                  _loc21_ = !!Dofus1Line.useDofus2Line?Dofus2Line.getLine(_loc18_.cellId,_loc20_.cellId):Dofus1Line.getLine(_loc18_.x,_loc18_.y,0,_loc20_.x,_loc20_.y,0);
                  _loc8_ = new Selection();
                  _loc10_ = new Vector.<uint>();
                  _loc22_ = 0;
                  while(_loc22_ < _loc21_.length)
                  {
                     _loc10_.push(MapPoint.fromCoords(_loc21_[_loc22_].x,_loc21_[_loc22_].y).cellId);
                     _loc22_++;
                  }
                  _loc8_.renderer = new ZoneDARenderer();
                  _loc8_.color = new Color(26112);
                  _loc8_.zone = new Custom(_loc10_);
                  SelectionManager.getInstance().addSelection(_loc8_,"CellsFreeForLOS");
                  SelectionManager.getInstance().update("CellsFreeForLOS");
               }
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "debuglos":
               return "Display all cells which have LOS with the given cell. No argument will clear the selection if any.";
            case "calculatepath":
               return "List all cells of the path between two cellIds.";
            case "tracepath":
               return "Display all cells of the path between two cellIds. No argument will clear the selection if any.";
            case "debugcellsinline":
               return "Display all cells of line between two cellIds. No argument will clear the selection if any.";
            default:
               return "Unknown command";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
