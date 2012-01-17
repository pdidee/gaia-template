package casts.friend
{
   import _extension.Trace2;
   
   import _myui.canvas.StageCanvas;
   import _myui.scrollbar.MySlider1;
   
   import _weibo.WeiboMgr;
   
   import casts._lightbox.BaseLightbox;
   
   import com.gaiaframework.api.Gaia;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.loading.LoaderMax;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class FriendMain extends BaseLightbox
   {
      // fla
      public var mcDialog:MovieClip; // a dialog that is shown when mouse over.
      public var mcFBox:MovieClip; // friend box container.
      public var btnSlider:MySlider1; // scroll bar.
      public var btnClose:MyButton;
      public var btnSubmit:MyButton;
      
      // posittion of mcDialog
      private var dpos:Point;
      
      // box pool
      private var totalLoader:LoaderMax;
      private var boxPool:Vector.<FriendBoxEX>;
      
      // select pool
      private const SELECT_MAX:int = 3; // selection limits.
      private var selectPool:Vector.<FriendBoxEX>;
      
      public function FriendMain()
      {
         super();
         
         blendMode = BlendMode.LAYER;
         mcDialog.mouseEnabled = mcDialog.mouseChildren = false;
         
         // gs
         TweenPlugin.activate([BlurFilterPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                       transition
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
               }
            }
         );
         
         // [init]
         initSlider();
         initButton();
         TweenMax.to(this, 0, {autoAlpha:0, scaleX:1, scaleY:1});
         // dialog
         TweenMax.to(mcDialog, 0, {autoAlpha:0});
         dpos = new Point(mcFBox.x, mcFBox.y);
         addEventListener(MouseEvent.MOUSE_MOVE, dialogFollow);
         
         // [actions]
         cmd.insert(TweenMax.to(this, 0.5, {autoAlpha:1}));
         
         cmd.delay = 0.4;
         cmd.play();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
         returnToParent();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
                  transitionOutComplete();
               }
            }
         );
         
         // [init]
         destroySlider();
         removeEventListener(MouseEvent.MOUSE_MOVE, dialogFollow);
         // [actions]
         cmd.insert(TweenMax.to(this, 0.5, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         returnToParent();
      }
      
      // ################### protected ##################
      
      override protected function onStageResize(e:Event=null):void
      {
         x = (sw>>1) - (GB.DocWidth>>1);
         y = (sh>>1) - (GB.DocHeight>>1);
      }
      
      // ________________________________________________
      //                                           slider
      
      protected function initSlider():void
      {
         if (!WeiboMgr.api.friends) return;
         
         var offx:Number = 60;
         var offy:Number = 69;
         
         // friend
         var boxWidth:Number = Math.floor(WeiboMgr.api.friends.length / 2) + 1;
         totalLoader = new LoaderMax();
         boxPool = new Vector.<FriendBoxEX>();
         for (var i:int = 0; i < WeiboMgr.api.friends.length; ++i) 
         {
            var box:FriendBoxEX = new FriendBoxEX();
            box.x = 11 + Math.floor(i/2) * offx;
            box.y = 18 + (i%2) * offy;
            box.uid = WeiboMgr.api.friends[i].uid;
            box.nickname = WeiboMgr.api.friends[i].name;
            box.onOverHandler = onFBoxOver;
            box.onOutHandler = onFBoxOut;
            box.onClickHandler = onFBoxClick;
            mcFBox.addChild(box);
            
            boxPool.push(box);
            
            totalLoader.append(box.getLoader(WeiboMgr.api.friends[i].profile_image_url));
         }
         totalLoader.load(true);
         
         // box bg
         mcFBox.graphics.clear();
         mcFBox.graphics.beginFill(0x0000ff, 0);
         mcFBox.graphics.drawRect(0, 0, boxWidth * offx, 120);
         mcFBox.graphics.endFill();
         
         btnSlider.ta = mcFBox;
         btnSlider.barRef = 408;
         btnSlider.mskRef = 490;
         btnSlider.taInitPos = new Point(230, 219);
         
         mcFBox.x = btnSlider.taInitPos.x;
         mcFBox.y = btnSlider.taInitPos.y;
         
         // select
         selectPool = new Vector.<FriendBoxEX>();
      }
      
      protected function destroySlider():void
      {
         while (mcFBox.numChildren) mcFBox.removeChildAt(0);
         if (totalLoader) totalLoader.dispose(true);
         Trace2(mcFBox.numChildren);
      }
      
      // ________________________________________________
      //                                           button
      
      protected function initButton():void
      {
         btnClose.gotoAndStop(1);
         btnClose.buttonMode = true;
         btnClose.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            transitionOut();
         };
         
         btnSubmit.gotoAndStop(1);
         btnSubmit.buttonMode = true;
         btnSubmit.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            if (Gaia.api.getCurrentBranch() == 'root/list')
            {
               transitionOut();
            }
            else
            {
               Gaia.api.goto('root/list');
            }
         };
      }
      
      // #################### private ###################
      
      private function onFBoxOver(e:MouseEvent):void
      {
         var btn:FriendBoxEX = FriendBoxEX(e.currentTarget);
         var pos1:Point = btn.localToGlobal(new Point());
         dpos = globalToLocal(pos1);
         TweenMax.to(mcDialog, 0.5, {autoAlpha:1});
         
         setOverName(btn.nickname);
      }
      
      private function onFBoxOut(e:MouseEvent):void
      {
         TweenMax.to(mcDialog, 0.5, {autoAlpha:0});
      }

      private function onFBoxClick(e:MouseEvent):void
      {
         var btn:FriendBoxEX = FriendBoxEX(e.currentTarget);
         var no:int = selectPool.indexOf(btn);
         
         if (no == -1 && selectPool.length < SELECT_MAX)
         {
            selectPool.push(btn);
            btn.highlightIt();
         }
         else
         {
            selectPool.splice(no, 1);
            btn.unHighlightIt();
         }
         
         if (selectPool.length == SELECT_MAX)
         {
            for each (var i:FriendBoxEX in boxPool) 
            {
               if (-1 == selectPool.indexOf(i))
               {
                  i.disableIt();
               }
               else
               {
                  i.enableIt();
               }
            }
         }
         else
         {
            for each (i in boxPool) 
            {
               i.enableIt();
            }
         }
      }
      
      // ________________________________________________
      //                                mouse over (name)
      
      private function dialogFollow(e:MouseEvent):void
      {
         TweenMax.to(mcDialog, 0.4, {x:dpos.x, y:dpos.y});
      }
      
      private function get dialogName():TextField { return TextField(mcDialog.tfName); }
      private function get dialogMsk():MovieClip { return MovieClip(mcDialog.mcMsk); }
      private function get dialogBg():MovieClip { return MovieClip(mcDialog.mcBg); }
      
      private function setOverName(v:String):void
      {
         dialogName.text = v;
         dialogName.width = dialogName.textWidth + 30; // adjust width
         TweenMax.to(dialogMsk, 0.3, {width:dialogName.width}); // adjust width
         TweenMax.to(dialogBg, 0.3, {width:dialogName.width}); // adjust width
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}