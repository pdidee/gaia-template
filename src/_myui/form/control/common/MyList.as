package _myui.form.control.common
{
   import com.greensock.TweenMax;
   
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   import myLib.form.IField;
   
   public class MyList extends MovieClip
   {
      // fla
      public var mcMsk:MovieClip;
      public function get identifier():Object { return getChildAt(numChildren-1); }
      
      // callback
      public var onItemClick:Function;
      
      // info1
      public var canScroll:Boolean = false;
      public var SCROLL_SPEED:Number = 50;
      public var rowCount:int = 5;
      public var mskRef:Number = 70;
      public var listHeight:Number = 0;
      
      // info2
      protected var _selectedIndex:int = -1;
      
      // cell
      protected var boxPos:Point = new Point(0, 7);
      protected var listBox:Sprite = new Sprite();
      protected var listPool:Vector.<MyListCell> = new Vector.<MyListCell>();
      
      public function MyList()
      {
         super();
         
         mouseChildren = true;
         tabEnabled = false;
         
         // mask
         mcMsk.alpha = 1;
         
         // cell
         listBox.y = boxPos.y;
         listBox.mask = mcMsk;
         addChildAt(listBox, getChildIndex(mcMsk));
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                             item
      
      public function addItem(label:String, data:* = null, enable:Boolean = true):void
      {
         var cls:Class = getDefinitionByName(identifier.name) as Class;
         var item:MyListCell = new cls();
         item.label = label;
         item.data = data;
         item.onClickHandler = _onItemClick;
         if (enable) item.enable() else item.disable();
         
         item.y = listPool.length * item.mcClick.height;
         listBox.addChild(item);
         
         listPool.push(item);
         listHeight += item.cellHeight;
         
         if (listPool.length > rowCount && !hasEventListener(MouseEvent.MOUSE_WHEEL))
         {
            addEventListener(MouseEvent.MOUSE_WHEEL, scroll);
         }
      }
      
      // todo
      public function removeItemAt(index:uint):void
      {
         if (index >= listPool.length) return;
         
         // view
         listBox.removeChild(listPool[index]);
         // data
         listHeight -= listPool[index].cellHeight;
         listPool.splice(index, 1);
         
         // rearrange
         for (var i:int = index; i < listPool.length; ++i) 
         {
            listPool[i].y = i * listPool[i].cellHeight;
         }
      }
      
      public function removeAll():void
      {
         while (listBox.numChildren) listBox.removeChildAt(0);
         listPool = new Vector.<MyListCell>();
         listHeight = 0;
      }
      
      public function resetListPosition():void
      {
         TweenMax.to(listBox, 0, {y:boxPos.y});
      }
      
      public function resetSelection():void { _selectedIndex = -1; }
      
      public function get selectedIndex():int { return _selectedIndex; }
      public function get selectedLabel():String { return listPool[_selectedIndex].label; }
      public function get selectedData():* { return listPool[_selectedIndex].data; }
      public function get length():uint { return listPool.length; }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
      }
      
      protected function onRemove(e:Event):void
      {
         // mouse
         removeEventListener(MouseEvent.MOUSE_WHEEL, scroll);
      }
      
      // ________________________________________________
      //                                    mouse handler
      
      protected function scroll(e:MouseEvent):void
      {
         if (alpha < 1 || !visible || !canScroll) return;
         
         var newy:Number = listBox.y + (e.delta / Math.abs(e.delta) * SCROLL_SPEED || 0);
         if (newy > boxPos.y)
         {
            newy = boxPos.y;
         }
         else if (newy < bottomLimit)
         {
            newy = bottomLimit;
         }
         
         TweenMax.to(listBox, 0.2, {y:newy});
      }
      
      protected function get bottomLimit():Number { return boxPos.y - listHeight + mskRef; }
      
      protected function _onItemClick(item:MyListCell):void
      {
         // index
         _selectedIndex = listPool.indexOf(item);
         
         if (onItemClick as Function)
         {
            onItemClick();
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}