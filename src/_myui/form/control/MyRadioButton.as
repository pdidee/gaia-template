package _myui.form.control
{
   import _myui.form.data.KeyNode;
   
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   /**
    * RadioButton
    * @author boy, cjboy1984@gmail.com
    * // Suggest to inherit this class.
    * // Override the following function, onOver, onOut, onClick, setSelected and setNonSelected.
    * group = 'abc_group';
    * selected = false;
    * // get selected one by the group
    * MyRadioButton.getSelect('abc');
    */
   public class MyRadioButton extends MovieClip
   {
      // select
      protected var _selected:Boolean = false;
      // group
      protected var _group:String;
      // pool
      protected static var pool:Vector.<KeyNode> = new Vector.<KeyNode>();
      
      public function MyRadioButton()
      {
         super();
         
         group = 'default';
         buttonMode = true;
         mouseChildren = false;
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                            group

      public function get group():String { return _group; }
      public function set group(v:String):void 
      {
         var no:int = 0;
         var lists:Vector.<Object>;
         
         // old
         if (_group != v && pool.length > 0)
         {
            for each (var node:KeyNode in pool) 
            {
               // remove from array.
               if (_group == node.key)
               {
                  node.remove(this);
                  // whether to remove the array
                  if (node.length == 0)
                  {
                     pool.splice(no, 1);
                  }
                  break;
               }
               ++no;
            }
         }
         
         _group = v;
         lists = getGroups(_group);
         var newNode:KeyNode;
         if (lists)
         {
            no = lists.indexOf(this);
            if (no == -1)
            {
               lists.push(this); 
            }
            else
            {
               lists.push(this);
            }
         }
         else
         {
            newNode = new KeyNode(_group);
            newNode.push(this);
            pool.push(newNode);
         }
         
         // debug
//         printPool();
      }
      
      public static function getSelect($group:String):Object
      {
         var lists:Vector.<Object> = getGroups($group);
         for each (var obj:Object in lists) 
         {
            if (obj.selected)
            {
               return obj;
            }
         }
         return null;
      }
      
      public function get selected():Boolean { return _selected; }
      public function set selected(v:Boolean):void
      {
         _selected = v;
         if (_selected)
         {
            var lists:Vector.<Object> = getGroups(_group);
            for each (var obj:Object in lists) 
            {
               if (obj == this)
               {
                  obj.setSelected();
               }
               else
               {
                  obj._selected = false;
                  obj.setNonSelected();
               }
            }
         }
         else
         {
            setNonSelected();
         }
      }
      
      // ________________________________________________
      //                                            utils
      
      public function printPool():void
      {
         for each (var node:KeyNode in pool) 
         {
            trace(node.length, node);
         }
      }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
         addEventListener(MouseEvent.ROLL_OVER, onOver);
         addEventListener(MouseEvent.ROLL_OUT, onOut);
         addEventListener(MouseEvent.CLICK, onClick);
      }
      
      protected function onRemove(e:Event):void
      {
         removeEventListener(MouseEvent.ROLL_OVER, onOver);
         removeEventListener(MouseEvent.ROLL_OUT, onOut);
         removeEventListener(MouseEvent.CLICK, onClick);
      }
      
      // ________________________________________________
      //                                     mouse action
      
      protected function onOver(e:MouseEvent):void
      {
      }
      
      protected function onOut(e:MouseEvent):void
      {
      }
      
      protected function onClick(e:MouseEvent):void
      {
      }
      
      // ________________________________________________
      //                                    select action
      
      protected function setSelected():void
      {
         if (!buttonMode) return;
         gotoAndStop(2);
      }
      
      protected function setNonSelected():void
      {
         if (!buttonMode) return;
         gotoAndStop(1);
      }
      
      // ________________________________________________
      //                                            group
      
      protected static function getGroups($group:String):Vector.<Object>
      {
         for each (var node:KeyNode in pool) 
         {
            if ($group == node.key)
            {
               return node.datas;
            }
         }
         return null;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}