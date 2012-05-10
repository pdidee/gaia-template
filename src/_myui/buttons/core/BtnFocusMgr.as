package _myui.buttons.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   /**
    * It's just like a model for MyPlayer basing on MVC-pattern. Example:
    * 
    * @auther  boy, cjboy1984@gmail.com
    * @date    May,8,2012
    */
   public class BtnFocusMgr extends EventDispatcher
   {
      // Event
      public static const MOUSEOVER_CHANGE:String = 'MOUSEOVER_CHANGE';
      public static const MOUSEOUT_CHANGE:String = 'MOUSEOUT_CHANGE';
      public static const MOUSECLICK_CHANGE:String = 'MOUSECLICK_CHANGE';
      public static const HIGHLIGHT_CHANGE:String = 'HIGHLIGHT_CHANGE';
      
      public var overOne:*;
      public var outOne:*;
      public var clickOne:*
      public var hightlightOne:*;
      
      // A static lists saving instance of MyFocusMgr class.
      private var mgrPool:Dictionary = new Dictionary();
      
      // singleton
      private static var instance:BtnFocusMgr;
      
      // --------------------- LINE ---------------------
      
      public function BtnFocusMgr(pvt:PrivateClass)
      {
         // DO NOTHING
      }
      
      // ________________________________________________
      //                                             init
      
      public function init():void
      {
         // DO NOTHING, just make sure there's only one this singleton class.
      }
      
      /**
       * To get the responding reference of FocusMgr.
       */
      public function getMgr(id:String):BtnFocusMgr
      {
         // Initialize the lists if it is null.
         if (!mgrPool)
         {
            mgrPool = new Vector.<BtnFocusMgr>();
         }
         
         // Whether to create a new instance or NOT.
         var mgr:BtnFocusMgr = BtnFocusMgr(mgrPool[id]);
         if (mgr == null)
         {
            mgr = new BtnFocusMgr(new PrivateClass());
            mgrPool[id] = mgr;
         }
         
         return mgr;
      }
      
      /**
       * Destory the dictionary.
       */
      public function dispose():void
      {
         mgrPool = null;
      }
      
      // ________________________________________________
      //                                            focus
      
      public function setMouseOverFocus(v:*):void
      {
         overOne = v;
         dispatchEvent(new Event(MOUSEOVER_CHANGE));
      }
      
      public function setMouseOutFocus(v:*):void
      {
         outOne = v;
         dispatchEvent(new Event(MOUSEOUT_CHANGE));
      }
      
      public function setMouseClickFocus(v:*):void
      {
         clickOne = v;
         dispatchEvent(new Event(MOUSECLICK_CHANGE));
      }
      
      public function setHightlightFocus(v:*):void
      {
         hightlightOne = v;
         dispatchEvent(new Event(HIGHLIGHT_CHANGE));
      }
      
      // ________________________________________________
      //                                        singleton
      
      public static function get api():BtnFocusMgr
      {
         if (!instance)
         {
            instance = new BtnFocusMgr(new PrivateClass());
         }
         
         return instance;
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

class PrivateClass
{
   public function PrivateClass() {}
}