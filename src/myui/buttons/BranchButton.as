package myui.buttons
{
   import casts.impls.IAddRemove;
   
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * @author  cjboy | cjboy1984@gmail.com
    * @date    Nov,02,2011
    * @usage
    * branch = 'root/home';
    * // or
    * branch = 'root/home*';
    * trace(isMatchBranch()); // true | false
    * 
    *          onOver      : The action of Mouse-ROLL_OVER.
    *          onOut       : The action of Mouse-ROLL_OUT.
    *          onClick     : The action of Mouse-Click.
    * e.g.
    * onClick = function()
    * {
    *    // DO SOMETHING
    * }
    *
    *          onClickEvt  : The action of Mouse-ROLL_OVER.
    *          onOutEvt    : The action of Mouse-ROLL_OUT.
    *          onClickEvt  : The action of Mouse-Click.
    * e.g.
    * btnAAA.onClickEvt = onMouseClick;
    *
    * private function onMouseClick(e:MouseEvent):void
    * {
    *    // DO SOMETHING
    * }
    */
   public class BranchButton extends MovieClip implements IAddRemove
   {
      // easy function ( without arguments )
      public var onClick:Function = null;
      public var onOver:Function = null;
      public var onOut:Function = null;
      
      // easy event function
      public var onClickEvt:Function = null;
      public var onOverEvt:Function = null;
      public var onOutEvt:Function = null;
      
      // branch
      public var branch:String = '';
      
      public function BranchButton()
      {
         super();
         
         tabEnabled = false;
         tabChildren = false;
         focusRect = false;
         mouseChildren = false; // true | false
         buttonMode = true;
         
         stop();
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * Tell you is the branch match the framework.
       * With fuzzy search:
       * branch = 'root/home*';
       */
      public function isMatchBranch($branch:String):Boolean
      {
         var star:int = branch.indexOf('*');
         if (star == -1) // no fuzzy
         {
            return ($branch == branch);
         }
         else if (star == 0) // '*' means match all
         {
            return true;
         }
         else // fuzzy
         {
            var b4star:String = branch.substr(0, star);
            return ($branch.indexOf(b4star) != -1)
         }
         
         return false;
      }
      
      /**
       * Return a string without "*"
       */
      public function getValidBranch():String
      {
         var star:int = branch.indexOf('*');
         if (star == -1)
         {
            return branch;
         }
         else
         {
            return branch.substr(0, star);
         }
      }
      
      // --------------------- LINE ---------------------
      
      public function onAdd(e:Event):void
      {
         addEventListener(MouseEvent.ROLL_OVER, _onOver);
         addEventListener(MouseEvent.ROLL_OUT, _onOut);
         addEventListener(MouseEvent.CLICK, _onClick);
      }
      
      public function onRemove(e:Event):void
      {
         removeEventListener(MouseEvent.ROLL_OVER, _onOver);
         removeEventListener(MouseEvent.ROLL_OUT, _onOut);
         removeEventListener(MouseEvent.CLICK, _onClick);
         
         // tween
         TweenMax.killTweensOf(this);
      }
      
      // ################### protected ##################
      
      protected function _onOver(e:MouseEvent = null):void
      {
         if (onOver != null)
         {
            onOver();
         }
         else if (onOverEvt != null)
         {
            onOverEvt(e);
         }
         else
         {
            if (buttonMode)
            {
               TweenMax2.frameTo(this, totalFrames);
            }
         }
      }
      
      protected function _onOut(e:MouseEvent = null):void
      {
         if (onOut != null)
         {
            onOut();
         }
         else if (onOutEvt != null)
         {
            onOutEvt(e);
         }
         else
         {
            if (buttonMode)
            {
               TweenMax2.frameTo(this, 1);
            }
         }
      }
      
      protected function _onClick(e:MouseEvent = null):void
      {
         if (!buttonMode) return;
         
         // timeline based function call (without arguements)
         if (onClick != null)
         {
            onClick();
         }
         
         // function call with MouseEvent
         if (onClickEvt != null)
         {
            onClickEvt(e);
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}