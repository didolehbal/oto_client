package com.ankamagames.berilia.utils
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import nochump.util.zip.ZipEntry;
   import nochump.util.zip.ZipFile;
   import org.as3commons.bytecode.abc.AbcFile;
   import org.as3commons.bytecode.abc.ClassInfo;
   import org.as3commons.bytecode.swf.SWFFile;
   import org.as3commons.bytecode.swf.SWFFileIO;
   import org.as3commons.bytecode.tags.DoABCTag;
   import org.as3commons.bytecode.tags.FileAttributesTag;
   
   public class ModuleInspector
   {
      
      public static const whiteList:Array = new Array("dm","swf","xml","txt","png","jpg","css");
       
      
      public function ModuleInspector()
      {
         super();
      }
      
      public static function checkArchiveValidity(param1:ZipFile) : Boolean
      {
         var _loc2_:ZipEntry = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         for each(_loc2_ in param1.entries)
         {
            _loc3_ = _loc2_.name.lastIndexOf(".");
            _loc4_ = _loc2_.name.substring(_loc3_ + 1);
            if(!_loc2_.isDirectory() && whiteList.indexOf(_loc4_) == -1)
            {
               return false;
            }
            _loc5_ = _loc5_ + _loc2_.size;
         }
         return _loc5_ < ModuleFileManager.MAX_FILE_SIZE && param1.size < ModuleFileManager.MAX_FILE_NUM;
      }
      
      public static function getDmFile(param1:File) : XML
      {
         var _loc2_:File = null;
         var _loc3_:XML = null;
         var _loc4_:FileStream = null;
         var _loc5_:ByteArray = new ByteArray();
         if(param1.exists)
         {
            for each(_loc2_ in param1.getDirectoryListing())
            {
               if(!_loc2_.isDirectory)
               {
                  if(_loc2_.type == ".dm")
                  {
                     if(_loc2_.name.lastIndexOf("/") != -1)
                     {
                        return null;
                     }
                     (_loc4_ = new FileStream()).open(File(_loc2_),FileMode.READ);
                     _loc4_.readBytes(_loc5_,0,_loc4_.bytesAvailable);
                     _loc4_.close();
                     return new XML(_loc5_.readUTFBytes(_loc5_.bytesAvailable));
                  }
               }
            }
         }
         return null;
      }
      
      public static function getZipDmFile(param1:ZipFile) : XML
      {
         var _loc2_:ZipEntry = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:ByteArray = new ByteArray();
         for each(_loc2_ in param1.entries)
         {
            if(!_loc2_.isDirectory())
            {
               _loc4_ = _loc2_.name.lastIndexOf(".");
               if((_loc5_ = _loc2_.name.substring(_loc4_ + 1)).toLowerCase() == "dm")
               {
                  if(_loc2_.name.lastIndexOf("/") != -1)
                  {
                     return null;
                  }
                  _loc6_ = ZipFile(param1).getInput(_loc2_);
                  return new XML(_loc6_.readUTFBytes(_loc6_.bytesAvailable));
               }
            }
         }
         return null;
      }
      
      public static function isModuleEnabled(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:*;
         if((_loc4_ = StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_MOD,param1)) == null)
         {
            _loc3_ = param2;
         }
         else
         {
            _loc3_ = _loc4_ || param2;
         }
         return _loc3_;
      }
      
      public static function checkIfModuleTrusted(param1:String) : Boolean
      {
         var _loc2_:FileStream = null;
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         var _loc5_:Signature = null;
         var _loc6_:File = new File(param1);
         var _loc7_:Dictionary = UiModuleManager.getInstance().modulesHashs;
         if(_loc6_.exists)
         {
            _loc2_ = new FileStream();
            _loc2_.open(_loc6_,FileMode.READ);
            _loc3_ = new ByteArray();
            _loc2_.readBytes(_loc3_);
            _loc2_.close();
            if(_loc6_.type == ".swf")
            {
               return MD5.hashBytes(_loc3_) == _loc7_[_loc6_.name];
            }
            if(_loc6_.type == ".swfs")
            {
               _loc4_ = new ByteArray();
               return (_loc5_ = new Signature(SignedFileAdapter.defaultSignatureKey)).verify(_loc3_,_loc4_);
            }
         }
         return false;
      }
      
      public static function getScriptHookAndAction(param1:ByteArray) : Object
      {
         var _loc2_:DoABCTag = null;
         var _loc3_:AbcFile = null;
         var _loc4_:ClassInfo = null;
         var _loc5_:FileAttributesTag = null;
         var _loc6_:Array = null;
         var _loc7_:* = new Object();
         var _loc8_:SWFFileIO;
         var _loc9_:SWFFile = (_loc8_ = new SWFFileIO()).read(param1);
         _loc7_.actions = new Array();
         _loc7_.apis = new Array();
         _loc7_.hooks = new Array();
         for each(_loc2_ in _loc9_.getTagsByType(DoABCTag))
         {
            _loc3_ = _loc2_.abcFile;
            for each(_loc4_ in _loc3_.classInfo)
            {
               switch(_loc4_.classMultiname.nameSpace.name)
               {
                  case "d2hooks":
                     _loc7_.hooks.push(_loc4_.classMultiname.name);
                     continue;
                  case "d2actions":
                     _loc7_.actions.push(_loc4_.classMultiname.name);
                     continue;
                  case "d2api":
                     _loc7_.apis.push(_loc4_.classMultiname.name);
                     continue;
                  default:
                     continue;
               }
            }
         }
         _loc6_ = _loc9_.getTagsByType(FileAttributesTag);
         for each(_loc5_ in _loc6_)
         {
            _loc7_.useNetwork = _loc5_.useNetwork;
         }
         return _loc7_;
      }
   }
}
